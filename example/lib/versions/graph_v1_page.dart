import 'package:example/versions/constant.dart';
import 'package:flutter/material.dart';
import 'package:graph_edit/graph_edit.dart';
import 'package:graph_edit/presentation/widgets/graph_node_widget.dart';
import 'package:provider/provider.dart';

class GraphV1Page extends StatelessWidget {
  const GraphV1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Graph Canvas / V1")),
      drawer: context.watch<Drawer>(),
      body: GraphNodeCanvas(
        nodes: kNodes,
        connections: [
          Connection(
            outputId: 'uuid4',
            inputId: 'uuid5',
          ),
        ],
        nodeBuilder: (context, node) => GraphNodeWidget(node: node),
      ),
    );
  }
}
