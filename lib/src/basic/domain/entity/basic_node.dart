import 'dart:ui';

import 'package:graph_edit/src/basic/domain/entity/basic_node_port.dart';
import 'package:graph_edit/src/core/domain/entity/node.dart';

class BasicNode extends Node<BasicNodePort> {
  final String title;

  BasicNode({
    required super.id,
    required this.title,
    required super.position,
    required super.zIndex,
    required super.ports,
  });

  BasicNode copyWith({
    String? id,
    String? title,
    List<BasicNodePort>? ports,
    Offset? position,
    int? zIndex,
  }) =>
      BasicNode(
        id: id ?? this.id,
        title: title ?? this.title,
        ports: ports ?? this.ports,
        position: position ?? this.position,
        zIndex: zIndex ?? this.zIndex,
      );

  @override
  List<Object?> get props => [id, title, ports, position, zIndex];
}
