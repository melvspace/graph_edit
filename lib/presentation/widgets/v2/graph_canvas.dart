import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:graph_edit/graph_edit.dart';
import 'package:graph_edit/presentation/widgets/graph_node_widget.dart';

class GraphCanvasController extends ChangeNotifier {
  Offset _position = Offset.zero;
  double _scale = 1.0;

  Offset get position => _position;
  double get scale => _scale;

  set position(Offset value) {
    _position = value;
    notifyListeners();
  }

  set scale(double value) {
    _scale = value;
    notifyListeners();
  }
}

typedef NodeWidgetBuilder = Widget Function(Node node);
typedef NodeDragCallback = void Function(
  String id,
  Offset position,
  int zIndex,
);

class GraphCanvas extends StatefulWidget {
  final List<Node> nodes;
  final List<Connection> connections;

  final NodeWidgetBuilder? nodeBuilder;
  final NodeDragCallback? onNodeDragged;

  const GraphCanvas({
    super.key,
    required this.nodes,
    required this.connections,
    this.nodeBuilder,
    this.onNodeDragged,
  });

  @override
  State<GraphCanvas> createState() => _GraphCanvasState();
}

class _GraphCanvasState extends State<GraphCanvas> {
  final controller = GraphCanvasController();

  final Map<String, Node> _nodes = {};
  final Map<String, Widget> _children = {};
  final Map<String, Offset> _offsetDeltaHolder = {};
  final Map<String, int> _zIndexChangeHolder = {};

  int maxZIndex = 0;

  @override
  void initState() {
    for (final node in widget.nodes) {
      _nodes[node.id] = node;
      _children[node.id] = buildNode(node);
      maxZIndex = max(maxZIndex, node.zIndex);
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant GraphCanvas oldWidget) {
    maxZIndex = 0;
    for (final node in widget.nodes) {
      maxZIndex = max(maxZIndex, node.zIndex);

      if (_nodes[node.id] == node) {
        continue;
      }

      _nodes[node.id] = node;
      _zIndexChangeHolder.remove(node.id);
      _offsetDeltaHolder.remove(node.id);
      _children[node.id] = buildNode(node);
    }

    super.didUpdateWidget(oldWidget);
  }

  Widget buildNode(Node node) {
    return Positioned(
      key: Key(node.id),
      left: node.position.dx + (_offsetDeltaHolder[node.id]?.dx ?? 0),
      top: node.position.dy + (_offsetDeltaHolder[node.id]?.dy ?? 0),
      child: GestureDetector(
        onPanStart: (details) {
          _zIndexChangeHolder[node.id] = ++maxZIndex;
        },
        onPanUpdate: (details) {
          _offsetDeltaHolder.putIfAbsent(node.id, () => Offset.zero);
          _offsetDeltaHolder[node.id] = _offsetDeltaHolder[node.id]! + //
              details.delta / controller.scale;

          setState(() {
            _children[node.id] = buildNode(node);
          });
        },
        onPanEnd: (details) {
          widget.onNodeDragged?.call(
            node.id,
            node.position + _offsetDeltaHolder[node.id]!,
            _zIndexChangeHolder[node.id] ?? node.zIndex,
          );
        },
        child: RepaintBoundary(
          child: widget.nodeBuilder?.call(node) ?? //
              GraphNodeWidget(node: node),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          var direction = event.scrollDelta.dy < 0;
          double oldScale = controller.scale;
          double newScale = oldScale * (direction ? 1.1 : 0.9);
          newScale = newScale.clamp(0.5, 2.0);
          double scaleRatio = newScale / oldScale;

          // Zoom towards cursor position
          controller.position = event.position +
              (controller.position - event.position) * scaleRatio;
          controller.scale = newScale;
        }
      },
      child: GestureDetector(
        onScaleUpdate: (details) {
          controller.position += details.focalPointDelta;
          controller.scale *= details.scale;
        },
        child: RepaintBoundary(
          child: GraphCanvasInternal(
            controller: controller,
            children: _children.entries
                .sortedBy<num>(
                  (element) =>
                      _zIndexChangeHolder[element.key] ??
                      _nodes[element.key]?.zIndex ??
                      0,
                )
                .map((e) => e.value)
                .toList(),
          ),
        ),
      ),
    );
  }
}

class GraphCanvasInternal extends MultiChildRenderObjectWidget {
  final GraphCanvasController controller;

  const GraphCanvasInternal({
    super.key,
    super.children,
    required this.controller,
  });

  @override
  MultiChildRenderObjectElement createElement() {
    return GraphCanvasInternalElement(this);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant GraphCanvasInternalRenderObject renderObject,
  ) {
    renderObject.panOffset = controller.position;
    renderObject.scale = controller.scale;

    super.updateRenderObject(
      context,
      renderObject,
    );
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return GraphCanvasInternalRenderObject()
      ..panOffset = controller.position
      ..scale = controller.scale;
  }
}

class GraphCanvasInternalElement extends MultiChildRenderObjectElement {
  GraphCanvasInternalElement(super.widget);

  @override
  GraphCanvasInternal get widget => super.widget as GraphCanvasInternal;

  @override
  GraphCanvasInternalRenderObject get renderObject =>
      super.renderObject as GraphCanvasInternalRenderObject;

  void updateRenderObject() {
    renderObject.panOffset = widget.controller.position;
    renderObject.scale = widget.controller.scale;
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    widget.controller.addListener(updateRenderObject);

    super.mount(parent, newSlot);
  }

  @override
  void unmount() {
    widget.controller.removeListener(updateRenderObject);

    super.unmount();
  }
}

class GraphCanvasInternalRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, StackParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, StackParentData> {
  // Transform state
  Offset _panOffset = Offset.zero;
  double _scale = 1.0;

  Rect get viewBounds {
    return -(_panOffset / _scale) & (size / _scale);
  }

  set panOffset(Offset offset) {
    if (_panOffset != offset) {
      _panOffset = offset;
      markNeedsPaint();
    }
  }

  set scale(double scale) {
    if (_scale != scale) {
      _scale = scale;
      markNeedsPaint();
    }
  }

  void resetTransform() {
    _panOffset = Offset.zero;
    _scale = 1.0;
    markNeedsPaint();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! StackParentData) {
      child.parentData = StackParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    // Layout children with unconstrained size
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as StackParentData;
      child.layout(const BoxConstraints(), parentUsesSize: true);
      child = childParentData.nextSibling;
    }
  }

  void paintBackground(PaintingContext context, Offset offset) {
    context.canvas.drawRect(
      offset & size,
      Paint()..color = Colors.grey.shade900,
    );

    final gap = 50.0;
    final scaledGap = gap * _scale;

    // Calculate grid offset accounting for pan and scale
    final gridOffsetX = _panOffset.dx % scaledGap;
    final gridOffsetY = _panOffset.dy % scaledGap;

    // Draw vertical lines
    for (double x = gridOffsetX; x < size.width; x += scaledGap) {
      final color = switch ((_panOffset.dx - x).abs()) {
        < 0.01 => Colors.green.shade300,
        _ => const Color.fromARGB(255, 46, 46, 46)
      };

      context.canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        Paint() //
          ..strokeWidth = 1 * _scale
          ..color = color,
      );
    }

    // Draw horizontal lines
    for (double y = gridOffsetY; y < size.height; y += scaledGap) {
      final color = switch ((_panOffset.dy - y).abs()) {
        < 0.01 => Colors.red.shade300,
        _ => const Color.fromARGB(255, 46, 46, 46)
      };

      context.canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        Paint() //
          ..strokeWidth = 1 * _scale
          ..color = color,
      );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Background
    paintBackground(context, offset);

    // Paint children
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as StackParentData;
      final childOffset = Offset(
        childParentData.left ?? 0,
        childParentData.top ?? 0,
      );

      if (viewBounds.overlaps(childOffset & child.size)) {
        context.pushLayer(
          TransformLayer(
            offset: _panOffset,
            transform: Matrix4.identity().scaled(_scale),
          ),
          (PaintingContext context, Offset offset) {
            context.paintChild(child!, childOffset);
          },
          offset,
        );
      }

      child = childParentData.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    // Transform hit test position to account for pan and scale
    final transformedPosition = (position - _panOffset) / _scale;

    RenderBox? child = lastChild;
    while (child != null) {
      final childParentData = child.parentData! as StackParentData;
      final childOffset = childParentData.offset +
          Offset(
            childParentData.left ?? 0,
            childParentData.top ?? 0,
          );

      if (result.addWithPaintOffset(
        offset: childOffset,
        position: transformedPosition,
        hitTest: (BoxHitTestResult result, Offset position) {
          return child!.hitTest(result, position: position);
        },
      )) {
        return true;
      }
      child = childParentData.previousSibling;
    }

    return true;
  }
}
