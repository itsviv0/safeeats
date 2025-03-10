import 'dart:io';
import 'dart:convert';

class IngredientProcessor {
  static Future<List<String>> processIngredients(
      List<String> rawIngredients) async {
    try {
      final tempFile = await File('/tmp/ingredients.json').create();
      await tempFile.writeAsString(jsonEncode(rawIngredients));

      // Run Python script
      final result = await Process.run(
          'python3', ['lib/services/preprocess_ingredients.py', tempFile.path]);

      if (result.exitCode != 0) {
        throw Exception('Python script error: ${result.stderr}');
      }

      // Parse results
      final processedIngredients =
          List<String>.from(jsonDecode(result.stdout.toString()));

      // Cleanup
      await tempFile.delete();

      return processedIngredients;
    } catch (e) {
      print('Error processing ingredients: $e');
      return rawIngredients; // Return original list if processing fails
    }
  }
}
