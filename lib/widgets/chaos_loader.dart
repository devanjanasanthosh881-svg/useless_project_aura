import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChaosLoaderOverlay extends StatelessWidget {
  const ChaosLoaderOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.redAccent),
            const SizedBox(height: 20),
            Text(
              "APPLYING ANTI-COMPUTATIONAL AI...",
              style: GoogleFonts.shareTechMono(
                color: Colors.redAccent,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
