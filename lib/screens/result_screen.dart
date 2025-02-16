import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safeeats/utils/product_response.dart';

class ResultPage extends StatelessWidget {
  final ProductResponse productInfo;

  const ResultPage({
    super.key,
    required this.productInfo,
  });

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
            crossAxisAlignment: CrossAxisAlignment.center,
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
      ),
    );
  }
}
