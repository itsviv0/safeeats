import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    const Color primaryColor = Color.fromARGB(255, 225, 255, 219);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Row(
          children: [
            SvgPicture.asset('lib/assets/logo.svg', height: 30),
            const SizedBox(width: 10),
            const Text(
              'SafeEats',
              style: TextStyle(color: Color.fromARGB(255, 166, 20, 20)),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: const Center(
        child: Text(
          'Welcome to SafeEats Home!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
