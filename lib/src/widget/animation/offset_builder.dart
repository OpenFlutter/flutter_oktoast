import 'package:flutter/material.dart';

import 'animation_builder.dart';

class OffsetAnimationBuilder extends BaseAnimationBuilder {
  const OffsetAnimationBuilder({
    this.maxOffsetX = 0,
    this.maxOffsetY = 100,
  });

  final double maxOffsetX;
  final double maxOffsetY;

  @override
  Widget buildWidget(
    BuildContext context,
    Widget child,
    AnimationController controller,
    double percent,
  ) {
    return Transform.translate(
      offset: Offset(maxOffsetX * percent, maxOffsetY * (1 - percent)),
      child: child,
    );
//    return FractionalTranslation(
//      translation: Offset(0, -1 * percent),
//      child: child,
//    );
  }
}
