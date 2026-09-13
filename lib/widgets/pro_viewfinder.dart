import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProViewfinderOverlay extends StatefulWidget {
  const ProViewfinderOverlay({super.key});

  @override
  State<ProViewfinderOverlay> createState() => _ProViewfinderOverlayState();
}

class _ProViewfinderOverlayState extends State<ProViewfinderOverlay> {
  Offset _focusPoint = const Offset(0.5, 0.5);
  bool _isBlurring = false;
  double _isoValue = 12800;
  double _shutterValue = 4000;

  void _handleTapToFocus(TapDownDetails details, BoxConstraints constraints) {
    final double tapX = details.localPosition.dx / constraints.maxWidth;
    final double tapY = details.localPosition.dy / constraints.maxHeight;

    final double targetX = tapX > 0.5 ? 0.08 : 0.88;
    final double targetY = tapY > 0.5 ? 0.08 : 0.88;

    setState(() {
      _isBlurring = true;
      _focusPoint = Offset(targetX, targetY);
    });

    Future.delayed(const Duration(milliseconds: 650), () {
      if (mounted) {
        setState(() {
          _isBlurring = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapDown: (details) => _handleTapToFocus(details, constraints),
          child: Stack(
            children: [
              // Tap Blur Flash
              if (_isBlurring)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                    child: Container(
                      color: Colors.cyanAccent.withValues(alpha: 0.1),
                    ),
                  ),
                ),

              // Rule-of-Thirds Grid Lines
              Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.cyanAccent.withValues(alpha: 0.3),
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.cyanAccent.withValues(alpha: 0.3),
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Colors.cyanAccent.withValues(alpha: 0.3),
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Colors.cyanAccent.withValues(alpha: 0.3),
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),

              // Anti-Autofocus Reticle
              AnimatedPositioned(
                duration: const Duration(milliseconds: 350),
                curve: Curves.bounceOut,
                left: _focusPoint.dx * (constraints.maxWidth - 60),
                top: _focusPoint.dy * (constraints.maxHeight - 60),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _isBlurring ? Colors.redAccent : Colors.cyanAccent,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 4,
                      height: 4,
                      color: _isBlurring ? Colors.redAccent : Colors.cyanAccent,
                    ),
                  ),
                ),
              ),

              // Metadata Display
              Positioned(
                top: 14,
                left: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ISO ${_isoValue.toInt()} (CLIP)",
                      style: GoogleFonts.shareTechMono(
                        color: Colors.redAccent,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      "1/${_shutterValue.toInt()}s • f/1.2",
                      style: GoogleFonts.shareTechMono(
                        color: Colors.cyanAccent,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      "ANTI-STABILIZER: LIVE",
                      style: GoogleFonts.shareTechMono(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              // Simulated Histogram Display
              Positioned(
                bottom: 60,
                right: 14,
                child: Container(
                  width: 110,
                  height: 45,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    border: Border.all(color: Colors.white24, width: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: CustomPaint(painter: HistogramPainter()),
                ),
              ),

              // Controls Sliders
              Positioned(
                bottom: 10,
                left: 14,
                right: 14,
                child: Row(
                  children: [
                    Text(
                      "ISO",
                      style: GoogleFonts.shareTechMono(
                        color: Colors.redAccent,
                        fontSize: 10,
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: _isoValue,
                        min: 100,
                        max: 25600,
                        activeColor: Colors.redAccent,
                        inactiveColor: Colors.white12,
                        onChanged: (v) => setState(() => _isoValue = v),
                      ),
                    ),
                    Text(
                      "S",
                      style: GoogleFonts.shareTechMono(
                        color: Colors.cyanAccent,
                        fontSize: 10,
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: _shutterValue,
                        min: 60,
                        max: 8000,
                        activeColor: Colors.cyanAccent,
                        inactiveColor: Colors.white12,
                        onChanged: (v) => setState(() => _shutterValue = v),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HistogramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintRed = Paint()
      ..color = Colors.redAccent.withValues(alpha: 0.7);
    final Paint paintCyan = Paint()
      ..color = Colors.cyanAccent.withValues(alpha: 0.7);

    final Path pathRed = Path()..moveTo(0, size.height);
    final Path pathCyan = Path()..moveTo(0, size.height);

    for (double x = 0; x <= size.width; x += 5) {
      double yRed = size.height - (math.sin(x * 0.1) * 12 + 15);
      double yCyan = size.height - (math.cos(x * 0.12) * 14 + 18);
      pathRed.lineTo(x, yRed);
      pathCyan.lineTo(x, yCyan);
    }

    pathRed.lineTo(size.width, size.height);
    pathCyan.lineTo(size.width, size.height);

    canvas.drawPath(pathRed, paintRed);
    canvas.drawPath(pathCyan, paintCyan);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
