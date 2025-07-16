import 'dart:math';

import 'package:example/utility/run_mode.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:graph_edit/graph_edit.dart';
import 'package:graph_edit/presentation/widgets/v2/graph_canvas.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RandomGraphPage extends StatefulWidget {
  const RandomGraphPage({super.key});

  @override
  State<RandomGraphPage> createState() => _RandomGraphPageState();
}

class _RandomGraphPageState extends State<RandomGraphPage> {
  int get count => switch (RunMode.current) {
    RunMode.release => 1000,
    RunMode.profile => 500,
    RunMode.debug => 100,
  };

  double get bounds => switch (RunMode.current) {
    RunMode.release => 20000,
    RunMode.profile => 10000,
    RunMode.debug => 5000,
  };

  late final Map<String, Node> nodes;

  Map<String, Node> createInitialData() {
    final map = <String, Node>{};
    for (final _ in List.generate(count, (index) => index)) {
      final node = generate(Size(bounds, bounds));
      map[node.id] = node;
    }

    return map;
  }

  @override
  void initState() {
    nodes = createInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Graph Canvas / V2")),
      drawer: context.watch<Drawer>(),
      body: GraphCanvas(
        nodes: nodes.values.toList(),
        connections: [],
        onNodeDragged: (id, delta, zIndex) {
          setState(() {
            nodes[id] = nodes[id]!.copyWith(position: delta, zIndex: zIndex);
          });
        },
      ),
    );
  }
}

Node generate(Size bounds) {
  final random = Random();
  final position = Offset(
    (random.nextInt(bounds.width.toInt()) - bounds.width ~/ 2).toDouble(),
    (random.nextInt(bounds.height.toInt()) - bounds.height ~/ 2).toDouble(),
  );

  return Node(
    id: Uuid().v4(),
    position: position,
    zIndex: 0,
    title:
        '(${position.dx.toInt()}, ${position.dy.toInt()}) '
        '${faker.lorem.words(random.nextInt(3) + 2).join(' ')}',
    inputs: [
      NodePort(id: Uuid().v4(), label: faker.lorem.word()),
    ],
    outputs: [
      NodePort(id: Uuid().v4(), label: faker.lorem.word()),
      NodePort(id: Uuid().v4(), label: faker.lorem.word()),
      NodePort(id: Uuid().v4(), label: faker.lorem.word()),
    ],
  );
}
