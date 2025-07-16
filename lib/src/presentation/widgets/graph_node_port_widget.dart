import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graph_edit/src/domain/entity/node_port.dart';

class GraphNodePortViewModel extends ParentData {
  final NodePort port;
  final Offset direction;

  GraphNodePortViewModel({
    required this.port,
    required this.direction,
  });
}

class GraphNodePortWidget extends StatelessWidget {
  final NodePort port;
  final bool isInput;

  const GraphNodePortWidget({
    super.key,
    required this.port,
    required this.isInput,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          ...() {
            final widgets = [
              MetaData(
                metaData: GraphNodePortViewModel(
                  port: port,
                  direction: isInput ? Offset(-1, 0) : Offset(1, 0),
                ),
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: port.color ?? Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(port.label, style: const TextStyle(color: Colors.white)),
            ];

            if (!isInput) {
              return widgets.reversed;
            }

            return widgets;
          }(),
        ],
      ),
    );
  }
}
