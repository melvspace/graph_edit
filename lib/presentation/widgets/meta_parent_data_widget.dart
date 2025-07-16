import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MetaParentData extends ParentData {}

class MetaParentDataWidget extends ParentDataWidget<MetaParentData> {
  final MetaParentData data;

  const MetaParentDataWidget({
    super.key,
    required this.data,
    required super.child,
  });

  @override
  void applyParentData(RenderObject renderObject) {
    final changed = renderObject.parentData != data;
    renderObject.parentData = data;

    if (changed) {
      renderObject.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => Widget;
}
