import 'package:http/http.dart' as http;
import 'dart:convert';

// Your original function
Future<List<String>> fetchIngredients(String ocrText) async {
  final encodedText = Uri.encodeComponent(ocrText);
  final baseUrl = 'https://allergydetectionsafeeats.vercel.app/';

  final url = '$baseUrl/preprocess?ocr_text=$encodedText';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return List<String>.from(data['ingredients']);
  } else {
    throw Exception('Failed to load ingredients: ${response.statusCode}');
  }
}
