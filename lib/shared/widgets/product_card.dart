import 'package:e_commerce/core/providers/cart_provider.dart';
import 'package:e_commerce/core/providers/favorites_provider.dart';
import 'package:e_commerce/features/home/category_section.dart';
import 'package:e_commerce/features/product/product_detail_screen.dart';
import 'package:e_commerce/shared/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool? isRedacted;

  const ProductCard({super.key, required this.product, this.isRedacted});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final isFavorite = favoritesProvider.isFavorite(product);

        return Card(
          elevation: 2,
          child: Stack(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(product: product),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'product_image_${product.id}',
                        child: Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(product.thumbnail),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(height: 4),
                      Text(
                        product.category.toTitleCase(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '\$${product.discountedPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          if (product.discountPercentage > 0) ...[
                            Spacer(),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 12),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    favoritesProvider.toggleFavorite(product);
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    final isInCart = cartProvider.isInCart(product);
                    return ElevatedButton.icon(
                      onPressed: () {
                        if (isInCart) {
                          cartProvider.removeFromCart(product);
                        } else {
                          cartProvider.addToCart(product);
                        }
                      },
                      icon: Icon(isInCart ? Icons.remove : Icons.add),
                      label: Text(isInCart ? 'Remove' : 'Add to Cart'),
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        minimumSize: Size(double.infinity, 20),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
