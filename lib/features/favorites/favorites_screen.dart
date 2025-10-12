import 'package:e_commerce/core/providers/favorites_provider.dart';
import 'package:e_commerce/core/theme/text_style_helper.dart';
import 'package:e_commerce/shared/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          if (favoritesProvider.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieBuilder.asset(
                    'assets/no_favorites.json',
                    repeat: false,
                    height: 240,
                    width: 240,
                  ),
                  Text(
                    'No favorites yet',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 8),
                  Text('Start adding products to your favorites'),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.63,
            ),
            itemCount: favoritesProvider.favorites.length,
            itemBuilder: (context, index) {
              final product = favoritesProvider.favorites[index];
              return ProductCard(product: product);
            },
          );
        },
      ),
    );
  }
}
