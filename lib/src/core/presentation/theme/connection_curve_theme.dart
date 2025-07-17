import 'package:flutter/material.dart';
import 'package:graph_edit/graph_edit.dart';

class ConnectionCurveTheme<TNodePort extends NodePort> {
  final double strokeWidth;

  const ConnectionCurveTheme({
    required this.strokeWidth,
  });

  factory ConnectionCurveTheme.$default() {
    return ConnectionCurveTheme(strokeWidth: 2);
  }

  ConnectionCurveDecoration buildDecoration(
    BuildContext context,
    TNodePort left,
    TNodePort right,
  ) {
    return ConnectionCurveDecoration(
      strokeWidth: strokeWidth,
      startColor: Colors.white,
      endColor: Colors.white,
    );
  }
}

class ConnectionCurveDecoration {
  final Color startColor;
  final Color endColor;
  final double strokeWidth;

  const ConnectionCurveDecoration({
    required this.strokeWidth,
    required this.startColor,
    required this.endColor,
  });
}
