import 'package:flutter/material.dart';
import 'package:graph_edit/src/basic/domain/entity/basic_node.dart';
import 'package:graph_edit/src/basic/presentation/widgets/basic_node_port_widget.dart';

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

class BasicNodeWidget extends StatefulWidget {
  final BasicNode node;
  final BoxDecoration? decoration;

  const BasicNodeWidget({
    super.key,
    required this.node,
    this.decoration,
  });

  @override
  BasicNodeWidgetState createState() => BasicNodeWidgetState();
}

class BasicNodeWidgetState extends State<BasicNodeWidget> {
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
                    for (final port
                        in widget.node.ports.where((port) => port.isInput))
                      BasicNodePortWidget(
                        isInput: true,
                        port: port,
                      ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final port
                        in widget.node.ports.where((port) => !port.isInput))
                      BasicNodePortWidget(
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
