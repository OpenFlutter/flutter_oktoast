library oktoast;

import 'dart:async';
import 'dart:collection';
import 'dart:ui' as ui;

import 'package:flutter/material.dart' hide Overlay, OverlayEntry;

import '../widget/animation/animation_builder.dart';
import '../widget/overlay.dart';
import 'position.dart';
import 'toast_manager.dart';

part 'default_themes.dart';

part 'toast_future.dart';

part '../widget/theme.dart';

part '../widget/oktoast.dart';

part '../widget/container.dart';

final LinkedHashMap<_OKToastState, BuildContext> _contextMap =
    LinkedHashMap<_OKToastState, BuildContext>();

/// Show toast with [msg],
ToastFuture showToast(
  String msg, {
  BuildContext? context,
  Duration? duration,
  ToastPosition? position,
  TextStyle? textStyle,
  EdgeInsetsGeometry? textPadding,
  Color? backgroundColor,
  double? radius,
  VoidCallback? onDismiss,
  TextDirection? textDirection,
  bool? dismissOtherToast,
  TextAlign? textAlign,
  OKToastAnimationBuilder? animationBuilder,
  Duration? animationDuration,
  Curve? animationCurve,
  BoxConstraints? constraints,
  EdgeInsetsGeometry? margin = const EdgeInsets.all(50),
}) {
  if (context == null) {
    _throwIfNoContext(_contextMap.values, 'showToast');
  }
  context ??= _contextMap.values.first;

  final _ToastTheme theme = _ToastTheme.of(context);
  textStyle ??= theme.textStyle;
  textAlign ??= theme.textAlign;
  textPadding ??= theme.textPadding;
  position ??= theme.position;
  backgroundColor ??= theme.backgroundColor;
  radius ??= theme.radius;
  textDirection ??= theme.textDirection;

  final Widget widget = Container(
    constraints: constraints,
    margin: margin,
    padding: textPadding,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: backgroundColor,
    ),
    child: ClipRect(child: Text(msg, style: textStyle, textAlign: textAlign)),
  );

  return showToastWidget(
    widget,
    animationBuilder: animationBuilder,
    animationDuration: animationDuration,
    context: context,
    duration: duration,
    onDismiss: onDismiss,
    position: position,
    dismissOtherToast: dismissOtherToast,
    textDirection: textDirection,
    animationCurve: animationCurve,
  );
}

/// Show [widget] with oktoast.
ToastFuture showToastWidget(
  Widget widget, {
  BuildContext? context,
  Duration? duration,
  ToastPosition? position,
  VoidCallback? onDismiss,
  bool? dismissOtherToast,
  TextDirection? textDirection,
  bool? handleTouch,
  OKToastAnimationBuilder? animationBuilder,
  Duration? animationDuration,
  Curve? animationCurve,
}) {
  if (context == null) {
    _throwIfNoContext(_contextMap.values, 'showToastWidget');
  }
  context ??= _contextMap.values.first;
  final _ToastTheme theme = _ToastTheme.of(context);

  position ??= theme.position;
  handleTouch ??= theme.handleTouch;
  animationBuilder ??= theme.animationBuilder;
  animationDuration ??= theme.animationDuration;
  animationCurve ??= theme.animationCurve;
  duration ??= theme.duration;

  final bool movingOnWindowChange = theme.movingOnWindowChange;

  final TextDirection direction = textDirection ?? theme.textDirection;

  final GlobalKey<__ToastContainerState> key = GlobalKey();

  widget = Align(child: widget, alignment: position.align);

  final OverlayEntry entry = OverlayEntry(builder: (BuildContext ctx) {
    return IgnorePointer(
      ignoring: !handleTouch!,
      child: Directionality(
        textDirection: direction,
        child: _ToastContainer(
          key: key,
          duration: duration!,
          position: position!,
          movingOnWindowChange: movingOnWindowChange,
          child: widget,
          animationBuilder: animationBuilder!,
          animationDuration: animationDuration!,
          animationCurve: animationCurve!,
        ),
      ),
    );
  });

  dismissOtherToast ??= theme.dismissOtherOnShow;

  if (dismissOtherToast == true) {
    ToastManager().dismissAll();
  }

  final ToastFuture future = ToastFuture._(
    entry,
    onDismiss,
    key,
    animationDuration,
  );

  if (duration != Duration.zero) {
    future.timer = Timer(duration, () {
      future.dismiss();
    });
  }

  ToastManager().addFuture(future);

  void _insertOverlayEntry() {
    Overlay.of(context!)?.insert(entry);
  }

  if (!context.debugDoingBuild && context.owner?.debugBuilding != true) {
    _insertOverlayEntry();
  } else {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (!future.dismissed) {
        _insertOverlayEntry();
      }
    });
  }

  return future;
}

void dismissAllToast({bool showAnim = false}) {
  ToastManager().dismissAll(showAnim: showAnim);
}

void _throwIfNoContext(Iterable<BuildContext> contexts, String methodName) {
  final List<DiagnosticsNode> information = <DiagnosticsNode>[
    ErrorSummary('No OKToast widget found.'),
    ErrorDescription(
      '$methodName requires an OKToast widget ancestor '
      'for correct operation.',
    ),
    ErrorHint(
      'The most common way to add an OKToast to an application '
      'is to wrap a OKToast upon a WidgetsApp(MaterialApp/CupertinoApp).',
    ),
  ];
  throw FlutterError.fromParts(information);
}
