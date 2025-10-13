import 'package:e_commerce/core/providers/cart_provider.dart';
import 'package:e_commerce/core/providers/favorites_provider.dart';
import 'package:e_commerce/core/theme/text_style_helper.dart';
import 'package:e_commerce/shared/models/product_model.dart';
import 'package:e_commerce/shared/widgets/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 8,
                ),
                child: Hero(
                  tag: 'product_image_${product.id}',
                  child: Image.network(product.thumbnail, fit: BoxFit.cover),
                ),
              ),
            ),
            pinned: true,
            actions: [
              Consumer<FavoritesProvider>(
                builder: (context, favoritesProvider, child) {
                  return IconButton(
                    icon: Icon(
                      favoritesProvider.isFavorite(product)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: favoritesProvider.isFavorite(product)
                          ? Colors.red
                          : Colors.white,
                    ),
                    onPressed: () {
                      favoritesProvider.toggleFavorite(product);
                    },
                  );
                },
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.share)),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product.brand,
                    style: Theme.of(
                      context,
                    ).textTheme.subtitle1?.copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        '\$${product.discountedPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      if (product.discountPercentage > 0) ...[
                        SizedBox(width: 12),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${product.discountPercentage.toStringAsFixed(1)}% OFF',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(height: 24),
                  _buildRatingSection(),
                  SizedBox(height: 24),
                  _buildProductDetails(),
                  SizedBox(height: 24),
                  _buildReviewsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildRatingSection() {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber),
        SizedBox(width: 4),
        Text(
          product.rating.toStringAsFixed(1),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 8),
        Text('(${product.reviews.length} reviews)'),
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: product.stock > 0 ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            product.stock > 0 ? 'In Stock' : 'Out of Stock',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        _buildDetailRow('Category', product.category),
        _buildDetailRow('Brand', product.brand),
        _buildDetailRow('Stock', '${product.stock} units'),
        if (product.tags.isNotEmpty)
          _buildDetailRow('Tags', product.tags.join(', ')),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    if (product.reviews.isEmpty) {
      return SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reviews',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        ...product.reviews.take(3).map((review) => _buildReviewCard(review)),
      ],
    );
  }

  Widget _buildReviewCard(Review review) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ...List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    size: 16,
                    color: index < review.rating ? Colors.amber : Colors.grey,
                  ),
                ),
                Spacer(),
                Text(
                  review.reviewerName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(review.comment),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              final isInCart = cartProvider.isInCart(product);
              return Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (isInCart) {
                      cartProvider.removeFromCart(product);
                      SnackbarHelper.success(
                        context: context,
                        title: 'Success',
                        message: 'Removed from cart',
                      );
                    } else {
                      cartProvider.addToCart(product);
                      SnackbarHelper.success(
                        context: context,
                        title: 'Success',
                        message: 'Added to cart',
                      );
                    }
                  },
                  icon: Icon(isInCart ? Icons.remove : Icons.add),
                  label: Text(isInCart ? 'Remove from Cart' : 'Add to Cart'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
