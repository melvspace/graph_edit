import 'dart:ui';

class NodePort {
  final String id;
  final String label;

  // TODO(@melvspace): 07/03/25 abstract away
  final Color? color;

  const NodePort({
    required this.id,
    required this.label,
    this.color,
  });
}
