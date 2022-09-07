part of '../core/toast.dart';

class ToastTheme extends InheritedWidget {
  const ToastTheme({
    super.key,
    required this.textStyle,
    required this.textDirection,
    required this.handleTouch,
    required this.radius,
    required this.position,
    required super.child,
    this.backgroundColor = Colors.black,
    this.dismissOtherOnShow = true,
    this.movingOnWindowChange = true,
    this.animationBuilder = _defaultBuildAnimation,
    this.animationDuration = _defaultAnimDuration,
    this.animationCurve = Curves.easeIn,
    this.duration = _defaultDuration,
    this.textPadding,
    this.textAlign,
    this.textMaxLines,
    this.textOverflow,
  });

  static ToastTheme of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ToastTheme>() ?? defaultTheme;

  final TextStyle textStyle;
  final TextDirection textDirection;
  final bool handleTouch;
  final double radius;
  final ToastPosition position;
  final Color backgroundColor;
  final bool dismissOtherOnShow;
  final bool movingOnWindowChange;
  final OKToastAnimationBuilder animationBuilder;
  final Duration animationDuration;
  final Curve animationCurve;
  final Duration duration;
  final TextAlign? textAlign;
  final EdgeInsets? textPadding;
  final int? textMaxLines;
  final TextOverflow? textOverflow;

  @override
  bool updateShouldNotify(ToastTheme oldWidget) => true;
}
