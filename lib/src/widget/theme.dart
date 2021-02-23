part of '../core/toast.dart';

class _ToastTheme extends InheritedWidget {
  final TextStyle textStyle;

  final Color backgroundColor;

  final double radius;

  final ToastPosition position;

  final bool dismissOtherOnShow;

  final bool movingOnWindowChange;

  final TextDirection textDirection;

  final EdgeInsets? textPadding;

  final TextAlign? textAlign;

  final bool handleTouch;

  final OKToastAnimationBuilder animationBuilder;

  final Duration animationDuration;

  final Curve animationCurve;

  final Duration duration;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  const _ToastTheme({
    required this.textStyle,
    this.backgroundColor = Colors.black,
    required this.radius,
    required this.position,
    this.dismissOtherOnShow = true,
    this.movingOnWindowChange = true,
    this.textPadding,
    this.textAlign,
    required this.textDirection,
    required this.handleTouch,
    required Widget child,
    this.animationBuilder = _defaultBuildAnimation,
    this.animationDuration = _defaultAnimDuration,
    this.animationCurve = Curves.easeIn,
    this.duration = _defaultDuration,
  }) : super(child: child);

  static _ToastTheme of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ToastTheme>() ?? defaultTheme;
}
