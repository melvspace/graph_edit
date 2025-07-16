// ignore_for_file: unused_element

import 'package:flutter/widgets.dart';
import 'package:graph_edit/domain/entity/node.dart';

class NodeAABB {
  final Rect rect;

  final Node left;
  final Node top;
  final Node right;
  final Node bottom;

  const NodeAABB({
    required this.rect,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  @override
  String toString() {
    // TODO: implement toString
    return "Rect: $rect, "
        "Left: ${left.id}, "
        "Top: ${top.id}, "
        "Right: ${right.id}, "
        "Bottom: ${bottom.id}";
  }
}

// TODO(@melvspace): 07/03/25 add Node Size provider for more precise calculation
extension AABBFromNodeListX on Iterable<Node> {
  /// Calculates the Axis-Aligned Bounding Box (AABB) for a collection of nodes.
  ///
  /// Returns a [Rect] that encompasses the minimum and maximum x and y coordinates
  /// of all nodes in the collection. This is useful for determining the overall
  /// spatial extent of a group of nodes.
  ///
  /// Returns:
  ///   A [Rect] representing the bounding box of all nodes.
  NodeAABB getAABB({Map<String, Size> sizes = const {}}) {
    Offset min = Offset.infinite;
    Offset max = -Offset.infinite;

    Node left, top, right, bottom;
    left = top = right = bottom = first;

    for (final node in this) {
      final size = sizes[node.id] ?? Size.zero;
      if (node.position.dx < left.position.dx) {
        left = node;
      }
      if (node.position.dx + size.width > right.position.dx) {
        right = node;
      }
      if (node.position.dy < top.position.dy) {
        top = node;
      }
      if (node.position.dy + size.height > bottom.position.dy) {
        bottom = node;
      }

      min = Offset(
        min.dx.compareTo(node.position.dx) < 0 ? min.dx : node.position.dx,
        min.dy.compareTo(node.position.dy) < 0 ? min.dy : node.position.dy,
      );
      max = Offset(
        max.dx.compareTo(node.position.dx + size.width) > 0
            ? max.dx
            : node.position.dx + size.width,
        max.dy.compareTo(node.position.dy + size.height) > 0
            ? max.dy
            : node.position.dy + size.height,
      );
    }

    return NodeAABB(
      rect: Rect.fromPoints(min, max),
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }
}
