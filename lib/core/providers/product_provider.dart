import 'package:e_commerce/core/services/api_service.dart';
import 'package:e_commerce/shared/models/category_model.dart';
import 'package:e_commerce/shared/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService;

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<Category> _categories = [];
  final Map<String, ProductsResponse> _categoryCache = {};
  bool _isLoading = false;
  String _error = '';
  int _currentPage = 0;
  final int _pageSize = 12;
  bool _hasMore = true;

  List<Product> get products => _filteredProducts;
  bool get isLoading => _isLoading;

  String get error => _error;
  bool get hasMore => _hasMore;
  List<Category> get categories => _categories;

  ProductProvider(this._apiService);

  Future<void> loadProducts({
    bool refresh = false,
    String? category = 'All',
  }) async {
    if (_isLoading && !refresh) return;
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      if (refresh) {
        _currentPage = 0;
        _hasMore = true;
        _products.clear();
        _filteredProducts.clear();
      }

      ProductsResponse response;

      final bool isFiltered = category != null && category != 'All';

      if (isFiltered) {
        if (!refresh && _categoryCache.containsKey(category)) {
          response = _categoryCache[category]!;
        } else {
          response = await _apiService.getProductsByCategory(category);
          _categoryCache[category] = response;
        }
        _hasMore = false;
        _currentPage = 0;
      } else {
        response = await _apiService.getProducts(
          skip: _currentPage * _pageSize,
          limit: _pageSize,
        );
      }

      if (refresh || isFiltered) {
        _products = response.products;
      } else {
        _products.addAll(response.products);
        _currentPage++;
      }

      _filteredProducts = _products;

      if (!isFiltered) {
        _hasMore = _products.length < response.total;
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      _filteredProducts = _products;
    } else {
      try {
        _isLoading = true;
        _filteredProducts = _products
            .where((product) => product.title.toLowerCase().contains(query))
            .toList();
        _error = '';
      } catch (e) {
        _error = e.toString();
      } finally {
        _isLoading = false;
      }
    }
    notifyListeners();
  }

  Future<void> loadCategories() async {
    try {
      _error = '';
      _categories = await _apiService.getCategories();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
