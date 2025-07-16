import 'dart:collection';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:graph_edit/domain/entity/entity.dart';
import 'package:graph_edit/extension/extension.dart';
import 'package:graph_edit/presentation/widgets/graph_node_canvas.dart';
import 'package:graph_edit/utility/calculate_node_size.dart';

typedef NodeBuilder = Widget Function(BuildContext context, Node node);

class NodeGraphState {
  final List<Node> nodes;
  final List<Connection> connections;
  final NodeAABB aabb;

  const NodeGraphState({
    required this.nodes,
    required this.connections,
    required this.aabb,
  });

  @override
  String toString() {
    return [
      "AABB: $aabb",
      "Nodes:\n\t${nodes.map((e) => e.id).join('\n\t')}",
      "Connections:\n\t${connections.map((e) => "${e.output.id} -> ${e.input.id}").join('\n\t')}",
    ].join('\n');
  }
}

class NodeGraphController extends ChangeNotifier {
  final BuildContext context;
  final NodeBuilder nodeBuilder;

  final Map<String, Node> _nodes = {};
  final List<Connection> _connections = [];
  final Map<String, Size> _sizes = {};

  bool _busy = false;
  NodeAABB? _aabb;

  NodeGraphState? get state {
    if (_aabb == null) return null;
    if (_nodes.isEmpty) return null;

    return NodeGraphState(
      nodes: UnmodifiableListView(_nodes.values),
      connections: UnmodifiableListView(_connections),
      aabb: _aabb!,
    );
  }

  NodeGraphController({
    required this.context,
    required this.nodeBuilder,
    required List<Node> initialNodes,
    required List<Connection> initialConnections,
  }) {
    _connections.addAll(initialConnections);

    _busy = true;
    Future.wait([for (final node in initialNodes) addNode(node)]) //
        .then((_) {
      _busy = false;

      _aabb = _nodes.values.getAABB(sizes: _sizes);

      notifyListeners();
    });
  }

  Future<void> addNode(Node node) async {
    final size = await calculateNodeSize(context, nodeBuilder(context, node));
    _nodes[node.id] = node;
    _sizes[node.id] = size;

    if (_busy) return;

    // TODO(@melvspace): 07/04/25 schedule on next frame to wait all additions in this frame
    _aabb = _nodes.values.getAABB(sizes: _sizes);
  }

  Size getSize(Node node) {
    assert(_sizes.containsKey(node.id), "Node size for ${node.id} not found");
    return _sizes[node.id]!;
  }

  void updateAABB(Node node) {
    _aabb = _nodes.values.getAABB(sizes: _sizes);
    return;

    final size = _sizes[node.id]!;
    final nodeRect = node.position & size;

    final aabb = _aabb!;
    final aabbNewRect = Rect.fromLTRB(
      nodeRect.left.compareTo(aabb.rect.left) < 0
          ? nodeRect.left
          : aabb.rect.left,
      nodeRect.top.compareTo(aabb.rect.top) < 0 ? nodeRect.top : aabb.rect.top,
      nodeRect.right.compareTo(_aabb!.rect.right) > 0
          ? nodeRect.right
          : _aabb!.rect.right,
      nodeRect.bottom.compareTo(aabb.rect.bottom) > 0
          ? nodeRect.bottom
          : aabb.rect.bottom,
    );

    Node left = aabb.left;
    Node top = aabb.top;
    Node right = aabb.right;
    Node bottom = aabb.bottom;

    if (nodeRect.left < left.position.dx) {
      left = node;
    }
    if (nodeRect.top < top.position.dy) {
      top = node;
    }
    if (nodeRect.right > right.position.dx) {
      right = node;
    }
    if (nodeRect.bottom > bottom.position.dy) {
      bottom = node;
    }

    _aabb = NodeAABB(
      rect: aabbNewRect,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }

  void moveNode(String nodeId, Offset delta) {
    final node = _nodes[nodeId]!;
    final newPosition = node.position + delta;
    final newNode = node.copyWith(position: newPosition);

    updateAABB(node);
    _nodes[node.id] = newNode;

    notifyListeners();
  }
}
