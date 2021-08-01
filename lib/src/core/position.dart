import 'package:flutter/widgets.dart';

class ToastPosition {
  const ToastPosition({this.align = Alignment.center, this.offset = 0.0});

  final AlignmentGeometry align;
  final double offset;

  static const ToastPosition center =
      ToastPosition(align: Alignment.center, offset: 0.0);

  static const ToastPosition bottom =
      ToastPosition(align: Alignment.bottomCenter, offset: -30.0);

  static const ToastPosition top =
      ToastPosition(align: Alignment.topCenter, offset: 75.0);

  @override
  String toString() => 'ToastPosition(align: $align, offset: $offset)';
}
