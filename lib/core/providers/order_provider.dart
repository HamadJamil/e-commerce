import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../shared/models/order.dart';
import '../../shared/models/cart_item.dart';
import '../../shared/models/address.dart';
import '../services/firestore_service.dart';
import 'auth_provider.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];
  final Uuid _uuid = Uuid();
  final FirestoreService? _firestoreService;
  final AuthenticationProvider? _auth;

  OrderProvider([this._firestoreService, this._auth]) {
    _init();
  }

  List<Order> get orders => List.unmodifiable(_orders);

  Future<void> _init() async {
    try {
      if (_firestoreService != null && _auth != null) {
        final uid = _auth.currentUser?.uid;
        if (uid != null) {
          final remote = await _firestoreService.getOrders(uid);
          _orders.clear();
          _orders.addAll(remote);
          notifyListeners();
        }
      }
    } catch (_) {
      // Ignore errors during initialization
    }
  }

  Future<Order> addOrder({
    required List<CartItem> items,
    required double total,
    required Address address,
    required String paymentMethod,
  }) async {
    final order = Order(
      id: _uuid.v4(),
      items: List<CartItem>.from(items),
      total: total,
      address: address,
      date: DateTime.now(),
      paymentMethod: paymentMethod,
    );

  _orders.insert(0, order);
  notifyListeners();

    try {
      final uid = _auth?.currentUser?.uid;
      if (uid != null && _firestoreService != null) {
        await _firestoreService.addOrder(uid, order);
      }
    } catch (e) {
      rethrow;
    }
    return order;
  }
}
