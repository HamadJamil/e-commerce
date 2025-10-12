// lib/features/cart/cart_screen.dart
import 'package:e_commerce/core/providers/cart_provider.dart';
import 'package:e_commerce/core/theme/text_style_helper.dart';
import 'package:e_commerce/shared/models/cart_item.dart';
import 'package:e_commerce/shared/widgets/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shopping Cart')),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieBuilder.asset(
                    'assets/empty_cart.json',
                    repeat: false,
                    height: 240,
                    width: 240,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add some products to get started',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    return _buildCartItem(item, context);
                  },
                ),
              ),
              _buildTotalSection(cartProvider, context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(CartItem item, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(item.product.thumbnail),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    style: Theme.of(context).textTheme.subtitle1,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${item.product.discountedPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 4),
            QuantitySelector(item: item),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                context.read<CartProvider>().removeFromCart(item.product);
                SnackbarHelper.info(
                  context: context,
                  title: 'Success',
                  message: 'Removed from cart',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection(CartProvider cartProvider, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: Theme.of(
                  context,
                ).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _checkout(context),
              child: Text('Checkout'),
            ),
          ),
        ],
      ),
    );
  }

  void _checkout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Checkout'),
        content: Text('Proceed with checkout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              SnackbarHelper.success(
                context: context,
                title: 'Success',
                message: 'Order placed successfully!',
              );
              context.read<CartProvider>().clearCart();
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

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
