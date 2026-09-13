import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class ChaosEngine {
  /// Main pipeline entry point to sabotage an input image asset
  static Future<Uint8List> ruinImageFromAsset(String assetPath) async {
    // 1. Load raw bytes from Flutter bundle
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();

    // 2. Decode original image into pixel representation
    img.Image? original = img.decodeImage(bytes);
    if (original == null) throw Exception("Failed to decode image bytes.");

    // 3. Step 1: Programmatic Awkward Crop (Chop off heads/edges)
    img.Image cropped = _applyAwkwardCrop(original);

    // 4. Step 2: Radioactive Color & Contrast Distortion
    img.Image colorShifted = _applyRadioactiveFilter(cropped);

    // 5. Step 3: Extreme Downsampling & Pixel Noise (JPEG Artifacting)
    img.Image degraded = _applyDigitalDegradation(colorShifted);

    // 6. Encode back to Uint8List JPEG with high compression
    return Uint8List.fromList(img.encodeJpg(degraded, quality: 25));
  }

  /// Crops 30% off the top and right to ruin subject framing
  static img.Image _applyAwkwardCrop(img.Image input) {
    final int targetWidth = (input.width * 0.70).toInt();
    final int targetHeight = (input.height * 0.70).toInt();
    final int startX = (input.width * 0.25).toInt();
    final int startY = (input.height * 0.25).toInt();

    return img.copyCrop(
      input,
      x: startX,
      y: startY,
      width: targetWidth,
      height: targetHeight,
    );
  }

  /// Oversaturates colors and forces harsh green/magenta tints
  static img.Image _applyRadioactiveFilter(img.Image input) {
    // Increase contrast heavily
    img.Image processed = img.adjustColor(
      input,
      contrast: 2.2,
      saturation: 3.5,
      gamma: 0.6,
    );

    // Invert pixels dynamically in high-brightness areas
    for (final pixel in processed) {
      if (pixel.r > 200) pixel.r = 255 - pixel.r;
      if (pixel.g < 50) pixel.g = 220; // Force harsh neon tint
    }

    return processed;
  }

  /// Downsamples resolution then forces low-res upscaling for pixelation
  static img.Image _applyDigitalDegradation(img.Image input) {
    // Shrink to tiny dimensions (e.g. 120px wide)
    final img.Image tiny = img.copyResize(input, width: 120);

    // Apply Gaussian Blur on tiny image to blur details
    final img.Image blurred = img.gaussianBlur(tiny, radius: 2);

    // Scale back up to create blocky pixelation artifacts
    return img.copyResize(blurred, width: 600);
  }
}
