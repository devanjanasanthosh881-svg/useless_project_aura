import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  void _triggerShutterSequence([
    String selectedAssetPath = 'assets/sample_face.jpg',
  ]) async {
    setState(() => _isProcessing = true);

    try {
      final results = await Future.wait([
        ChaosEngine.ruinImageFromAsset(selectedAssetPath),
        LLMCritic.generatePhotoRoast(),
      ]);

      final Uint8List ruinedBytes = results[0] as Uint8List;
      final String aiRoast = results[1] as String;

      if (!mounted) return;
      setState(() => _isProcessing = false);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            ResultModal(ruinedImageBytes: ruinedBytes, aiRoastText: aiRoast),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
      debugPrint("Shutter execution error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CameraScreen(
          onShutterPressed: () =>
              _triggerShutterSequence('assets/sample_face.jpg'),
        ),
        if (_isProcessing) const ChaosLoaderOverlay(),
      ],
    );
  }
}
