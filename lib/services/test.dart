import 'package:http/http.dart' as http;
import 'package:safeeats/services/allergy_service.dart';
import 'dart:convert';

import 'package:safeeats/services/preprocess_service.dart';

void main() async {
  final ocrText =
      "INGREDIENTS: Toned Milk (89), Sugar, Stabilizers (INS 415, INS 412, INS 407), Sequestrant (INS 339 (ii)), Emulsifier (INS 471), Cashew Powder (0.05%), lodized Salt, and Synthetic Food Color (INS 110). Allergen Advice: Contains Milk & Nut";

  final preprocessedIngredients = [
    'toned milk',
    'sugar',
    'emulsifier ins',
    'cashew powder',
    'lodized salt',
    'and synthetic food color ins allergen advice contains milk nut'
  ];
  final allegies = await detectAllergies(preprocessedIngredients);
  // print(preprocessedIngredients);
  print(allegies);
}
