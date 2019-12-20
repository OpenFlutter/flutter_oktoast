import 'package:flutter/material.dart';
import 'dart:math' show min;
import 'animation_builder.dart';

class Miui10AnimBuilder extends BaseAnimationBuilder {
  @override
  Widget buildWidget(
    BuildContext context,
    Widget child,
    AnimationController controller,
    double percent,
  ) {
    final opacity = min(1.0, percent + 0.2);
    final offset = (1 - percent) * 20;

    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        child: child,
        offset: Offset(0, offset),
      ),
    );
  }
}
