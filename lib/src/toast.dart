library oktoast;

import 'dart:async';
import 'dart:collection';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:oktoast/src/toast_manager.dart';

LinkedHashMap<_OKToastState, BuildContext> _contextMap = LinkedHashMap();
const _defaultDuration = Duration(
  milliseconds: 2300,
);

const _opacityDuration = Duration(milliseconds: 250);

class OKToast extends StatefulWidget {
  final Widget child;

  final TextStyle textStyle;

  final Color backgroundColor;

  final double radius;

  final ToastPosition position;

  final TextDirection textDirection;

  final bool dismissOtherOnShow;

  final bool movingOnWindowChange;

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

    return _ToastTheme(
      child: w,
      backgroundColor: widget.backgroundColor,
      radius: widget.radius,
      textStyle: textStyle,
      position: widget.position,
      dismissOtherOnShow: widget.dismissOtherOnShow,
      movingOnWindowChange: widget.movingOnWindowChange,
      textDirection: direction,
    );
  }
}

/// show toast with [msg],
ToastFuture showToast(
  String msg, {
  BuildContext context,
  Duration duration = _defaultDuration,
  ToastPosition position,
  TextStyle textStyle,
  Color backgroundColor,
  double radius,
  VoidCallback onDismiss,
  TextDirection textDirection,
  bool dismissOtherToast = false,
}) {
  context ??= _contextMap.values.first;

  textStyle ??= _ToastTheme.of(context).textStyle ?? TextStyle(fontSize: 15.0);
  position ??= _ToastTheme.of(context).position;
  backgroundColor ??= _ToastTheme.of(context).backgroundColor;
  radius ??= _ToastTheme.of(context).radius;

  var direction = textDirection ??
      _ToastTheme.of(context).textDirection ??
      TextDirection.ltr;

  Widget widget = Align(
    alignment: position.align,
    child: Container(
      margin: const EdgeInsets.all(50.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: ClipRect(
        child: Text(
          msg,
          style: textStyle,
        ),
      ),
    ),
  );

  return showToastWidget(
    widget,
    context: context,
    duration: duration,
    onDismiss: onDismiss,
    position: position,
    dismissOtherToast: dismissOtherToast,
    textDirection: direction,
  );
}

/// show [widget] with oktoast
ToastFuture showToastWidget(
  Widget widget, {
  BuildContext context,
  Duration duration = _defaultDuration,
  VoidCallback onDismiss,
  bool dismissOtherToast,
  TextDirection textDirection,
  ToastPosition position,
}) {
  context ??= _contextMap.values.first;
  OverlayEntry entry;
  ToastFuture future;
  position ??= _ToastTheme.of(context).position;

  var movingOnWindowChange =
      _ToastTheme.of(context)?.movingOnWindowChange ?? false;

  var direction = textDirection ??
      _ToastTheme.of(context).textDirection ??
      TextDirection.ltr;

  entry = OverlayEntry(builder: (ctx) {
    return IgnorePointer(
      child: _ToastContainer(
        duration: duration,
        position: position,
        movingOnWindowChange: movingOnWindowChange,
        child: Directionality(
          textDirection: direction,
          child: widget,
        ),
      ),
    );
  });

  dismissOtherToast ??= _ToastTheme.of(context).dismissOtherOnShow ?? false;

  if (dismissOtherToast == true) {
    ToastManager().dismissAll();
  }

  future = ToastFuture._(entry, onDismiss);

  Future.delayed(duration, () {
    future.dismiss();
  });

  Overlay.of(context).insert(entry);
  ToastManager().addFuture(future);

  return future;
}

class _ToastContainer extends StatefulWidget {
  final Duration duration;
  final Widget child;
  final bool movingOnWindowChange;
  final ToastPosition position;

  const _ToastContainer({
    Key key,
    this.duration,
    this.child,
    this.movingOnWindowChange = false,
    this.position,
  }) : super(key: key);

  @override
  __ToastContainerState createState() => __ToastContainerState();
}

class __ToastContainerState extends State<_ToastContainer>
    with WidgetsBindingObserver {
  double opacity = 0.0;

  bool get movingOnWindowChange => widget.movingOnWindowChange;

  double get offset => widget.position.offset;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 30), () {
      if (!mounted) {
        return;
      }
      setState(() {
        opacity = 1.0;
      });
    });

    Future.delayed(widget.duration - _opacityDuration, () {
      if (!mounted) {
        return;
      }
      setState(() {
        opacity = 0.0;
      });
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (this.mounted) setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget w = AnimatedOpacity(
      duration: _opacityDuration,
      child: widget.child,
      opacity: opacity,
    );

    if (movingOnWindowChange != true) {
      return w;
    }

    var mediaQueryData = MediaQueryData.fromWindow(ui.window);
    Widget container = AnimatedContainer(
      padding: EdgeInsets.only(bottom: mediaQueryData.viewInsets.bottom),
      duration: _opacityDuration,
      child: w,
    );

    if (offset > 0) {
      container = Padding(
        padding: EdgeInsets.only(top: offset),
        child: container,
      );
    } else if (offset < 0) {
      container = Padding(
        padding: EdgeInsets.only(bottom: offset.abs()),
        child: container,
      );
    }

    return container;
  }
}

class ToastPosition {
  final AlignmentGeometry align;
  final double offset;

  const ToastPosition({this.align = Alignment.center, this.offset = 0.0});

  static const center =
      const ToastPosition(align: Alignment.center, offset: 0.0);

  static const bottom =
      const ToastPosition(align: Alignment.bottomCenter, offset: -30.0);

  static const top =
      const ToastPosition(align: Alignment.topCenter, offset: 75.0);
}

class _ToastTheme extends InheritedWidget {
  final TextStyle textStyle;

  final Color backgroundColor;

  final double radius;

  final ToastPosition position;

  final bool dismissOtherOnShow;

  final bool movingOnWindowChange;

  final TextDirection textDirection;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  const _ToastTheme({
    this.textStyle,
    this.backgroundColor,
    this.radius,
    this.position,
    this.dismissOtherOnShow,
    this.movingOnWindowChange,
    TextDirection textDirection,
    Widget child,
  })  : textDirection = textDirection ?? TextDirection.ltr,
        super(child: child);

  static _ToastTheme of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(_ToastTheme);
}

/// use the [dismiss] to dismiss toast.
class ToastFuture {
  final OverlayEntry _entry;
  final VoidCallback _onDismiss;

  bool _isShow = true;

  ToastFuture._(this._entry, this._onDismiss);

  void dismiss() {
    if (!_isShow) {
      return;
    }
    _isShow = false;
    _entry.remove();
    _onDismiss?.call();
    ToastManager().removeFuture(this);
  }
}
