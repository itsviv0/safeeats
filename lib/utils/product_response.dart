class ProductResponse {
  final String? name;
  final String? brands;
  final String? imageUrl;
  final String? ingredients;
  final List<String> allergens;
  final int status;
  final String? statusVerbose;

  ProductResponse({
    this.name,
    this.brands,
    this.imageUrl,
    this.ingredients,
    this.allergens = const [],
    this.status = 0,
    this.statusVerbose,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    // Process allergens string into a list
    String allergensStr = json['product']?['allergens_tags']?.join(', ') ?? '';
    // Clean up allergen strings (remove 'en:' prefix and replace dashes with spaces)
    List<String> cleanedAllergens = allergensStr
        .split(',')
        .map((allergen) =>
            allergen.trim().replaceAll('en:', '').replaceAll('-', ' ').trim())
        .where((allergen) => allergen.isNotEmpty)
        .toList();

    return ProductResponse(
      name: json['product']?['product_name'],
      brands: json['product']?['brands'],
      imageUrl: json['product']?['image_url'],
      ingredients: json['product']?['ingredients_text'],
      allergens: cleanedAllergens,
      status: json['status'] ?? 0,
      statusVerbose: json['status_verbose'],
    );
  }
}
