import 'package:flutter/material.dart';

class Connection {
  final String outputId;
  final String inputId;
  final Color color;

  Connection({
    required this.outputId,
    required this.inputId,
    this.color = Colors.white,
  });
}
