import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  final picker = ImagePicker();
  bool _isPickerActive = false;
  bool _isProcessing = false;
  String _extractedText = '';

  Future<void> processImage(File image) async {
    setState(() => _isProcessing = true);
    try {
      final inputImage = InputImage.fromFile(image);
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      setState(() {
        _extractedText = recognizedText.text;
      });

      textRecognizer.close();
    } catch (e) {
      setState(() => _extractedText = 'Error extracting text: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> getImageFromCamera() async {
    if (_isPickerActive) return;

    try {
      setState(() {
        _isPickerActive = true;
        _extractedText = '';
      });
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        if (imageFile != null) {
          final imagefile = File(imageFile.path);
          setState(() => _image = imagefile);
          await processImage(imagefile);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isPickerActive = false);
    }
  }

  Future<void> getImageFromGallery() async {
    if (_isPickerActive) return;

    try {
      setState(() {
        _isPickerActive = true;
        _extractedText = '';
      });
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        setState(() => _image = imageFile);
        await processImage(imageFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isPickerActive = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SafeEats')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _isPickerActive ? null : getImageFromGallery,
                icon: const Icon(Icons.photo_library),
                label: const Text('Pick Ingredients from Gallery'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isPickerActive ? null : getImageFromCamera,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take Photo with Camera'),
              ),
              const SizedBox(height: 20),
              if (_image != null) ...[
                Image.file(_image!, height: 300),
                const SizedBox(height: 20),
              ],
              if (_isProcessing)
                const CircularProgressIndicator()
              else if (_extractedText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Extracted Text:\n$_extractedText',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
