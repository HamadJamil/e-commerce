import 'dart:convert';

import 'package:e_commerce/shared/models/address.dart';
import 'package:e_commerce/shared/models/cart_item.dart';

class UserModel {
  final String username;
  final List<String> phones;
  final List<Address> addresses;
  final List<int> favoriteProductIds;
  final List<CartItem> cartItems;

  UserModel({
    required this.username,
    List<String>? phones,
    List<Address>? addresses,
    List<int>? favoriteProductIds,
    List<CartItem>? cartItems,
  }) : phones = phones ?? [],
       addresses = addresses ?? [],
       favoriteProductIds = favoriteProductIds ?? [],
       cartItems = cartItems ?? [];

  UserModel copyWith({
    String? username,
    List<String>? phones,
    List<Address>? addresses,
    List<int>? favoriteProductIds,
    List<CartItem>? cartItems,
  }) {
    return UserModel(
      username: username ?? this.username,
      phones: phones ?? List<String>.from(this.phones),
      addresses: addresses ?? List<Address>.from(this.addresses),
      favoriteProductIds:
          favoriteProductIds ?? List<int>.from(this.favoriteProductIds),
      cartItems: cartItems ?? List<CartItem>.from(this.cartItems),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'phones': phones,
      'addresses': addresses.map((a) => a.toMap()).toList(),
      'favoriteProductIds': favoriteProductIds,
      'cartItems': cartItems.map((c) => c.toJson()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] as String? ?? '',
      phones:
          (map['phones'] as List<dynamic>?)
              ?.map((e) => e?.toString() ?? '')
              .where((s) => s.isNotEmpty)
              .toList() ??
          [],
      addresses:
          (map['addresses'] as List<dynamic>?)
              ?.map((e) => Address.fromMap(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      favoriteProductIds:
          (map['favoriteProductIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      cartItems:
          (map['cartItems'] as List<dynamic>?)
              ?.map((e) => CartItem.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
