import 'package:flutter/material.dart';
import 'package:graph_edit/graph_edit.dart';
import 'package:graph_edit/src/basic/presentation/theme/basic_connection_theme.dart';

class BasicGraphCanvas extends StatelessWidget {
  final List<BasicNode> nodes;
  final List<Connection> connections;

  final String? selected;
  final NodeDragCallback? onNodeDragged;

  final NodeWidgetBuilder<BasicNode, BasicNodePort>? nodeBuilder;

  const BasicGraphCanvas({
    super.key,
    required this.nodes,
    required this.connections,
    this.selected,
    this.onNodeDragged,
    this.nodeBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return GraphCanvas<BasicNode, BasicNodePort>(
      nodes: nodes,
      selected: selected,
      connections: connections,
      connectionTheme: BasicConnectionTheme(strokeWidth: 2),
      onNodeDragged: onNodeDragged,
      nodeBuilder: nodeBuilder ?? //
          (node, selected) => BasicNodeWidget(node: node),
    );
  }
}
