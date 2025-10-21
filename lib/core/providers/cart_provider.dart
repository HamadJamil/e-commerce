import 'package:e_commerce/core/services/firestore_service.dart';
import 'package:e_commerce/shared/models/cart_item.dart';
import 'package:e_commerce/shared/models/product_model.dart';
import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  final FirestoreService? _firestoreService;

  List<CartItem> get items => _items;

  double get actualAmount {
    return _items.fold(0, (sum, item) => sum + item.actualPrice);
  }

  double get discountedAmount {
    return _items.fold(0, (sum, item) => sum + item.discountedPrice);
  }

  double get totalDiscount {
    return _items.fold(0, (sum, item) => sum + item.totalDiscount);
  }

  CartProvider([this._firestoreService]);

  void setItemsFromCartItems(List<CartItem> items) {
    _items.clear();
    _items.addAll(items);
    notifyListeners();
  }

  Future<void> addToCartForUser(String uid, Product product) async {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();

    if (_firestoreService == null) return;

    try {
      await _firestoreService.addOrUpdateCartItem(uid, _items.last);
    } catch (e) {
      if (index >= 0) {
        _items[index].quantity--;
      } else {
        _items.removeWhere((item) => item.product.id == product.id);
      }
      notifyListeners();
      throw Exception('Failed to add to cart. Please try again.');
    }
  }

  Future<void> removeFromCartForUser(String uid, Product product) async {
    final prev = List<CartItem>.from(_items);
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();

    if (_firestoreService == null) return;

    try {
      await _firestoreService.removeCartItem(uid, product.id);
    } catch (e) {
      _items.clear();
      _items.addAll(prev);
      notifyListeners();
      throw Exception('Failed to remove from cart. Please try again.');
    }
  }

  Future<void> updateQuantityForUser(
    String uid,
    Product product,
    int quantity,
  ) async {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index < 0) return;
    final prevQuantity = _items[index].quantity;
    if (quantity <= 0) {
      final prev = List<CartItem>.from(_items);
      _items.removeAt(index);
      notifyListeners();
      try {
        await _firestoreService?.addOrUpdateCartItem(
          uid,
          CartItem(product: product, quantity: 0),
        );
      } catch (e) {
        _items.clear();
        _items.addAll(prev);
        notifyListeners();
        throw Exception('Failed to update cart. Please try again.');
      }
    } else {
      _items[index].quantity = quantity;
      notifyListeners();
      try {
        await _firestoreService?.addOrUpdateCartItem(uid, _items[index]);
      } catch (e) {
        _items[index].quantity = prevQuantity;
        notifyListeners();
        throw Exception('Failed to update cart. Please try again.');
      }
    }
  }

  Future<void> clearCartForUser(String uid) async {
    final prev = List<CartItem>.from(_items);
    _items.clear();
    notifyListeners();
    try {
      await _firestoreService?.clearCart(uid);
    } catch (e) {
      _items.addAll(prev);
      notifyListeners();
      throw Exception('Failed to clear cart. Please try again.');
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(Product product) {
    return _items.any((item) => item.product.id == product.id);
  }
}
