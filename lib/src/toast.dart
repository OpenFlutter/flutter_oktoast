library ktoast;

import 'dart:async';

import 'package:flutter/material.dart';

class KToast extends StatefulWidget {
  final Widget child;

  const KToast({Key key, this.child}) : super(key: key);

  @override
  ToastWidgetState createState() {
    return new ToastWidgetState();
  }
}

class ToastWidgetState extends State<KToast> {
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
              IgnorePointer(
                child: _Toast(controller: controller),
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

typedef void ValueChange(String msg, {int second});

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
    return AnimatedOpacity(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(30.0),
        child: Material(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.grey,
          textStyle: TextStyle(color: Colors.white),
          child: Padding(
            child: Text(
              _text,
              maxLines: 4,
            ),
            padding: EdgeInsets.all(10.0),
          ),
        ),
      ),
      opacity: _opacity,
      duration: Duration(milliseconds: 300),
    );
  }

  void _onChange(String msg, {int second}) async {
    setState(() {
      _opacity = 0.8;
      this._text = msg;
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
  ToastProvider({this.child, this.controller});

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static ToastProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ToastProvider);
  }

  static void toast(BuildContext context, String msg, {int second = 2}) {
    of(context).controller?.valueChange(msg, second: second);
  }
}

showToast(BuildContext context, Object msg, {int second = 2}) {
  String m = msg?.toString() ?? "null";
  ToastProvider.toast(context, m, second: second);
}
