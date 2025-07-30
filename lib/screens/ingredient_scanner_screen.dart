import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safeeats/screens/manual_result_screen.dart';
import 'package:safeeats/services/preprocess_service.dart';
import 'package:safeeats/services/api_sevice.dart';

class IngredientsScannerPage extends StatefulWidget {
  const IngredientsScannerPage({super.key});

  @override
  State<IngredientsScannerPage> createState() => _IngredientsScannerPageState();
}

class _IngredientsScannerPageState extends State<IngredientsScannerPage> {
  final List<String> scannedIngredients = [];
  bool isScanning = false;
  final textRecognizer = GoogleMlKit.vision.textRecognizer();
  final FoodApiService _apiService = FoodApiService();

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
      String extractedText = recognizedText.text.trim();

      if (extractedText.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'No text detected. Please try again with a clearer image.'),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() {
          isScanning = false;
        });
        return;
      }

      final extractedIngredients = await fetchIngredients(extractedText);

      if (extractedIngredients.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No ingredients found. Please try again.'),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() {
          isScanning = false;
        });
        return;
      }

      setState(() {
        for (final ingredient in extractedIngredients) {
          if (!scannedIngredients.contains(ingredient)) {
            scannedIngredients.add(ingredient);
          }
        }
        isScanning = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${extractedIngredients.length} ingredient(s)'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      print('Error in _scanIngredients: $e'); // Debug output
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error scanning ingredients: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isScanning = false;
      });
    }
  }

  Future<void> _uploadImage() async {
    final ImagePicker picker = ImagePicker();

    try {
      setState(() {
        isScanning = true;
      });

      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
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
      String extractedText = recognizedText.text.trim();

      if (extractedText.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'No text detected. Please try again with a clearer image.'),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() {
          isScanning = false;
        });
        return;
      }

      final extractedIngredients = await fetchIngredients(extractedText);

      if (extractedIngredients.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No ingredients found. Please try again.'),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() {
          isScanning = false;
        });
        return;
      }

      setState(() {
        for (final ingredient in extractedIngredients) {
          if (!scannedIngredients.contains(ingredient)) {
            scannedIngredients.add(ingredient);
          }
        }
        isScanning = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${extractedIngredients.length} ingredient(s)'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      print('Error in _uploadImage: $e'); // Debug output
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isScanning = false;
      });
    }
  }

  void _finishScanning() async {
    if (scannedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please scan at least one ingredient'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show loading indicator
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Save to database before navigating (but don't block if it fails)
    try {
      await _apiService.saveManualScanResult(scannedIngredients);
      print('Manual scan result saved successfully');
    } catch (e) {
      print('Error saving manual scan result: $e');
      // Don't show error to user, just log it
    }

    // Close loading dialog
    if (mounted) {
      Navigator.of(context).pop();
    }

    // Navigate to results
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ManualResultPage(ingredients: scannedIngredients),
        ),
      );
    }
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton.icon(
                      onPressed: isScanning ? null : _scanIngredients,
                      icon: const Icon(Icons.camera_alt, size: 20),
                      label: Text(
                        isScanning ? 'Scanning...' : 'Scan',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton.icon(
                      onPressed: isScanning ? null : _uploadImage,
                      icon: const Icon(Icons.upload_file, size: 20),
                      label: Text(
                        'Upload',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton.icon(
                  onPressed: isScanning ? null : _finishScanning,
                  icon: const Icon(Icons.check, size: 20),
                  label: Text(
                    'Done',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
