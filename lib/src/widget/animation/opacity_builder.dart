import 'package:flutter/widgets.dart';

import 'animation_builder.dart';

class OpacityAnimationBuilder extends BaseAnimationBuilder {
  OpacityAnimationBuilder();

  @override
  Widget buildWidget(BuildContext context, Widget child,
      AnimationController controller, double percent) {
    return Opacity(
      opacity: percent,
      child: child,
    );
  }
}
