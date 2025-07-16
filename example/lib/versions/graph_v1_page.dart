import 'package:example/versions/constant.dart';
import 'package:flutter/material.dart';
import 'package:graph_edit/graph_edit.dart';
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
            output: NodePort(label: 'Output', id: 'uuid4'),
            input: NodePort(label: 'Input', id: 'uuid5'),
          ),
        ],
      ),
    );
  }
}
