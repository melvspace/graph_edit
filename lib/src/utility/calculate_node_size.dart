import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graph_edit/src/utility/widget_size_extractor.dart';

/// Calculates the size of a given widget by temporarily inserting it into an overlay.
///
/// This method allows measuring the size of a widget without rendering it in the main layout.
/// It uses an [OverlayEntry] with an [Offstage] widget to measure the widget's dimensions.
///
/// [context] The build context used to access the overlay.
/// [node] The widget whose size needs to be calculated.
///
/// Returns a [Future] that completes with the [Size] of the widget.
Future<Size> calculateNodeSize(BuildContext context, Widget node) {
  final completer = Completer<Size>();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    OverlayEntry? entry;
    entry = OverlayEntry(
      opaque: false,
      builder: (context) {
        return UnconstrainedBox(
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: WidgetSizeExtractor(
                onSizeChanged: (value) {
                  if (!completer.isCompleted) {
                    completer.complete(value);
                  }
                  entry!.remove();
                },
                child: node,
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(entry);
  });

  return completer.future;
}
