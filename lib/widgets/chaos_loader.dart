import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChaosLoaderOverlay extends StatefulWidget {
  final VoidCallback? onFinished;

  const ChaosLoaderOverlay({
    super.key,
    this.onFinished,
  });

  @override
  State<ChaosLoaderOverlay> createState() =>
      _ChaosLoaderOverlayState();
}

class _ChaosLoaderOverlayState
    extends State<ChaosLoaderOverlay> {

  int _messageIndex = 0;
  Timer? _timer;

  final List<String> _statusMessages = [
    "Detecting symmetry to destroy...",
    "Calculating worst white balance...",
    "Applying strategic lens thumb...",
    "Sabotaging focal plane...",
    "Optimizing ISO noise artifacts...",
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(milliseconds: 900),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_messageIndex <
            _statusMessages.length - 1) {

          setState(() {
            _messageIndex++;
          });

        } else {
          timer.cancel();

          // Tell the parent that the fake AI process
          // has finished.
          widget.onFinished?.call();
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.94),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // ------------------------------------------
              // SPINNER
              // ------------------------------------------

              const SizedBox(
                width: 52,
                height: 52,
                child: CircularProgressIndicator(
                  color: Colors.redAccent,
                  strokeWidth: 3,
                ),
              ),

              const SizedBox(height: 28),

              // ------------------------------------------
              // STATUS TEXT
              // ------------------------------------------

              AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 250,
                ),

                transitionBuilder:
                    (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },

                child: Padding(
                  key: ValueKey<int>(
                    _messageIndex,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),

                  child: Text(
                    _statusMessages[_messageIndex],
                    textAlign: TextAlign.center,

                    style: GoogleFonts.shareTechMono(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ------------------------------------------
              // FAKE SYSTEM LABEL
              // ------------------------------------------

              Text(
                "CHAOS-CAM // COMPUTATIONAL PHOTOGRAPHY",
                style: GoogleFonts.shareTechMono(
                  color: Colors.white38,
                  fontSize: 9,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "DO NOT INTERRUPT",
                style: GoogleFonts.shareTechMono(
                  color: Colors.redAccent.withOpacity(0.5),
                  fontSize: 8,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}