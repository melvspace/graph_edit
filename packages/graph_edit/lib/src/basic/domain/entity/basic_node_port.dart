import 'package:flutter/material.dart';
import 'package:graph_edit/src/core/domain/entity/node_port.dart';

class BasicNodePort extends NodePort {
  final String label;
  final bool isInput;
  final Color? color;

  const BasicNodePort({
    required super.id,
    required this.label,
    required this.isInput,
    this.color,
  });
}
