import 'package:flutter/material.dart';
import 'package:graph_edit/src/domain/entity/node.dart';
import 'package:graph_edit/src/presentation/widgets/graph_node_port_widget.dart';

final kGraphNodeDecoration = BoxDecoration(
  color: Colors.grey[800],
  borderRadius: BorderRadius.circular(8),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: .5),
      spreadRadius: 2,
      blurRadius: 5,
    ),
  ],
);

class GraphNodeWidget extends StatefulWidget {
  final Node node;
  final BoxDecoration? decoration;

  const GraphNodeWidget({
    super.key,
    required this.node,
    this.decoration,
  });

  @override
  GraphNodeWidgetState createState() => GraphNodeWidgetState();
}

class GraphNodeWidgetState extends State<GraphNodeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.decoration ?? kGraphNodeDecoration,
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
