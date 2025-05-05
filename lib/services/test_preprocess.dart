import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  final extractedText =
      "INGREDIENTS: Toned Milk (89), Sugar, Flavor (Nature Identical and Artificial (Kaju Katri) Flavoring Substances), Stabilizers (INS 415, INS 412, INS 407), Sequestrant (INS 339 (ii)), Emulsifier (INS 471), Cashew Powder (0.05%), lodized Salt, and Synthetic Food Color (INS 110). Allergen Advice: Contains Milk & Nut";
  final baseUrl = Uri.parse('https://preprocesstextsafeeats.vercel.app/');

  final encodedText = Uri.encodeComponent(extractedText);
  final url = '$baseUrl/preprocess?ocr_text=$encodedText';

  final response = await http.get(Uri.parse(url));
  // if (response.statusCode == 200) {
  final data = json.decode(response.body);
  final listIngredients = data['ingredients'];
  final List<String> result = [];

  for (final ingredient in listIngredients) {
    result.add(ingredient.toString());
  }

  print(result);

  // allergy

  const String baseUrlAllergy = 'https://allergydetectionsafeeats.vercel.app/';

  final urlAllergy = Uri.parse('$baseUrlAllergy/allergy');

  final responseAllergy = await http.post(
    urlAllergy,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'ingredients': result}),
  );
  // if (responseAllergy.statusCode == 200) {
  final resultAllergy = jsonDecode(responseAllergy.body);
  print('Allergy Results:');
  resultAllergy.forEach((ingredient, allergy) {
    print('$ingredient → $allergy');
  });
}
