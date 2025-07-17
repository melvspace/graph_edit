import 'package:flutter/material.dart';
import 'package:graph_edit/graph_edit.dart';

class NodePortWidgetMetadataValue {
  final NodePort port;
  final Offset direction;

  NodePortWidgetMetadataValue({
    required this.port,
    required this.direction,
  });
}

class NodePortWidgetMetadata extends StatelessWidget {
  final Widget child;
  final NodePortWidgetMetadataValue data;

  const NodePortWidgetMetadata({
    super.key,
    required this.child,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return MetaData(
      metaData: data,
      child: child,
    );
  }
}
