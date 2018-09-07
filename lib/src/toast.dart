library oktoast;

import 'dart:async';
import 'package:flutter/material.dart';

class OKToast extends StatefulWidget {
  final Widget child;
  final TextStyle textStyle;
  final Color backgroundColor;
  final double radius;
  final ToastPosition defaultPosition;
  const OKToast({Key key, this.child, this.textStyle, this.radius, this.backgroundColor, this.defaultPosition}) : super(key: key);

  @override
  ToastWidgetState createState() {
    return new ToastWidgetState();
  }
}

class ToastWidgetState extends State<OKToast> {
  ToastController controller = ToastController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      builder: (ctx, w) => Stack(
            children: <Widget>[
              ToastProvider(
                child: widget.child,
                controller: controller,
              ),
              _ToastTheme(
                child: IgnorePointer(
                  child: _Toast(controller: controller),
                ),
                backgroundColor: widget.backgroundColor ?? Colors.grey,
                radius: widget.radius ?? 15.0,
                textStyle: widget.textStyle ?? const TextStyle(color: Colors.white, fontSize: 14.0),
                position: widget.defaultPosition ?? ToastPosition.center,
              ),
            ],
          ),
      color: Colors.white,
    );
  }
}

class ToastController {
  ValueChange valueChange;

  void dispose() {
    valueChange = null;
  }
}

typedef void ValueChange(String msg, {int second, ToastPosition position});

class _Toast extends StatefulWidget {
  final ToastController controller;

  const _Toast({Key key, this.controller}) : super(key: key);

  @override
  __ToastState createState() => __ToastState();
}

class __ToastState extends State<_Toast> with SingleTickerProviderStateMixin {
  String _text = "123";

  double _opacity = 0.0;

  Timer timer;

  ToastPosition position;

  @override
  void initState() {
    super.initState();
    widget.controller?.valueChange = _onChange;
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = _ToastTheme.of(context);
    var radius = theme.radius ?? 15.0;
    ToastPosition position = this.position ?? theme.position;
    return AnimatedOpacity(
      child: Container(
        alignment: position.align,
        padding: EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: position.offset.abs(),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(radius),
          color: theme.backgroundColor,
          textStyle: theme.textStyle,
          child: Padding(
            child: Text(
              _text,
              maxLines: 4,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            padding: EdgeInsets.all(10.0),
          ),
        ),
      ),
      opacity: _opacity,
      duration: Duration(milliseconds: 300),
    );
  }

  void _onChange(String msg, {int second, ToastPosition position}) async {
    position ??= _ToastTheme.of(context).position;

    setState(() {
      _opacity = 0.8;
      this._text = msg;
      this.position = position;
    });

    timer?.cancel();
    timer = Timer(Duration(seconds: second), () {
      timer = null;
      setState(() {
        _opacity = 0.0;
      });
    });
  }
}

class ToastProvider extends InheritedWidget {
  final Widget child;
  final ToastController controller;

  ToastProvider({this.child, this.controller}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static ToastProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ToastProvider);
  }

  static void toast(BuildContext context, String msg, {int second = 2, ToastPosition position}) {
    of(context).controller?.valueChange(msg, second: second, position: position);
  }
}

class _ToastTheme extends InheritedWidget {
  final TextStyle textStyle;
  final Color backgroundColor;
  final double radius;
  final Widget child;

  final ToastPosition position;

  _ToastTheme({this.child, this.textStyle, this.backgroundColor, this.radius, this.position}) : super(child: child);

  static _ToastTheme of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(_ToastTheme);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

showToast(BuildContext context, Object msg, {int second = 2, ToastPosition position}) {
  String m = msg?.toString() ?? "null";
  ToastProvider.toast(context, m, second: second, position: position);
}

class ToastPosition {
  final AlignmentGeometry align;
  final double offset;

  const ToastPosition({this.align = Alignment.center, this.offset = 0.0});

  static const center = const ToastPosition();

  static const bottom = const ToastPosition(align: Alignment.bottomCenter, offset: -30.0);

  static const top = const ToastPosition(align: Alignment.topCenter, offset: 75.0);
}
