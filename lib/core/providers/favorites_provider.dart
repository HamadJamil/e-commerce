import 'package:e_commerce/shared/models/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Product> _favorites = [];
  final Set<int> _favoriteIds = {};

  List<Product> get favorites => _favorites;
  Set<int> get favoriteIds => _favoriteIds;

  FavoritesProvider() {
    _loadFavorites();
  }

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
      _favorites.removeWhere((p) => p.id == product.id);
    } else {
      _favoriteIds.add(product.id);
      _favorites.add(product);
    }
    await _saveFavorites();
    notifyListeners();
  }
}
