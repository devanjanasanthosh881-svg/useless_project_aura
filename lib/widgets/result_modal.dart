import 'dart:typed_data';

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
 feature/sound-effects
      backgroundColor: const Color(0xFF121212),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.redAccent, width: 1.5),

      backgroundColor: const Color(0xFF141414),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
 main
      ),

      child: Padding(
 feature/sound-effects
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

        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

            

              Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                    size: 22,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      "SUCCESSFULLY SABOTAGED",
                      style: GoogleFonts.orbitron(
                        color: Colors.redAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white54,
                      size: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              

              Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  maxHeight: 300,
                ),

                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white12,
                  ),
                ),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),

                  child: Image.memory(
                    imageBytes,

                    // IMPORTANT:
                    // Keep the entire ruined image visible.
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 14),

            

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10),

                  border: Border.all(
                    color: Colors.white12,
                  ),
                ),

                child: Column(
                  children: [

                    Text(
                      "LOCAL AI PHOTO CRITIC",
                      style: GoogleFonts.orbitron(
                        color: Colors.redAccent,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.3,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      "\"$roastMessage\"",
                      style: GoogleFonts.shareTechMono(
                        color: Colors.yellow,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

             

              _actionButton(
                context: context,
                text: "DELETE IMMEDIATELY",
                icon: Icons.delete_outline,
                color: Colors.redAccent,
              ),

              const SizedBox(height: 8),

           

              _actionButton(
                context: context,
                text: "APOLOGIZE TO SUBJECT",
                icon: Icons.sentiment_dissatisfied_outlined,
                color: Colors.white,
              ),

              const SizedBox(height: 8),

             

              _actionButton(
                context: context,
                text: "UPLOAD TO TRASH",
                icon: Icons.upload_outlined,
                color: Colors.white,
              ),

              const SizedBox(height: 10),

              

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                child: Text(
                  "RUIN ANOTHER PHOTO",
                  style: GoogleFonts.orbitron(
                    color: Colors.redAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
main
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _actionButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 44,

      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.pop(context);
        },

        icon: Icon(
          icon,
          color: color,
          size: 18,
        ),

        label: Text(
          text,
          style: GoogleFonts.orbitron(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),

        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: color.withOpacity(0.25),
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
feature/sound-effects

  // Alias for column sizing flexibility
  MainAxisSize get minAxisSize => MainAxisSize.min;
}
}
 main
