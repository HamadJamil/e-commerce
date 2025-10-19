import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../shared/models/order.dart';
import '../../shared/models/cart_item.dart';
import '../../shared/models/address.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];
  final Uuid _uuid = Uuid();

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
    notifyListeners();
  }
}
