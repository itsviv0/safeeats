import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safeeats/utils/product_response.dart';
import 'package:safeeats/models/scan_result.dart';
import 'package:safeeats/services/database_helper.dart';
import 'package:safeeats/services/allergy_service.dart';

class FoodApiService {
  static const String baseUrl = 'https://world.openfoodfacts.org/api/v0';
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<ProductResponse> getProductInfo(String barcode) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/product/$barcode.json'),
      );

      if (response.statusCode == 200) {
        final productResponse =
            ProductResponse.fromJson(json.decode(response.body));

        // Store in database if product found
        if (productResponse.status == 1) {
          await _saveScanResult(productResponse, barcode, 'barcode');
        }

        return productResponse;
      } else {
        throw Exception('Failed to load product info');
      }
    } catch (e) {
      throw Exception('Error fetching product info: $e');
    }
  }

  // Save scan result to database
  Future<void> _saveScanResult(
      ProductResponse productResponse, String? barcode, String scanType) async {
    try {
      // Get ingredients list for allergy detection
      List<String> ingredients = [];
      if (productResponse.ingredients != null &&
          productResponse.ingredients!.isNotEmpty) {
        // Split ingredients by common separators
        ingredients = productResponse.ingredients!
            .split(RegExp(r'[,;]'))
            .map((ingredient) => ingredient.trim().toLowerCase())
            .where((ingredient) => ingredient.isNotEmpty)
            .toList();
      }

      // Detect allergies
      Map<String, String> allergiesDetected = {};
      if (ingredients.isNotEmpty) {
        try {
          allergiesDetected = await detectAllergies(ingredients);
        } catch (e) {
          print('Error detecting allergies: $e');
        }
      }

      final scanResult = ScanResult(
        productName: productResponse.name ?? 'Unknown Product',
        brand: productResponse.brands,
        imageUrl: productResponse.imageUrl,
        barcode: barcode,
        ingredients: ingredients,
        allergens: productResponse.allergens,
        allergiesDetected: allergiesDetected,
        scanType: scanType,
        scannedAt: DateTime.now(),
      );

      await _databaseHelper.insertScanResult(scanResult);
    } catch (e) {
      print('Error saving scan result: $e');
    }
  }

  // Save manual scan result (from ingredient scanner)
  Future<void> saveManualScanResult(List<String> ingredients) async {
    try {
      // Detect allergies
      Map<String, String> allergiesDetected = {};
      if (ingredients.isNotEmpty) {
        try {
          allergiesDetected = await detectAllergies(ingredients);
        } catch (e) {
          print('Error detecting allergies: $e');
        }
      }

      final scanResult = ScanResult(
        productName: 'Manual Scan - ${DateTime.now().toString().split(' ')[0]}',
        ingredients: ingredients,
        allergens: [], // Manual scans don't have pre-defined allergens
        allergiesDetected: allergiesDetected,
        scanType: 'manual',
        scannedAt: DateTime.now(),
      );

      await _databaseHelper.insertScanResult(scanResult);
    } catch (e) {
      print('Error saving manual scan result: $e');
    }
  }
}
