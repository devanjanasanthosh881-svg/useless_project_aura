import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/tilt_leveler.dart';
import '../widgets/pro_viewfinder.dart';

class CameraScreen extends StatefulWidget {
  final VoidCallback onShutterPressed;

  const CameraScreen({super.key, required this.onShutterPressed});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  int _selectedPreset = 0;
  final List<String> _sampleAssets = [
    'assets/sample_face.jpg',
    'assets/sample_group.jpg',
    'assets/sample_landscape.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            // Task A1: Status Pill Header
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.redAccent,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "ANTI-SCENE OPTIMIZER",
                        style: GoogleFonts.orbitron(
                          color: Colors.redAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.cyanAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.cyanAccent.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      "CHAOS AI v3.0",
                      style: GoogleFonts.shareTechMono(
                        color: Colors.cyanAccent,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Task A1 & Task A2: Main Viewport (Gyro Leveler + Viewfinder)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      GyroTiltLeveler(
                        child: SizedBox.expand(
                          child: Image.asset(
                            _sampleAssets[_selectedPreset],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const ProViewfinderOverlay(),
                    ],
                  ),
                ),
              ),
            ),

            // Preset Selection Bar
            Container(
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _sampleAssets.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedPreset;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedPreset = index),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.redAccent.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isSelected ? Colors.redAccent : Colors.white24,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Preset #${index + 1}",
                          style: GoogleFonts.shareTechMono(
                            color: isSelected
                                ? Colors.redAccent
                                : Colors.white60,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Shutter Control Bar
            Padding(
              padding: const EdgeInsets.only(
                bottom: 20.0,
                left: 24.0,
                right: 24.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.hdr_off, color: Colors.cyanAccent),
                  GestureDetector(
                    onTap: widget.onShutterPressed,
                    child: Container(
                      width: 72,
                      height: 72,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.redAccent, width: 3),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  const Icon(Icons.raw_on, color: Colors.redAccent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
