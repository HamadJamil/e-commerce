import 'package:e_commerce/shared/models/cart_item.dart';
import 'package:e_commerce/shared/models/address.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final Address address;
  final DateTime date;
  final String paymentMethod;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.address,
    required this.date,
    required this.paymentMethod,
  });
}
