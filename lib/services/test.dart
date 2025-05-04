import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final url = Uri.parse('https://allergydetectionsafeeats.vercel.app/');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'ingredients': ['milk', 'peanut', 'banana', 'egg', 'til oil']
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
