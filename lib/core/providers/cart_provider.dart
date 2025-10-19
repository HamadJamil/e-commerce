import 'dart:convert';

import 'package:e_commerce/shared/models/cart_item.dart';
import 'package:e_commerce/shared/models/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  static const String _cartKey = 'cart_items';

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

  CartProvider() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);

      if (cartJson != null) {
        final List<dynamic> cartList = json.decode(cartJson);
        _items.clear();
        _items.addAll(
          cartList.map((itemJson) => CartItem.fromJson(itemJson)).toList(),
        );
        notifyListeners();
        if (kDebugMode) {
          print('Loaded ${_items.length} items from cart');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading cart: $e');
      }
    }
  }

  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(
        _items.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(_cartKey, cartJson);
      if (kDebugMode) {
        print('Saved ${_items.length} items to cart');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving cart: $e');
      }
    }
  }

  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
    _saveCart();
  }

  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
    _saveCart();
  }

  void updateQuantity(Product product, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
      _saveCart();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    _saveCart();
  }

  bool isInCart(Product product) {
    return _items.any((item) => item.product.id == product.id);
  }
}
