import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, String>> detectAllergies(List<String> ingredients) async {
  const String baseUrl = 'https://allergydetectionsafeeats.vercel.app/';

  final url = Uri.parse('$baseUrl/allergy');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ingredients': ingredients}),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      // Convert dynamic values to string just in case
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    } else {
      throw Exception(
        'Allergy detection failed (status: ${response.statusCode})',
      );
    }
  } catch (e) {
    throw Exception('Error during allergy detection: $e');
  }
}
