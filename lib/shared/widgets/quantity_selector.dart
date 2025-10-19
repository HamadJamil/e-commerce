import 'package:e_commerce/core/providers/cart_provider.dart';
import 'package:e_commerce/shared/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuantitySelector extends StatelessWidget {
  final CartItem item;

  const QuantitySelector({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove, size: 20),
          onPressed: () {
            context.read<CartProvider>().updateQuantity(
              item.product,
              item.quantity - 1,
            );
          },
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(item.quantity.toString()),
        ),
        IconButton(
          icon: Icon(Icons.add, size: 20),
          onPressed: () {
            context.read<CartProvider>().updateQuantity(
              item.product,
              item.quantity + 1,
            );
          },
        ),
      ],
    );
  }
}
