import 'dart:typed_data';
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

  void _triggerShutterSequence() async {
    // 1. Show Fake AI Loading Overlay
    setState(() => _isProcessing = true);

    try {
      // 2. Run real programmatic image ruination pipeline on preset sample
      const sampleAsset = 'assets/sample_face.jpg';
      final Uint8List ruinedBytes = await ChaosEngine.ruinImageFromAsset(
        sampleAsset,
      );

      // 3. Generate Local LLM Roast (or fallback engine)
      final String roastText = await LLMCritic.generateRoast(
        presetName: "Preset #1",
      );

      if (!mounted) return;
      setState(() => _isProcessing = false);

      // 4. Display Final Ruined Photo Modal with real bytes & roast
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            ResultModal(imageBytes: ruinedBytes, roastMessage: roastText),
      );
    } catch (e) {
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
