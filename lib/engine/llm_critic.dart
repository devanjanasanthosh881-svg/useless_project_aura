import 'dart:convert';
import 'package:http/http.dart' as http;

class LLMCritic {
  static const String _ollamaEndpoint = 'http://10.0.2.2:11434/api/generate';

  /// Generates a deadpan photo roast via local LLM or fallback engine
  static Future<String> generateRoast({required String presetName}) async {
    try {
      final response = await http
          .post(
            Uri.parse(_ollamaEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'model': 'llama3',
              'prompt':
                  'Write a 1-sentence snarky roast about a photo that is horribly crooked, over-saturated, and has half a head cut off.',
              'stream': false,
            }),
          )
          .timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] as String;
      }
    } catch (_) {
      // Fallback offline mock generator for reliable demo performance
    }

    return _getRandomFallbackRoast(presetName);
  }

  static String _getRandomFallbackRoast(String presetName) {
    final roasts = [
      "Computational AI Verdict: Outstanding framing, if your goal was to completely erase the subject's forehead.",
      "The radioactive tint really highlights your complete disregard for the Rule of Thirds.",
      "A masterpiece of anti-photography. Even your accelerometer tried to tilt away from this shot.",
      "ISO 12800 noise levels achieved. This photo has more static than a 1990s television set.",
    ];
    roasts.shuffle();
    return roasts.first;
  }
}
