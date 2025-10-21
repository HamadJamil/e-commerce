import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/shared/models/user_model.dart';
import 'package:e_commerce/shared/models/address.dart';
import 'package:e_commerce/shared/models/cart_item.dart';
import 'package:e_commerce/shared/models/order.dart' as models;

class FirestoreService {
  final FirebaseFirestore _firestore;
  final CollectionReference _users;

  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _users = (firestore ?? FirebaseFirestore.instance).collection('users');

  Future<void> createOrUpdateUser(String uid, UserModel user) async {
    await _users.doc(uid).set(user.toMap(), SetOptions(merge: true));
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<void> addFavorite(String uid, int productId) async {
    final docRef = _users.doc(uid);
    await docRef.set({
      'favoriteProductIds': FieldValue.arrayUnion([productId]),
    }, SetOptions(merge: true));
  }

  Future<void> removeFavorite(String uid, int productId) async {
    final docRef = _users.doc(uid);
    await docRef.update({
      'favoriteProductIds': FieldValue.arrayRemove([productId]),
    });
  }

  Future<void> addAddress(String uid, Address address) async {
    final docRef = _users.doc(uid);
    await docRef.set({
      'addresses': FieldValue.arrayUnion([address.toMap()]),
    }, SetOptions(merge: true));
  }

  Future<void> removeAddress(String uid, String addressId) async {
    final docRef = _users.doc(uid);

    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      if (!snap.exists) return;
      final data = snap.data() as Map<String, dynamic>;
      final list = (data['addresses'] as List<dynamic>?) ?? [];
      final newList = list
          .where((e) => (e is Map && (e['id'] as String) != addressId))
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      tx.update(docRef, {'addresses': newList});
    });
  }

  Future<void> updateAddress(String uid, Address address) async {
    final docRef = _users.doc(uid);
    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      if (!snap.exists) return;
      final data = snap.data() as Map<String, dynamic>;
      final list = (data['addresses'] as List<dynamic>?) ?? [];
      final newList = list.map((e) {
        final m = Map<String, dynamic>.from(e);
        if (m['id'] == address.id) {
          return address.toMap();
        }
        return m;
      }).toList();
      tx.update(docRef, {'addresses': newList});
    });
  }

  Future<void> addPhone(String uid, String phone) async {
    final docRef = _users.doc(uid);
    await docRef.set({
      'phones': FieldValue.arrayUnion([phone]),
    }, SetOptions(merge: true));
  }

  Future<void> addOrUpdateCartItem(String uid, CartItem item) async {
    final docRef = _users.doc(uid);
    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      final data = snap.exists ? snap.data() as Map<String, dynamic> : {};
      final list =
          (data['cartItems'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          [];
      final existingIndex = list.indexWhere((e) {
        try {
          return (e['product'] as Map<String, dynamic>)['id'] ==
              item.product.id;
        } catch (_) {
          return false;
        }
      });
      if (existingIndex >= 0) {
        final existing = CartItem.fromJson(
          Map<String, dynamic>.from(list[existingIndex]),
        );
        existing.quantity = item.quantity;
        list[existingIndex] = existing.toJson();
      } else {
        list.add(item.toJson());
      }
      tx.set(docRef, {'cartItems': list}, SetOptions(merge: true));
    });
  }

  Future<void> removeCartItem(String uid, int productId) async {
    final docRef = _users.doc(uid);
    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      if (!snap.exists) return;
      final data = snap.data() as Map<String, dynamic>;
      final list =
          (data['cartItems'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          [];
      list.removeWhere((e) {
        try {
          return (e['product'] as Map<String, dynamic>)['id'] == productId;
        } catch (_) {
          return false;
        }
      });
      tx.update(docRef, {'cartItems': list});
    });
  }

  Future<void> clearCart(String uid) async {
    await _users.doc(uid).update({'cartItems': []});
  }

  CollectionReference _ordersRef(String uid) =>
      _users.doc(uid).collection('orders');

  Future<void> addOrder(String uid, models.Order order) async {
    final docRef = _ordersRef(uid).doc(order.id);
    await docRef.set(order.toMap());
  }

  Future<List<models.Order>> getOrders(String uid) async {
    final snap = await _ordersRef(uid).orderBy('date', descending: true).get();
    return snap.docs
        .map((d) => models.Order.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }
}
