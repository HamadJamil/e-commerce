import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../shared/models/order.dart';
import '../../shared/models/cart_item.dart';
import '../../shared/models/address.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];
  final Uuid _uuid = Uuid();
  static const _kPrefsKey = 'saved_orders';

  OrderProvider() {
    _loadOrders();
  }

  List<Order> get orders => List.unmodifiable(_orders);

  void addOrder({
    required List<CartItem> items,
    required double total,
    required Address address,
    required String paymentMethod,
  }) {
    final order = Order(
      id: _uuid.v4(),
      items: List<CartItem>.from(items),
      total: total,
      address: address,
      date: DateTime.now(),
      paymentMethod: paymentMethod,
    );
    _orders.insert(0, order);
    _saveOrders();
    notifyListeners();
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_kPrefsKey);
    if (jsonStr == null || jsonStr.isEmpty) return;
    try {
      final List<dynamic> list = json.decode(jsonStr);
      _orders.clear();
      for (var item in list) {
        if (item is Map<String, dynamic>) {
          _orders.add(Order.fromMap(item));
        } else if (item is String) {
          _orders.add(Order.fromJson(item));
        }
      }
      notifyListeners();
    } catch (_) {
      // ignore malformed data
    }
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _orders.map((o) => o.toMap()).toList();
    await prefs.setString(_kPrefsKey, json.encode(list));
  }
}
