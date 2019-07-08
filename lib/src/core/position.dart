import 'package:flutter/widgets.dart';

class ToastPosition {
  final AlignmentGeometry align;
  final double offset;

  const ToastPosition({this.align = Alignment.center, this.offset = 0.0});

  static const center =
      const ToastPosition(align: Alignment.center, offset: 0.0);

  static const bottom =
      const ToastPosition(align: Alignment.bottomCenter, offset: -30.0);

  static const top =
      const ToastPosition(align: Alignment.topCenter, offset: 75.0);

  @override
  String toString() {
    return "ToastPosition [ align = $align, offset = $offset ] ";
  }
}
