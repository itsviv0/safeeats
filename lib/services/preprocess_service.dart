import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<String>> fetchIngredients(String ocrText) async {
  // Encode the text for safe URL usage
  final encodedText = Uri.encodeComponent(ocrText);

  // Replace with your API endpoint (Flask localhost or deployed)
  final baseUrl =
      'https://preprocesstextsafeeats-git-main-itsviv0s-projects.vercel.app';

  final url = '$baseUrl/ingredients?text=$encodedText';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return List<String>.from(data['ingredients']);
  } else {
    throw Exception('Failed to load ingredients');
  }
}
