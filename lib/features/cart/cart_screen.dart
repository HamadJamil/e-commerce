import 'package:e_commerce/core/providers/cart_provider.dart';
import 'package:e_commerce/core/theme/text_style_helper.dart';
import 'package:e_commerce/shared/widgets/cart_product_card.dart';
import 'package:e_commerce/shared/widgets/snack_bar_helper.dart';
import 'package:e_commerce/features/cart/checkout_screen.dart';
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
                    return CartProductCard(
                      item: item,
                      onRemove: () {
                        context.read<CartProvider>().removeFromCart(
                          item.product,
                        );
                        SnackbarHelper.info(
                          context: context,
                          title: 'Success',
                          message: 'Removed from cart',
                        );
                      },
                    );
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
                'Total Amount',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                '\$${cartProvider.actualAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(),
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CheckoutScreen()),
    );
  }
}
