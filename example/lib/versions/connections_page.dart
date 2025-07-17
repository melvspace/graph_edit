import 'package:example/widgets/node_inspector.dart';
import 'package:flutter/material.dart';
import 'package:graph_edit/graph_edit.dart';
import 'package:provider/provider.dart';

class ConnectionsPage extends StatefulWidget {
  const ConnectionsPage({super.key});

  @override
  State<ConnectionsPage> createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  final Map<String, BasicNode> nodes = Map.fromEntries(
    [
      BasicNode(
        id: '1',
        position: Offset.zero,
        title: '',
        ports: [
          BasicNodePort(
            id: '1',
            isInput: true,
            label: 'In 1',
            color: Colors.red,
          ),
          BasicNodePort(
            id: '2',
            isInput: true,
            label: 'In 2',
            color: Colors.yellow,
          ),
          BasicNodePort(
            id: '3',
            isInput: false,
            label: 'Out 1',
            color: Colors.blue,
          ),
          BasicNodePort(
            id: '4',
            isInput: false,
            label: 'Out 2',
            color: Colors.green,
          ),
        ],
        zIndex: 0,
      ),
      BasicNode(
        id: '2',
        position: Offset(100, 100),
        title: '',
        ports: [
          BasicNodePort(id: '5', isInput: true, label: 'In 1'),
          BasicNodePort(id: '6', isInput: true, label: 'In 2'),
          BasicNodePort(id: '7', isInput: false, label: 'Out 1'),
          BasicNodePort(id: '8', isInput: false, label: 'Out 2'),
        ],
        zIndex: 0,
      ),
    ].map((e) => MapEntry(e.id, e)),
  );

  String? _selected;
  set selected(String? value) =>
      mounted && _selected != value ? setState(() => _selected = value) : null;
  String? get selected => _selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => selected = null,
      child: Scaffold(
        appBar: AppBar(title: Text("Graph Canvas / V2")),
        drawer: context.watch<Drawer>(),
        body: Row(
          children: [
            Expanded(
              child: BasicGraphCanvas(
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
                  child: BasicNodeWidget(
                    node: node,
                    decoration: selected
                        ? kGraphNodeDecoration.copyWith(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.yellow.withValues(alpha: .5),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          )
                        : null,
                  ),
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
                      if (selected case String selected
                          when nodes.containsKey(selected))
                        NodeInspector(
                          node: nodes[selected]!,
                          onChanged: (value) => setState(
                            () => nodes[value.id] = value,
                          ),
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
