import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safeeats/screens/scanner_screen.dart';
import 'package:safeeats/screens/scan_history_screen.dart';
import 'package:safeeats/widgets/parallax_box.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromARGB(255, 225, 255, 219);

    return Scaffold(
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) => true,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ParallaxBox(
                    height: 500,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          SvgPicture.asset(
                            'lib/assets/logo.svg',
                            height: 120,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Scan packaged food to identify hidden allergens.',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const BarcodeScannerPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Start Scanning',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 70,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.history, size: 32),
              iconSize: 48,
              tooltip: 'View scanned foods ',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScanHistoryScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
