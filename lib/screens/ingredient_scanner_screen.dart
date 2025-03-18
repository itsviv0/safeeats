import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safeeats/screens/manual_result_screen.dart';

class IngredientsScannerPage extends StatefulWidget {
  const IngredientsScannerPage({super.key});

  @override
  State<IngredientsScannerPage> createState() => _IngredientsScannerPageState();
}

class _IngredientsScannerPageState extends State<IngredientsScannerPage> {
  final List<String> scannedIngredients = [];
  bool isScanning = false;
  final textRecognizer = GoogleMlKit.vision.textRecognizer();

  Future<void> _scanIngredients() async {
    final ImagePicker picker = ImagePicker();

    try {
      setState(() {
        isScanning = true;
      });

      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image == null) {
        setState(() {
          isScanning = false;
        });
        return;
      }

      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      // Process the recognized text
      String ingredients = recognizedText.text;

      // Split ingredients by common delimiters
      List<String> newIngredients = ingredients
          .split(RegExp(r'[,.]'))
          .map((ingredient) => ingredient.trim())
          .where((ingredient) => ingredient.isNotEmpty)
          .toList();

      setState(() {
        scannedIngredients.addAll(newIngredients);
        isScanning = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error scanning ingredients. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isScanning = false;
      });
    }
  }

  void _finishScanning() {
    if (scannedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please scan at least one ingredient'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ManualResultPage(ingredients: scannedIngredients),
      ),
    );
  }

  @override
  void dispose() {
    textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Ingredients'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Please scan the ingredients list from the package',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: scannedIngredients.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFC7FF6A),
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      scannedIngredients[index],
                      style: GoogleFonts.poppins(),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          scannedIngredients.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: isScanning ? null : _scanIngredients,
              icon: const Icon(Icons.camera_alt),
              label: Text(
                isScanning ? 'Scanning...' : 'Scan More',
                style: GoogleFonts.poppins(),
              ),
            ),
            ElevatedButton.icon(
              onPressed: isScanning ? null : _finishScanning,
              icon: const Icon(Icons.check),
              label: Text(
                'Finish',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
