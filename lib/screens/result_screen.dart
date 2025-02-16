import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safeeats/utils/product_response.dart';

class ResultPage extends StatelessWidget {
  final ProductResponse productInfo;

  const ResultPage({
    super.key,
    required this.productInfo,
  });

  Widget _buildSection(String title, String? content) {
    if (content == null || content.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: GoogleFonts.poppins(
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAllergensList(List<String> allergens) {
    if (allergens.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Allergens',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allergens.map((allergen) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.red.shade300,
                ),
              ),
              child: Text(
                allergen.toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.red.shade900,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Information'),
      ),
      body: Container(
        color: const Color(0xFFC7FF6A),
        width: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Center the image and product name
              Center(
                child: Column(
                  children: [
                    if (productInfo.imageUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Image.network(
                          productInfo.imageUrl!,
                          height: 200,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const SizedBox(
                              height: 200,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              height: 200,
                              child: Center(
                                child: Icon(Icons.image_not_supported),
                              ),
                            );
                          },
                        ),
                      ),
                    Text(
                      productInfo.name ?? 'Unknown Product',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (productInfo.brands != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Brand: ${productInfo.brands}',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Allergens section with red warning chips
              _buildAllergensList(productInfo.allergens),

              // Ingredients section
              _buildSection('Ingredients', productInfo.ingredients),

              // Display "No data available" if both ingredients and allergens are missing
              if (productInfo.ingredients == null &&
                  productInfo.allergens.isEmpty)
                Center(
                  child: Text(
                    'No ingredient or allergen information available',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
