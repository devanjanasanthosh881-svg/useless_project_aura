import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultModal extends StatelessWidget {
  final Uint8List ruinedImageBytes;
  final String aiRoastText;

  /// Constructor supporting both legacy and new naming conventions
  ResultModal({
    super.key,
    required Uint8List ruinedImageBytes,
    String? aiRoastText,
    String? roastMessage,
  }) : ruinedImageBytes = ruinedImageBytes,
       aiRoastText =
           aiRoastText ?? roastMessage ?? "AI model generated no response.";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF121212),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: minAxisSize,
          children: [
            // Modal Header
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.redAccent,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "PHOTO RUINED SUCCESSFULLY",
                  style: GoogleFonts.orbitron(
                    color: Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Ruined Bitmap Image Viewport
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(
                ruinedImageBytes,
                height: 240,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 14),

            // Glowing Cyan Local LLM Critique Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.cyanAccent.withValues(alpha: 0.4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.memory,
                        color: Colors.cyanAccent,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "LOCAL LLM CRITIQUE (OLLAMA LLAMA3.2)",
                        style: GoogleFonts.orbitron(
                          color: Colors.cyanAccent,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "\"$aiRoastText\"",
                    style: GoogleFonts.shareTechMono(
                      color: Colors.yellowAccent,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "DISCARD & RUIN ANOTHER",
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Alias for column sizing flexibility
  MainAxisSize get minAxisSize => MainAxisSize.min;
}
