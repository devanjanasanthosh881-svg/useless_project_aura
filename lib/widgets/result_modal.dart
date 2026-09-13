import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultModal extends StatelessWidget {
  final Uint8List imageBytes;
  final String roastMessage;

  const ResultModal({
    super.key,
    required this.imageBytes,
    required this.roastMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF141414),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // =================================================
              // HEADER
              // =================================================

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

              // =================================================
              // RUINED PHOTO
              // =================================================

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

              // =================================================
              // AI ROAST
              // =================================================

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

              // =================================================
              // ACTION 1
              // =================================================

              _actionButton(
                context: context,
                text: "DELETE IMMEDIATELY",
                icon: Icons.delete_outline,
                color: Colors.redAccent,
              ),

              const SizedBox(height: 8),

              // =================================================
              // ACTION 2
              // =================================================

              _actionButton(
                context: context,
                text: "APOLOGIZE TO SUBJECT",
                icon: Icons.sentiment_dissatisfied_outlined,
                color: Colors.white,
              ),

              const SizedBox(height: 8),

              // =================================================
              // ACTION 3
              // =================================================

              _actionButton(
                context: context,
                text: "UPLOAD TO TRASH",
                icon: Icons.upload_outlined,
                color: Colors.white,
              ),

              const SizedBox(height: 10),

              // =================================================
              // RUIN ANOTHER
              // =================================================

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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // REUSABLE ACTION BUTTON
  // ===========================================================

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
}