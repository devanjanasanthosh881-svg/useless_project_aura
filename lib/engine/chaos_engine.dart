import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class ChaosEngine {
  // ==========================================================
  // CAMERA PHOTO PIPELINE
  // ==========================================================

  /// Ruins an actual camera photo.
  ///
  /// Camera XFile
  ///   ↓
  /// Uint8List
  ///   ↓
  /// Decode
  ///   ↓
  /// Chaos pipeline
  ///   ↓
  /// Ruined JPEG bytes
  static Future<Uint8List> ruinImageBytes(
    Uint8List bytes,
  ) async {
    final img.Image? original = img.decodeImage(bytes);

    if (original == null) {
      throw Exception(
        'Failed to decode camera image bytes.',
      );
    }

    return _ruinDecodedImage(original);
  }

  // ==========================================================
  // ASSET PIPELINE
  // ==========================================================

  /// Keeps support for your preset/sample images.
  ///
  /// Asset
  ///   ↓
  /// Decode
  ///   ↓
  /// Chaos pipeline
  ///   ↓
  /// Ruined JPEG
  static Future<Uint8List> ruinImageFromAsset(
    String assetPath,
  ) async {
    final ByteData data =
        await rootBundle.load(assetPath);

    final Uint8List bytes =
        data.buffer.asUint8List();

    final img.Image? original =
        img.decodeImage(bytes);

    if (original == null) {
      throw Exception(
        'Failed to decode image bytes.',
      );
    }

    return _ruinDecodedImage(original);
  }

  // ==========================================================
  // MAIN CHAOS PIPELINE
  // ==========================================================

  static Uint8List _ruinDecodedImage(
    img.Image original,
  ) {
    // --------------------------------------------------------
    // 1. AWKWARD CROP
    // --------------------------------------------------------

    img.Image processed =
        _applyAwkwardCrop(original);

    // --------------------------------------------------------
    // 2. RADIOACTIVE COLOR FILTER
    // --------------------------------------------------------

    processed =
        _applyRadioactiveFilter(processed);

    // --------------------------------------------------------
    // 3. STRATEGIC THUMB
    // --------------------------------------------------------

    processed =
        _applyStrategicThumb(processed);

    // --------------------------------------------------------
    // 4. 19° ANTI-LEVEL ROTATION
    // --------------------------------------------------------

    processed =
        _applyAntiLevelRotation(processed);

    // --------------------------------------------------------
    // 5. DIGITAL DEGRADATION
    // --------------------------------------------------------

    processed =
        _applyDigitalDegradation(processed);

    // --------------------------------------------------------
    // 6. JPEG COMPRESSION
    // --------------------------------------------------------

    return Uint8List.fromList(
      img.encodeJpg(
        processed,
        quality: 25,
      ),
    );
  }

  // ==========================================================
  // STEP 1 — AWKWARD CROP
  // ==========================================================

  /// Removes approximately the top 30% of the photograph.
  ///
  /// Deliberately destroys headroom and framing.
  static img.Image _applyAwkwardCrop(
    img.Image input,
  ) {
    final int startY =
        (input.height * 0.30).round();

    final int targetHeight =
        input.height - startY;

    return img.copyCrop(
      input,
      x: 0,
      y: startY,
      width: input.width,
      height: targetHeight,
    );
  }

  // ==========================================================
  // STEP 2 — RADIOACTIVE COLOR FILTER
  // ==========================================================

  /// Aggressively oversaturates the image and pushes
  /// the white balance toward a disgusting green/yellow tone.
  static img.Image _applyRadioactiveFilter(
    img.Image input,
  ) {
    img.Image processed =
        img.adjustColor(
      input,
      contrast: 2.2,
      saturation: 3.5,
      gamma: 0.6,
    );

    // Green-yellow color contamination.
    for (final pixel in processed) {
      final int red =
          pixel.r.toInt();

      final int green =
          pixel.g.toInt();

      final int blue =
          pixel.b.toInt();

      // Reduce blue.
      final int newBlue =
          max(0, blue - 25);

      // Push green.
      final int newGreen =
          min(255, green + 35);

      // Slight yellow/red contamination.
      final int newRed =
          min(255, red + 10);

      pixel
        ..r = newRed
        ..g = newGreen
        ..b = newBlue;
    }

    // Extra neon distortion.
    for (final pixel in processed) {
      if (pixel.r > 200) {
        pixel.r = 255 - pixel.r;
      }

      if (pixel.g < 50) {
        pixel.g = 220;
      }
    }

    return processed;
  }

  // ==========================================================
  // STEP 3 — STRATEGIC THUMB
  // ==========================================================

  /// Creates a semi-transparent peach/brown oval
  /// over one corner of the photograph.
  static img.Image _applyStrategicThumb(
    img.Image input,
  ) {
    final int centerX =
        (input.width * 0.88).round();

    final int centerY =
        (input.height * 0.88).round();

    final int radiusX =
        (input.width * 0.24).round();

    final int radiusY =
        (input.height * 0.20).round();

    for (
      int y = centerY - radiusY;
      y <= centerY + radiusY;
      y++
    ) {
      for (
        int x = centerX - radiusX;
        x <= centerX + radiusX;
        x++
      ) {
        // Ignore pixels outside image.
        if (x < 0 ||
            y < 0 ||
            x >= input.width ||
            y >= input.height) {
          continue;
        }

        // Ellipse equation.
        final double dx =
            (x - centerX) / radiusX;

        final double dy =
            (y - centerY) / radiusY;

        if ((dx * dx) + (dy * dy) <= 1) {
          final img.Pixel pixel =
              input.getPixel(x, y);

          // Peach/brown "finger".
          const int thumbR = 190;
          const int thumbG = 125;
          const int thumbB = 85;

          // Semi-transparent blend.
          const double alpha = 0.55;

          pixel.r = _blend(
            pixel.r.toInt(),
            thumbR,
            alpha,
          );

          pixel.g = _blend(
            pixel.g.toInt(),
            thumbG,
            alpha,
          );

          pixel.b = _blend(
            pixel.b.toInt(),
            thumbB,
            alpha,
          );
        }
      }
    }

    return input;
  }

  // ==========================================================
  // STEP 4 — ANTI-LEVEL ROTATION
  // ==========================================================

  /// Physically rotates the bitmap by 19°.
  static img.Image _applyAntiLevelRotation(
    img.Image input,
  ) {
    return img.copyRotate(
      input,
      angle: 19,
    );
  }

  // ==========================================================
  // STEP 5 — DIGITAL DEGRADATION
  // ==========================================================

  /// Creates an intentionally terrible low-resolution look.
  static img.Image _applyDigitalDegradation(
    img.Image input,
  ) {
    // Don't shrink very tiny images too aggressively.
    final int tinyWidth =
        min(120, input.width);

    final img.Image tiny =
        img.copyResize(
      input,
      width: tinyWidth,
    );

    // Blur away detail.
    final img.Image blurred =
        img.gaussianBlur(
      tiny,
      radius: 2,
    );

    // Stretch it back up.
    return img.copyResize(
      blurred,
      width: 600,
    );
  }

  // ==========================================================
  // HELPER — ALPHA BLENDING
  // ==========================================================

  static int _blend(
    int original,
    int overlay,
    double alpha,
  ) {
    return (
      original * (1 - alpha) +
      overlay * alpha
    ).round().clamp(0, 255);
  }
}