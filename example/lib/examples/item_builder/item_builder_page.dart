import 'package:example/examples/item_builder/item_builder_graph_canvas.dart';
import 'package:example/examples/item_builder/item_builder_node.dart';
import 'package:example/examples/item_builder/item_builder_node_widget.dart';
import 'package:example/widgets/node_inspector.dart';
import 'package:flutter/material.dart';
import 'package:graph_edit/graph_edit.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ItemBuilderPage extends StatefulWidget {
  const ItemBuilderPage({super.key});

  @override
  State<ItemBuilderPage> createState() => _ItemBuilderPageState();
}

class _ItemBuilderPageState extends State<ItemBuilderPage> {
  final Map<String, ItemBuilderNode> nodes = {};

  String? _selected;
  set selected(String? value) =>
      mounted && _selected != value ? setState(() => _selected = value) : null;
  String? get selected => _selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => selected = null,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Graph Canvas / V2"),
          actions: [
            IconButton(
              onPressed: () => setState(() {
                final id = Uuid().v7();
                nodes[id] = ItemBaseNode(
                  id: id,
                  position: Offset.zero,
                  zIndex: 0,
                  ports: [],
                  name: "Node",
                );
              }),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        drawer: context.watch<Drawer>(),
        body: Row(
          children: [
            Expanded(
              child: ItemBuilderGraphCanvas(
                nodes: nodes.values.toList(),
                selected: selected,
                onNodeDragged: (id, position, zIndex) => setState(() {
                  nodes[id] = nodes[id]!.copyWith(
                    position: position,
                    zIndex: zIndex,
                  );
                }),
                connections: [
                  Connection(outputId: '3', inputId: '5'),
                  Connection(outputId: '4', inputId: '6'),
                  Connection(outputId: '7', inputId: '1'),
                  Connection(outputId: '8', inputId: '2'),
                ],
                nodeBuilder: (node, selected) => GestureDetector(
                  onTap: () => this.selected = node.id,
                  child: ItemBuilderNodeWidget(node: node),
                ),
              ),
            ),
            SizedBox(
              width: 390,
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Inspector",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
