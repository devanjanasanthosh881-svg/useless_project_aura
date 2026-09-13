import 'package:flutter/foundation.dart';
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
      // 2. Read the ACTUAL camera photo bytes
      final Uint8List photoBytes = await photo.readAsBytes();

      // 3. Run Chaos Engine and LLM Critic concurrently to save execution time
      final results = await Future.wait([
        ChaosEngine.ruinImageBytes(photoBytes),
        LLMCritic.generatePhotoRoast()
      ]);

      final Uint8List ruinedBytes = results[0] as Uint8List;
      final String aiRoast = results[1] as String;

      if (!mounted) return;

      // 4. Hide loading overlay
      setState(() => _isProcessing = false);

      // 5. Show ruined photo result modal
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ResultModal(
          ruinedImageBytes: ruinedBytes,
          aiRoastText: aiRoast,
        ),
      );
    } catch (e) {
      debugPrint('Shutter execution error: $e');

      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CameraScreen(
          onShutterPressed: _triggerShutterSequence,
        ),
        if (_isProcessing) const ChaosLoaderOverlay(),
      ],
    );
  }
}