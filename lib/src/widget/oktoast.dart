part of '../core/toast.dart';

class OKToast extends StatefulWidget {
  const OKToast({
    Key? key,
    required this.child,
    this.textStyle,
    this.radius = 10.0,
    this.position = ToastPosition.center,
    this.textDirection = TextDirection.ltr,
    this.dismissOtherOnShow = false,
    this.movingOnWindowChange = true,
    Color? backgroundColor,
    this.textPadding,
    this.textAlign,
    this.handleTouth = false,
    this.animationBuilder,
    this.animationDuration = _defaultAnimDuration,
    this.animationCurve,
    this.duration,
  })  : backgroundColor = backgroundColor ?? _defaultBackgroundColor,
        super(key: key);

  /// Typically with a [WidgetsApp].
  final Widget child;

  /// Default textStyle of [showToast].
  final TextStyle? textStyle;

  /// Default backgroundColor of [showToast].
  final Color backgroundColor;

  /// Default radius of [showToast].
  final double radius;

  /// Default align and padding of [showToast].
  final ToastPosition position;

  /// Default textDirection of [showToast].
  final TextDirection textDirection;

  /// Default dismissOtherOnShow of [showToast].
  final bool dismissOtherOnShow;

  /// When the screen size changes due to the soft keyboard / rotation screen,
  /// toast will reposition.
  final bool movingOnWindowChange;

  /// TDefault textAlign of [textPadding].
  final EdgeInsets? textPadding;

  /// Default textAlign of [showToast].
  final TextAlign? textAlign;

  /// Whether toast can respond to click events.
  final bool handleTouth;

  final Duration? duration;

  /// The animation builder of show/hide toast.
  final OKToastAnimationBuilder? animationBuilder;

  /// The animation duration of show/hide toast.
  final Duration animationDuration;

  /// The animation curve of show/hide toast.
  final Curve? animationCurve;

  @override
  _OKToastState createState() => _OKToastState();
}

class _OKToastState extends State<OKToast> {
  @override
  void dispose() {
    _contextMap.remove(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Overlay overlay = Overlay(
      initialEntries: <OverlayEntry>[
        OverlayEntry(
          builder: (BuildContext ctx) {
            _contextMap[this] = ctx;
            return widget.child;
          },
        ),
      ],
    );

    final Widget w = Directionality(
      child: overlay,
      textDirection: widget.textDirection,
    );

    final Typography typography = Typography.material2018(
      platform: TargetPlatform.android,
    );
    final TextTheme defaultTextTheme = typography.white;

    final TextStyle textStyle = widget.textStyle ??
        defaultTextTheme.bodyText2?.copyWith(
          fontSize: 15.0,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ) ??
        _defaultTextStyle;

    final TextAlign textAlign = widget.textAlign ?? TextAlign.center;
    final EdgeInsets textPadding = widget.textPadding ??
        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);

    final OKToastAnimationBuilder animationBuilder =
        widget.animationBuilder ?? _defaultBuildAnimation;

    return _ToastTheme(
      child: w,
      backgroundColor: widget.backgroundColor,
      radius: widget.radius,
      textStyle: textStyle,
      position: widget.position,
      dismissOtherOnShow: widget.dismissOtherOnShow,
      movingOnWindowChange: widget.movingOnWindowChange,
      textDirection: widget.textDirection,
      textAlign: textAlign,
      textPadding: textPadding,
      handleTouch: widget.handleTouth,
      animationBuilder: animationBuilder,
      animationDuration: widget.animationDuration,
      animationCurve: widget.animationCurve ?? Curves.easeIn,
      duration: widget.duration ?? _defaultDuration,
    );
  }
}
