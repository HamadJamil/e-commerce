import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((c) => c.toJson()).toList(),
      'total': total,
      'address': address.toMap(),
      'date': date.toIso8601String(),
      'paymentMethod': paymentMethod,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      items:
          (map['items'] as List<dynamic>?)
              ?.map((e) => CartItem.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
      address: Address.fromMap(Map<String, dynamic>.from(map['address'])),
      date: DateTime.parse(map['date'] as String),
      paymentMethod: map['paymentMethod'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}
