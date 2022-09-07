import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class Miui10AnimBuilder extends BaseAnimationBuilder {
  const Miui10AnimBuilder();

  @Deprecated('Please build animation builders outside the package')
  @override
  Widget buildWidget(
    BuildContext context,
    Widget child,
    AnimationController controller,
    double percent,
  ) {
    final double opacity = min(1.0, percent + 0.2);
    final double offset = (1 - percent) * 20;

    return Opacity(
      opacity: opacity,
      child: Transform.translate(offset: Offset(0, offset), child: child),
    );
  }
}
