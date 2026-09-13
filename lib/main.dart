import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'engine/chaos_engine.dart';
import 'engine/llm_critic.dart';
import 'ui/camera_screen.dart';
import 'widgets/chaos_loader.dart';
import 'widgets/result_modal.dart';

void main() {
  runApp(const ChaosCamApp());
}

class ChaosCamApp extends StatelessWidget {
  const ChaosCamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chaos-Cam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      ),
      home: const MainCameraWrapper(),
    );
  }
}

class MainCameraWrapper extends StatefulWidget {
  const MainCameraWrapper({super.key});

  @override
  State<MainCameraWrapper> createState() => _MainCameraWrapperState();
}

class _MainCameraWrapperState extends State<MainCameraWrapper> {
  bool _isProcessing = false;

  Future<void> _triggerShutterSequence(XFile photo) async {
  // 1. Show fake AI processing overlay
  setState(() => _isProcessing = true);

  try {
    // 2. Read the ACTUAL camera photo
    final Uint8List photoBytes =
        await photo.readAsBytes();

    // 3. Ruin the actual camera photo
    final Uint8List ruinedBytes =
        await ChaosEngine.ruinImageBytes(photoBytes);

    // 4. Generate LLM roast
    final String roastText =
        await LLMCritic.generateRoast(
      presetName: "Camera Photo",
    );

    if (!mounted) return;

    // 5. Hide loading overlay
    setState(() => _isProcessing = false);

    // 6. Show ruined photo
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ResultModal(
        imageBytes: ruinedBytes,
        roastMessage: roastText,
      ),
    );
  } catch (e) {
    debugPrint('Chaos-Cam error: $e');

    if (!mounted) return;

    setState(() => _isProcessing = false);
  }
}
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Viewfinder & Gyroscope Leveler Screen
        CameraScreen(onShutterPressed: _triggerShutterSequence),

        // Processing Overlay
        if (_isProcessing) const ChaosLoaderOverlay(),
      ],
    );
  }
}
