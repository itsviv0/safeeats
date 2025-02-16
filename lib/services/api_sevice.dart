import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safeeats/utils/product_response.dart';

class FoodApiService {
  static const String baseUrl = 'https://world.openfoodfacts.org/api/v0';

  Future<ProductResponse> getProductInfo(String barcode) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/product/$barcode.json'),
      );

      if (response.statusCode == 200) {
        return ProductResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load product info');
      }
    } catch (e) {
      throw Exception('Error fetching product info: $e');
    }
  }
}
