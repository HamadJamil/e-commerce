import 'package:e_commerce/shared/models/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce/core/providers/product_provider.dart';

class FavoritesProvider with ChangeNotifier {
  final Set<int> _favoriteIds = {};
  final ProductProvider _productProvider;

  FavoritesProvider(this._productProvider) {
    _loadFavorites();
  }

  /// Returns the list of favorite Product objects that are currently loaded
  /// by the ProductProvider. If a favorite id is not loaded yet it will not
  /// appear until products are fetched.
  List<Product> get favorites {
    final products = _productProvider.products;
    return _favoriteIds
        .map((id) => products.where((p) => p.id == id))
        .where((iter) => iter.isNotEmpty)
        .map((iter) => iter.first)
        .toList();
  }

  Set<int> get favoriteIds => _favoriteIds;

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIdsList = prefs.getStringList('favorites') ?? [];
    _favoriteIds.addAll(favoriteIdsList.map(int.parse));
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favorites',
      _favoriteIds.map((id) => id.toString()).toList(),
    );
  }

  bool isFavorite(Product product) {
    return _favoriteIds.contains(product.id);
  }

  Future<void> toggleFavorite(Product product) async {
    if (_favoriteIds.contains(product.id)) {
      _favoriteIds.remove(product.id);
    } else {
      _favoriteIds.add(product.id);
    }
    await _saveFavorites();
    notifyListeners();
  }
}
