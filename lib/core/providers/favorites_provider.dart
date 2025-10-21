import 'package:e_commerce/shared/models/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:e_commerce/core/providers/product_provider.dart';
import 'package:e_commerce/core/services/firestore_service.dart';

class FavoritesProvider with ChangeNotifier {
  final Set<int> _favoriteIds = {};
  final ProductProvider _productProvider;
  final FirestoreService _firestoreService;

  FavoritesProvider(this._productProvider, this._firestoreService);

  Future<void> setFromIds(Set<int> ids) async {
    _favoriteIds.clear();
    _favoriteIds.addAll(ids);
    notifyListeners();
  }

  List<Product> get favorites {
    final products = _productProvider.products;
    return _favoriteIds
        .map((id) => products.where((p) => p.id == id))
        .where((iter) => iter.isNotEmpty)
        .map((iter) => iter.first)
        .toList();
  }

  Set<int> get favoriteIds => _favoriteIds;

  bool isFavorite(Product product) {
    return _favoriteIds.contains(product.id);
  }

  Future<void> toggleFavoriteForUser(String uid, Product product) async {
    final id = product.id;
    final currentlyFavorite = _favoriteIds.contains(id);

    if (currentlyFavorite) {
      _favoriteIds.remove(id);
      notifyListeners();
      try {
        await _firestoreService.removeFavorite(uid, id);
      } catch (e) {
        _favoriteIds.add(id);
        notifyListeners();
        throw Exception('Failed to remove favorite. Please try again.');
      }
    } else {
      _favoriteIds.add(id);
      notifyListeners();
      try {
        await _firestoreService.addFavorite(uid, id);
      } catch (e) {
        _favoriteIds.remove(id);
        notifyListeners();
        throw Exception('Failed to add favorite. Please try again.');
      }
    }
  }
}
