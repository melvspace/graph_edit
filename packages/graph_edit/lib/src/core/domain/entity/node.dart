import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:graph_edit/src/core/domain/entity/node_port.dart';

abstract class Node<TNodePort extends NodePort> with EquatableMixin {
  final String id;
  final Offset position;
  final int zIndex;

  final List<TNodePort> ports;

  const Node({
    required this.id,
    required this.position,
    required this.zIndex,
    required this.ports,
  });

  @override
  List<Object?> get props => [id, position, zIndex, ports];
}
