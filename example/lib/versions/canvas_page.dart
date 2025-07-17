import 'dart:math';

import 'package:example/utility/run_mode.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:graph_edit/graph_edit.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CanvasPage extends StatefulWidget {
  const CanvasPage({super.key});

  @override
  State<CanvasPage> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
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

  late final Map<String, BasicNode> nodes;

  Map<String, BasicNode> createInitialData() {
    final map = <String, BasicNode>{};
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
      body: BasicGraphCanvas(
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

BasicNode generate(Size bounds) {
  final random = Random();
  final position = Offset(
    (random.nextInt(bounds.width.toInt()) - bounds.width ~/ 2).toDouble(),
    (random.nextInt(bounds.height.toInt()) - bounds.height ~/ 2).toDouble(),
  );

  return BasicNode(
    id: Uuid().v4(),
    position: position,
    zIndex: 0,
    title:
        '(${position.dx.toInt()}, ${position.dy.toInt()}) '
        '${faker.lorem.words(random.nextInt(3) + 2).join(' ')}',
    ports: [
      BasicNodePort(id: Uuid().v4(), isInput: true, label: faker.lorem.word()),
      BasicNodePort(id: Uuid().v4(), isInput: false, label: faker.lorem.word()),
      BasicNodePort(id: Uuid().v4(), isInput: false, label: faker.lorem.word()),
      BasicNodePort(id: Uuid().v4(), isInput: false, label: faker.lorem.word()),
    ],
  );
}
