import 'package:flutter/material.dart';
import 'package:graph_edit/src/basic/domain/entity/basic_node_port.dart';
import 'package:graph_edit/src/core/presentation/theme/connection_curve_theme.dart';

class BasicConnectionTheme extends ConnectionCurveTheme<BasicNodePort> {
  const BasicConnectionTheme({required super.strokeWidth});

  @override
  ConnectionCurveDecoration buildDecoration(
    BuildContext context,
    BasicNodePort left,
    BasicNodePort right,
  ) {
    return ConnectionCurveDecoration(
      strokeWidth: strokeWidth,
      startColor: left.color ?? Colors.white,
      endColor: right.color ?? Colors.white,
    );
  }
}
