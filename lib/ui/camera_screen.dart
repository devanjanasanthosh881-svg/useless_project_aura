import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/pro_viewfinder.dart';
import '../widgets/tilt_leveler.dart';

class CameraScreen extends StatefulWidget {
  final Future<void> Function(XFile photo) onShutterPressed;

  const CameraScreen({
    super.key,
    required this.onShutterPressed,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  bool _cameraReady = false;
  bool _isTakingPicture = false;

  int _selectedSampleIndex = 0;

  final List<String> _sampleAssets = [
    'assets/sample_face.jpg',
    'assets/sample_group.jpg',
    'assets/sample_landscape.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // ==========================================================
  // CAMERA INITIALIZATION
  // ==========================================================

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        debugPrint('No cameras available.');
        return;
      }

      // Prefer the back camera.
      CameraDescription selectedCamera = cameras.first;

      for (final camera in cameras) {
        if (camera.lensDirection == CameraLensDirection.back) {
          selectedCamera = camera;
          break;
        }
      }

      final controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _cameraController = controller;
        _cameraReady = true;
      });
    } catch (e) {
      debugPrint('Camera initialization failed: $e');

      if (!mounted) return;

      setState(() {
        _cameraReady = false;
      });
    }
  }

  Future<void> _takePicture() async {
    if (!_cameraReady ||
        _cameraController == null ||
        _isTakingPicture) {
      return;
    }

    try {
      setState(() {
        _isTakingPicture = true;
      });

      final XFile photo = await _cameraController!.takePicture();

      if (!mounted) return;

      // Send the actual captured photo to main.dart.
      await widget.onShutterPressed(photo);
    } catch (e) {
      debugPrint('Failed to take picture: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isTakingPicture = false;
        });
      }
    }
  }

  // ==========================================================
  // CLEAN UP CAMERA
  // ==========================================================

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  // ==========================================================
  // CAMERA PREVIEW
  // ==========================================================

  Widget _buildCameraPreview() {
    if (!_cameraReady ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.redAccent,
          ),
        ),
      );
    }

    return CameraPreview(_cameraController!);
  }

  // ==========================================================
  // BUILD UI
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            // --------------------------------------------------
            // TOP BAR
            // --------------------------------------------------
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

            // --------------------------------------------------
            // CAMERA VIEWPORT
            // --------------------------------------------------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // Real camera preview + gyroscope effect
                      GyroTiltLeveler(
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: _buildCameraPreview(),
                        ),
                      ),

                      // Pro Viewfinder overlay
                      const ProViewfinderOverlay(),

                      // Camera loading indicator overlay
                      if (!_cameraReady)
                        Container(
                          color: Colors.black54,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "INITIALIZING CHAOS CAMERA...",
                                  style: GoogleFonts.shareTechMono(
                                    color: Colors.redAccent,
                                    fontSize: 11,
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
            ),

            // --------------------------------------------------
            // PRESET SELECTOR (DEMO / MOCK SELECTOR)
            // --------------------------------------------------
            Container(
              height: 45,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _sampleAssets.length,
                itemBuilder: (context, index) {
                  final bool isSelected = index == _selectedSampleIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSampleIndex = index;
                      });
                    },
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
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Colors.redAccent : Colors.white24,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Preset #${index + 1}",
                          style: GoogleFonts.shareTechMono(
                            color: isSelected ? Colors.redAccent : Colors.white60,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // --------------------------------------------------
            // BOTTOM SHUTTER CONTROLS
            // --------------------------------------------------
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

                  // SHUTTER BUTTON
                  GestureDetector(
                    onTap: (_cameraReady && !_isTakingPicture) ? _takePicture : null,
                    child: Opacity(
                      opacity: (_cameraReady && !_isTakingPicture) ? 1.0 : 0.4,
                      child: Container(
                        width: 76,
                        height: 76,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.redAccent,
                            width: 3,
                          ),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isTakingPicture
                                ? Icons.hourglass_top
                                : Icons.camera_alt,
                            color: Colors.white,
                            size: 30,
                          ),
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