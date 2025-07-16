import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graph_edit/domain/entity/node.dart';
import 'package:graph_edit/presentation/widgets/graph_node_port_widget.dart';
import 'package:graph_edit/presentation/widgets/v2/graph_canvas.dart';

class GraphNodeParentData extends ParentData {
  String id;
  Offset position;
  Map<String, Offset> portOffsets;

  GraphNodeParentData({
    required this.id,
    required this.position,
    required this.portOffsets,
  });
}

class NodeParentDataWidget extends ParentDataWidget<GraphNodeParentData> {
  final Node node;

  NodeParentDataWidget({
    super.key,
    required this.node,
    required Widget Function(Node node) builder,
  }) : super(child: builder(node));

  @override
  void applyParentData(RenderObject renderObject) {
    final parentData = renderObject.parentData as GraphNodeParentData;
    if (parentData.id != node.id || !mapEquals(parentData.portOffsets, {})) {
      parentData.id = node.id;
      parentData.position = node.position;
      parentData.portOffsets = {};

      // Mark parent for layout since we changed parent data
      final parent = renderObject.parent;
      if (parent is RenderObject) {
        parent.markNeedsLayout();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => GraphCanvas;
}

class GraphNodeWidget extends StatefulWidget {
  final Node node;

  const GraphNodeWidget({
    super.key,
    required this.node,
  });

  @override
  GraphNodeWidgetState createState() => GraphNodeWidgetState();
}

class GraphNodeWidgetState extends State<GraphNodeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.node.title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final port in widget.node.inputs)
                      GraphNodePortWidget(
                        isInput: true,
                        port: port,
                      ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final port in widget.node.outputs)
                      GraphNodePortWidget(
                        isInput: false,
                        port: port,
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
