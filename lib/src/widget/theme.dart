part of '../core/toast.dart';

class _ToastTheme extends InheritedWidget {
  final TextStyle textStyle;

  final Color backgroundColor;

  final double radius;

  final ToastPosition position;

  final bool dismissOtherOnShow;

  final bool movingOnWindowChange;

  final TextDirection textDirection;

  final EdgeInsets textPadding;

  final TextAlign textAlign;

  final bool handleTouch;

  final OKToastAnimationBuilder animationBuilder;

  final Duration animationDuration;

  final Curve animationCurve;

  final Duration duration;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  const _ToastTheme({
    this.textStyle,
    this.backgroundColor,
    this.radius,
    this.position,
    this.dismissOtherOnShow,
    this.movingOnWindowChange,
    this.textPadding,
    this.textAlign,
    TextDirection textDirection,
    this.handleTouch,
    Widget child,
    this.animationBuilder,
    this.animationDuration,
    this.animationCurve,
    this.duration,
  })  : textDirection = textDirection ?? TextDirection.ltr,
        super(child: child);

  static _ToastTheme of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ToastTheme>();
}
