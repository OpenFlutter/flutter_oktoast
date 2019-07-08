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
  })  : textDirection = textDirection ?? TextDirection.ltr,
        super(child: child);

  static _ToastTheme of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(_ToastTheme);
}
