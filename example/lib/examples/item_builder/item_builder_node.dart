import 'dart:ui';

import 'package:graph_edit/graph_edit.dart';

sealed class ItemBuilderNode extends Node<BasicNodePort> {
  ItemBuilderNode({
    required super.id,
    required super.position,
    required super.zIndex,
    required super.ports,
  });

  ItemBuilderNode copyWith({
    String? id,
    Offset? position,
    int? zIndex,
    List<BasicNodePort>? ports,
  });
}

class ItemBaseNode extends ItemBuilderNode {
  final String name;

  ItemBaseNode({
    required super.id,
    required super.position,
    required super.zIndex,
    required super.ports,
    required this.name,
  });

  @override
  ItemBaseNode copyWith({
    String? id,
    Offset? position,
    int? zIndex,
    List<BasicNodePort>? ports,
  }) {
    return ItemBaseNode(
      id: id ?? this.id,
      position: position ?? this.position,
      zIndex: zIndex ?? this.zIndex,
      ports: ports ?? this.ports,
      name: name,
    );
  }
}

class ItemTierProducerNode extends ItemBuilderNode {
  ItemTierProducerNode({
    required super.id,
    required super.position,
    required super.zIndex,
    required super.ports,
  });

  @override
  ItemTierProducerNode copyWith({
    String? id,
    Offset? position,
    int? zIndex,
    List<BasicNodePort>? ports,
  }) {
    return ItemTierProducerNode(
      id: id ?? this.id,
      position: position ?? this.position,
      zIndex: zIndex ?? this.zIndex,
      ports: ports ?? this.ports,
    );
  }
}

class ItemOutputNode extends ItemBuilderNode {
  final String name;

  ItemOutputNode({
    required super.id,
    required super.position,
    required super.zIndex,
    required super.ports,
    required this.name,
  });

  @override
  ItemOutputNode copyWith({
    String? id,
    Offset? position,
    int? zIndex,
    List<BasicNodePort>? ports,
  }) {
    return ItemOutputNode(
      id: id ?? this.id,
      position: position ?? this.position,
      zIndex: zIndex ?? this.zIndex,
      ports: ports ?? this.ports,
      name: name,
    );
  }
}
