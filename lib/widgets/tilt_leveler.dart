import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroTiltLeveler extends StatefulWidget {
  final Widget child;
  const GyroTiltLeveler({super.key, required this.child});

  @override
  State<GyroTiltLeveler> createState() => _GyroTiltLevelerState();
}

class _GyroTiltLevelerState extends State<GyroTiltLeveler> {
  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  double _sabotagedAngle = 0.25; // Initial intentional offset

  @override
  void initState() {
    super.initState();
    _initAccelerometer();
  }

  void _initAccelerometer() {
    // Task A2: Accelerometer tracking with dynamic negative multiplier
    _accelSubscription = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      if (!mounted) return;
      // Calculate roll angle in radians from X/Y acceleration
      double rollAngle = math.atan2(event.x, event.y);

      setState(() {
        // Pass -angle * 1.5 to aggressively tilt away from horizontal balance
        _sabotagedAngle = (-rollAngle * 1.5).clamp(-0.75, 0.75);
      });
    });
  }

  @override
  void dispose() {
    _accelSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: _sabotagedAngle / (2 * math.pi),
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: widget.child,
    );
  }
}
