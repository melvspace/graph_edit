import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ConnectionCurve {
  final Offset start;
  final Offset startDirection;
  final Color startColor;

  final Offset end;
  final Offset endDirection;
  final Color endColor;

  ConnectionCurve({
    required this.start,
    required this.end,
    required this.startDirection,
    required this.endDirection,
    required this.startColor,
    required this.endColor,
  });

  void paint(Canvas canvas) {
    final distance = (end - start).distance;

    // Calculate control points
    final startControl =
        calculateControlPoints_v4(start, end, startDirection, distance);
    final endControl =
        calculateControlPoints_v4(end, start, endDirection, distance);

    // Create the cubic bezier path
    final path = cubic([
      start,
      start + startControl,
      end + endControl,
      end,
    ]);

    // Get actual path bounds for accurate shader bounds
    final pathBounds = path.getBounds();

    // Calculate gradient direction based on start-to-end vector
    final direction = (end - start).normalized();

    // Create alignment that follows the curve's overall direction
    final gradientBegin = Alignment(-direction.dx, -direction.dy);
    final gradientEnd = Alignment(direction.dx, direction.dy);

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..shader = LinearGradient(
          colors: [startColor, endColor],
          begin: gradientBegin,
          end: gradientEnd,
        ).createShader(pathBounds),
    );
  }

  Path cubic(List<Offset> controlPoints) {
    return Path()
      ..moveTo(controlPoints.first.dx, controlPoints.first.dy)
      ..cubicTo(
        controlPoints[1].dx,
        controlPoints[1].dy,
        controlPoints[2].dx,
        controlPoints[2].dy,
        controlPoints.last.dx,
        controlPoints.last.dy,
      );
  }

// Option 1: Proportional scaling with higher minimum
  Offset calculateControlPoints_v1(
    Offset start,
    Offset end,
    Offset direction,
    double distance,
  ) {
    // Use a higher base percentage and ensure minimum visibility
    final controlDistance = (distance * 0.4).clamp(100.0, 300.0);
    return direction * controlDistance;
  }

// Option 2: Distance-aware scaling (RECOMMENDED)
  Offset calculateControlPoints_v2(
    Offset start,
    Offset end,
    Offset direction,
    double distance,
  ) {
    // Scale more aggressively for longer distances
    final baseControl = 80.0;
    final scaleFactor =
        0.3 + (distance / 1000.0) * 0.2; // Increases with distance
    final controlDistance =
        (distance * scaleFactor).clamp(baseControl, distance * 0.5);

    return direction * controlDistance;
  }

// Option 3: Hybrid approach with direction emphasis
  Offset calculateControlPoints_v3(
    Offset start,
    Offset end,
    Offset direction,
    double distance,
  ) {
    // Ensure control points are always significant relative to distance
    final minRatio = 0.25; // Minimum 25% of distance
    final maxRatio = 0.4; // Maximum 40% of distance

    // Calculate ratio based on distance (longer distances get higher ratios)
    final ratio =
        minRatio + (maxRatio - minRatio) * (distance / 1000.0).clamp(0.0, 1.0);
    final controlDistance = distance * ratio;

    return direction * controlDistance.clamp(120.0, 400.0);
  }

// Option 4: Exponential scaling for very far nodes
  Offset calculateControlPoints_v4(
    Offset start,
    Offset end,
    Offset direction,
    double distance,
  ) {
    // Use exponential scaling to ensure curves remain visible at all distances
    final baseControl = 100.0;
    final scaledControl =
        baseControl * (1.0 + log(distance / 200.0).clamp(0.0, 2.0));

    // Ensure minimum percentage of distance is maintained
    final minPercentage = distance * 0.3;
    final controlDistance =
        max(scaledControl, minPercentage).clamp(120.0, 500.0);

    return direction * controlDistance;
  }

// Option 5: Viewport-aware scaling (most sophisticated)
  Offset calculateControlPoints_v5(Offset start, Offset end, Offset direction,
      double distance, double viewportScale) {
    // Take into account zoom level - closer zoom needs more pronounced curves
    final zoomFactor = 1.0 / viewportScale.clamp(0.1, 3.0);

    // Base control scales with distance and zoom
    final baseControl = 100.0 * zoomFactor;
    final distanceControl = distance * (0.25 + 0.15 * zoomFactor);

    final controlDistance =
        max(baseControl, distanceControl).clamp(100.0, 600.0);

    return direction * controlDistance;
  }
}

extension on Offset {
  Offset normalized() {
    return this / distance;
  }

  double dot(Offset other) {
    return (dx * other.dx) + (dy * other.dy);
  }
}
