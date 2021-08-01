part of '../core/toast.dart';

class _ToastTheme extends InheritedWidget {
  const _ToastTheme({
    required this.textStyle,
    required this.textDirection,
    required this.handleTouch,
    required this.radius,
    required this.position,
    required Widget child,
    this.backgroundColor = Colors.black,
    this.dismissOtherOnShow = true,
    this.movingOnWindowChange = true,
    this.animationBuilder = _defaultBuildAnimation,
    this.animationDuration = _defaultAnimDuration,
    this.animationCurve = Curves.easeIn,
    this.duration = _defaultDuration,
    this.textPadding,
    this.textAlign,
  }) : super(child: child);

  static _ToastTheme of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ToastTheme>() ?? defaultTheme;

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
}
