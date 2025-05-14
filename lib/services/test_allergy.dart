import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final url = Uri.parse('https://allergydetectionsafeeats.vercel.app/');
  final ingredients = [
    'toned milk',
    'sugar',
    'emulsifier ins',
    'cashew powder',
    'lodized salt',
    'and synthetic food color ins allergen advice contains milk nut'
  ];

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'ingredients': ingredients,
    }),
  );

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    print('Allergy Results:');
    result.forEach((ingredient, allergy) {
      print('$ingredient → $allergy');
    });
  } else {
    print('Error: ${response.statusCode}');
    print(response.body);
  }
}
