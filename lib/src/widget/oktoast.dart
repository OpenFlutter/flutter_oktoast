part of '../core/toast.dart';

class OKToast extends StatefulWidget {
  final Widget child;

  final TextStyle textStyle;

  final Color backgroundColor;

  final double radius;

  final ToastPosition position;

  final TextDirection textDirection;

  final bool dismissOtherOnShow;

  final bool movingOnWindowChange;

  final EdgeInsets textPadding;

  final TextAlign textAlign;

  final bool handleTouth;

  const OKToast({
    Key key,
    @required this.child,
    this.textStyle,
    this.radius = 10.0,
    this.position = ToastPosition.center,
    this.textDirection,
    this.dismissOtherOnShow = false,
    this.movingOnWindowChange = true,
    Color backgroundColor,
    this.textPadding,
    this.textAlign,
    this.handleTouth = false,
  })  : this.backgroundColor = backgroundColor ?? const Color(0xDD000000),
        super(key: key);

  @override
  _OKToastState createState() => _OKToastState();
}

class _OKToastState extends State<OKToast> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _contextMap.remove(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var overlay = Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (ctx) {
            _contextMap[this] = ctx;
            return widget.child;
          },
        ),
      ],
    );

    TextDirection direction = widget.textDirection ?? TextDirection.ltr;

    Widget w = Directionality(
      child: Stack(children: <Widget>[
        overlay,
        Positioned(
          left: 0.0,
          right: 0.0,
          top: 0.0,
          bottom: 0.0,
          child: IgnorePointer(
            child: Container(
              color: Colors.black.withOpacity(0.0),
            ),
          ),
        )
      ]),
      textDirection: direction,
    );

    var typography = Typography(platform: TargetPlatform.android);
    final TextTheme defaultTextTheme = typography.white;

    TextStyle textStyle = widget.textStyle ??
        defaultTextTheme.body1.copyWith(
          fontSize: 15.0,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        );

    TextAlign textAlign = widget.textAlign ?? TextAlign.center;
    EdgeInsets textPadding = widget.textPadding ??
        const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4.0,
        );

    return _ToastTheme(
      child: w,
      backgroundColor: widget.backgroundColor,
      radius: widget.radius,
      textStyle: textStyle,
      position: widget.position,
      dismissOtherOnShow: widget.dismissOtherOnShow,
      movingOnWindowChange: widget.movingOnWindowChange,
      textDirection: direction,
      textAlign: textAlign,
      textPadding: textPadding,
      handleTouch: widget.handleTouth,
    );
  }
}
