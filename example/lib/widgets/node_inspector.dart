import 'package:flutter/material.dart';
import 'package:graph_edit/graph_edit.dart';

class NodeInspector extends StatefulWidget {
  final BasicNode node;
  final ValueChanged<BasicNode>? onChanged;

  const NodeInspector({
    super.key,
    required this.node,
    this.onChanged,
  });

  @override
  State<NodeInspector> createState() => _NodeInspectorState();
}

class _NodeInspectorState extends State<NodeInspector> {
  late final TextEditingController _titleController = TextEditingController(
    text: widget.node.title,
  );

  @override
  void didUpdateWidget(covariant NodeInspector oldWidget) {
    if (_titleController.text != widget.node.title) {
      _titleController.text = widget.node.title;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _titleController,
          decoration: InputDecoration(hintText: 'Title'),
          onChanged: (value) => widget.onChanged?.call(
            widget.node.copyWith(title: value),
          ),
        ),
      ],
    );
  }
}
