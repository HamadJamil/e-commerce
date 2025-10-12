import 'package:e_commerce/shared/models/category_model.dart';
import '../../shared/models/product_model.dart';

abstract class ApiService {
  Future<ProductsResponse> getProducts({
    int skip = 0,
    int limit = 30,
  
  });
  Future<Product> getProduct(int id);
  Future<ProductsResponse> searchProducts(String query);
  Future<List<Category>> getCategories();
  Future<ProductsResponse> getProductsByCategory(String category);
}
