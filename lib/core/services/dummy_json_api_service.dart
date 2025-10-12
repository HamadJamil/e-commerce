import 'dart:convert';
import 'package:e_commerce/shared/models/category_model.dart';
import 'package:http/http.dart' as http;
import '../../core/services/api_service.dart';
import '../../shared/models/product_model.dart';

class DummyJsonApiService implements ApiService {
  final String baseUrl = 'https://dummyjson.com';
  final http.Client client;

  DummyJsonApiService({required this.client});

  @override
  Future<ProductsResponse> getProducts({
    int skip = 0,
    int limit = 30,
  }) async {
    try {
      final params = <String, String>{
        'skip': skip.toString(),
        'limit': limit.toString(),
      };

      final uri = Uri.parse(
        '$baseUrl/products',
      ).replace(queryParameters: params);
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        return ProductsResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<Product> getProduct(int id) async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/products/$id'));

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<ProductsResponse> searchProducts(String query) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/products/search?q=$query'),
      );

      if (response.statusCode == 200) {
        return ProductsResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to search products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/products/categories'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> categoriesList = json.decode(response.body);
        return categoriesList.map((categoryJson) {
          return Category.fromJson(categoryJson);
        }).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<ProductsResponse> getProductsByCategory(String category) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/products/category/$category'),
      );

      if (response.statusCode == 200) {
        return ProductsResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to load category products: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
