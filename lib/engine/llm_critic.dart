import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LLMCritic {
  /// Dynamic endpoint resolution:
  /// Uses 10.0.2.2 for Android Emulator loopback to host PC,
  /// and localhost for iOS simulator or Web.
  static String get _ollamaEndpoint {
    if (kIsWeb) return 'http://localhost:11434/api/generate';
    return Platform.isAndroid
        ? 'http://10.0.2.2:11434/api/generate'
        : 'http://localhost:11434/api/generate';
  }

  /// Entry point matching main.dart wrapper:
  /// Generates roast via local Ollama instance with optional preset contextual awareness.
  static Future<String> generateRoast({String presetName = 'default'}) async {
    return generatePhotoRoast();
  }

  /// Sends prompt to local Ollama instance and returns a 1-sentence photo roast
  static Future<String> generatePhotoRoast() async {
    const String systemPrompt =
        "You are an extremely snobbish, pretentious camera critic. "
        "Give a sharp, 1-sentence sarcastic roast of a photo that was just accidentally taken at a 20-degree angle with a thumb covering the bottom corner of the lens. "
        "Keep it under 20 words and funny.";

    try {
      final response = await http
          .post(
            Uri.parse(_ollamaEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'model': 'llama3.2:1b', // Targeted lightweight model
              'prompt': systemPrompt,
              'stream': false,
              'options': {
                'temperature': 0.8,
                'num_predict': 50, // Ensures fast response delivery
              },
            }),
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String text = data['response']?.toString().trim() ?? '';
        if (text.isNotEmpty) {
          // Strip enclosing quotes for clean UI rendering
          return text.replaceAll('"', '');
        }
      }
    } catch (e) {
      debugPrint(
        "Ollama Local Connection Note: Falling back to local offline critic engine ($e)",
      );
    }

    // Fallback offline mock generator for 100% demo reliability
    return _getRandomOfflineRoast();
  }

  static String _getRandomOfflineRoast() {
    final List<String> fallbackRoasts = [
      "A groundbreaking composition—if your goal was showcasing raw thumb texture at a 20° tilt.",
      "The avant-garde choice to obscure 30% of the frame with your finger really speaks to your vision.",
      "ISO noise, radioactive green tint, and a horizon line in freefall. A true anti-masterpiece.",
      "Focal point completely missed. Beautiful portrait of your lens cap and lower knuckle.",
    ];
    fallbackRoasts.shuffle();
    return fallbackRoasts.first;
  }
}
