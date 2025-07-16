import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:graph_edit/src/domain/entity/node_port.dart';

class Node with EquatableMixin {
  final String id;
  final String title;
  final List<NodePort> inputs;
  final List<NodePort> outputs;

  // TODO(@melvspace): 07/04/25 support serialization
  final Offset position;
  final int zIndex;

  const Node({
    required this.id,
    required this.title,
    required this.inputs,
    required this.outputs,
    required this.position,
    required this.zIndex,
  });

  Node copyWith({
    String? id,
    String? title,
    List<NodePort>? inputs,
    List<NodePort>? outputs,
    Offset? position,
    int? zIndex,
  }) =>
      Node(
        id: id ?? this.id,
        title: title ?? this.title,
        inputs: inputs ?? this.inputs,
        outputs: outputs ?? this.outputs,
        position: position ?? this.position,
        zIndex: zIndex ?? this.zIndex,
      );

  @override
  List<Object?> get props => [id, title, inputs, outputs, position, zIndex];
}
