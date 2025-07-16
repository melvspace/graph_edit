import 'package:flutter/material.dart';
import 'package:graph_edit/domain/entity/entity.dart';
import 'package:graph_edit/extension/extension.dart';
import 'package:graph_edit/presentation/controller/node_graph_controller.dart';
import 'package:graph_edit/presentation/widgets/graph_node_widget.dart';
import 'package:graph_edit/utility/widget_size_extractor.dart';
import 'package:vector_math/vector_math_64.dart' show Quad;

typedef SizeBuilder = NodeSize Function(BuildContext context, Node node);

class NodeSize {
  final Size size;

  NodeSize({
    required this.size,
  });
}

class NodeBuilder {
  final WidgetBuilder builder;
  final SizeBuilder? sizeBuilder;

  NodeBuilder({
    required this.builder,
    required this.sizeBuilder,
  });
}

class GraphNodeCanvas extends StatefulWidget {
  final List<Node> nodes;
  final List<Connection> connections;

  final Widget Function(BuildContext context, Node node)? nodeBuilder;

  const GraphNodeCanvas({
    super.key,
    required this.nodes,
    required this.connections,
    this.nodeBuilder,
  });

  @override
  GraphNodeCanvasState createState() => GraphNodeCanvasState();
}

class GraphNodeCanvasState extends State<GraphNodeCanvas> {
  late final NodeGraphController controller = NodeGraphController(
    context: context,
    nodeBuilder: (context, node) => GraphNodeWidget(node: node),
    initialNodes: widget.nodes,
    initialConnections: widget.connections,
  );

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final state = controller.state;
        if (state == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return SizedBox.expand(
          child: Builder(
            builder: (context) {
              Rect rect = state.aabb.rect;
              final aabb = state.aabb;

              return Stack(
                children: [
                  ColoredBox(
                    color: Colors.green,
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 2.0,
                      constrained: false,
                      alignment: Alignment.center,
                      boundaryMargin: EdgeInsets.all(double.infinity),
                      child: ColoredBox(
                        color: Colors.grey.shade900,
                        child: SizedBox(
                          width: rect.width,
                          height: rect.height,
                          child: CustomPaint(
                            painter: ConnectionPainter(widget.connections),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                for (final node in state.nodes)
                                  Positioned(
                                    left: node.position.dx - rect.left,
                                    top: node.position.dy - rect.top,
                                    child: Tooltip(
                                      message: [
                                        "ID: ${node.id}",
                                        "Is Left: ${aabb.left.id == node.id}",
                                        "Is Top: ${aabb.top.id == node.id}",
                                        "Is Right: ${aabb.right.id == node.id}",
                                        "Is Bottom: ${aabb.bottom.id == node.id}",
                                      ].join('\n'),
                                      child: GestureDetector(
                                        onScaleUpdate: (details) {
                                          controller.moveNode(
                                              node.id, details.focalPointDelta);
                                        },
                                        child: RepaintBoundary(
                                          child: GraphNodeWidget(node: node),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(child: Text(controller.state.toString()))
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class Connection {
  final String outputId;
  final String inputId;
  final Color color;

  Connection({
    required this.outputId,
    required this.inputId,
    this.color = Colors.white,
  });
}

class ConnectionPainter extends CustomPainter {
  final List<Connection> connections;

  ConnectionPainter(this.connections);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var connection in connections) {
      paint.color = connection.color;
      // Add bezier curve drawing logic here
    }
  }

  @override
  bool shouldRepaint(ConnectionPainter oldDelegate) {
    return oldDelegate.connections != connections;
  }
}

extension on Rect {
  operator +(Size size) {
    return Rect.fromLTWH(left, top, width + size.width, height + size.height);
  }
}

extension on Quad {
  Rect get rect => Rect.fromLTRB(
        point0.x.toDouble(),
        point0.y.toDouble(),
        point3.x.toDouble(),
        point3.y.toDouble(),
      );
}
