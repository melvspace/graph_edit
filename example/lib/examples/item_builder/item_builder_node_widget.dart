import 'package:example/examples/item_builder/item_builder_node.dart';
import 'package:flutter/material.dart';
import 'package:graph_edit/graph_edit.dart';

class ItemBuilderNodeWidget extends StatelessWidget {
  final ItemBuilderNode node;

  const ItemBuilderNodeWidget({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    switch (node) {
      case ItemBaseNode node:
        // TODO: Handle this case.
        return Container(
          decoration: kGraphNodeDecoration,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    node.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );

      case ItemTierProducerNode node:
        return Container(
          decoration: kGraphNodeDecoration,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                8,
                (index) => Text('T$index'),
              ),
            ),
          ),
        );

      case ItemOutputNode node:
        return Container(
          decoration: kGraphNodeDecoration,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    node.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }
}
