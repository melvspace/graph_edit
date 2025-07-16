import 'package:flutter/widgets.dart';

/// A widget that allows extracting the size of its child widget.
///
/// This widget can be used to measure the runtime size of a child widget
/// by providing a callback that receives the widget's size.
class WidgetSizeExtractor extends StatelessWidget {
  final Widget child;
  final ValueChanged<Size>? onSizeChanged;

  const WidgetSizeExtractor({
    super.key,
    required this.child,
    this.onSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        if (context.findRenderObject() case RenderBox box when box.hasSize) {
          onSizeChanged?.call(box.size);
        }
      }
    });

    return child;
  }
}
