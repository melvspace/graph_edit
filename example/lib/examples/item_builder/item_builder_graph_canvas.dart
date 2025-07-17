import 'package:example/examples/item_builder/item_builder_node.dart';
import 'package:example/examples/item_builder/item_builder_node_widget.dart';
import 'package:flutter/material.dart';
import 'package:graph_edit/graph_edit.dart';

class ItemBuilderGraphCanvas extends StatelessWidget {
  final List<ItemBuilderNode> nodes;
  final List<Connection> connections;

  final String? selected;
  final NodeDragCallback? onNodeDragged;

  final NodeWidgetBuilder<ItemBuilderNode, BasicNodePort>? nodeBuilder;

  const ItemBuilderGraphCanvas({
    super.key,
    required this.nodes,
    required this.connections,
    this.selected,
    this.onNodeDragged,
    this.nodeBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return GraphCanvas<ItemBuilderNode, BasicNodePort>(
      nodes: nodes,
      selected: selected,
      connections: connections,
      connectionTheme: BasicConnectionTheme(strokeWidth: 2),
      onNodeDragged: onNodeDragged,
      nodeBuilder: nodeBuilder ?? //
          (node, selected) => ItemBuilderNodeWidget(node: node),
    );
  }
}
