library oktoast;

import 'dart:async';
import 'dart:collection';
import 'dart:ui' as ui;

import 'package:flutter/material.dart' hide Overlay, OverlayEntry, OverlayState;

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

typedef BuildContextPredicate = BuildContext Function(
  Iterable<BuildContext> list,
);

BuildContext _defaultContextPredicate(Iterable<BuildContext> list) {
  return list.first;
}

/// Show toast with [msg],
ToastFuture showToast(
  String msg, {
  BuildContext? context,
  BuildContextPredicate buildContextPredicate = _defaultContextPredicate,
  Duration? duration,
  ToastPosition? position,
  Color? backgroundColor,
  double? radius,
  VoidCallback? onDismiss,
  bool? dismissOtherToast,
  OKToastAnimationBuilder? animationBuilder,
  Duration? animationDuration,
  Curve? animationCurve,
  BoxConstraints? constraints,
  EdgeInsetsGeometry? margin = const EdgeInsets.all(50),
  TextDirection? textDirection,
  EdgeInsetsGeometry? textPadding,
  TextAlign? textAlign,
  TextStyle? textStyle,
  int? textMaxLines,
  TextOverflow? textOverflow,
}) {
  if (context == null) {
    _throwIfNoContext(_contextMap.values, 'showToast');
  }
  context ??= buildContextPredicate(_contextMap.values);

  final ToastTheme theme = ToastTheme.of(context);
  position ??= theme.position;
  backgroundColor ??= theme.backgroundColor;
  radius ??= theme.radius;
  textDirection ??= theme.textDirection;
  textPadding ??= theme.textPadding;
  textAlign ??= theme.textAlign;
  textStyle ??= theme.textStyle;
  textMaxLines ??= theme.textMaxLines;
  textOverflow ??= theme.textOverflow;

  final Widget widget = Container(
    constraints: constraints,
    margin: margin,
    padding: textPadding,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: backgroundColor,
    ),
    child: ClipRect(
      child: Text(
        msg,
        style: textStyle,
        textAlign: textAlign,
        maxLines: textMaxLines,
        overflow: textOverflow,
      ),
    ),
  );

  return showToastWidget(
    widget,
    context: context,
    buildContextPredicate: buildContextPredicate,
    duration: duration,
    onDismiss: onDismiss,
    position: position,
    dismissOtherToast: dismissOtherToast,
    textDirection: textDirection,
    animationBuilder: animationBuilder,
    animationDuration: animationDuration,
    animationCurve: animationCurve,
  );
}

/// Show a [widget] and returns a [ToastFuture].
ToastFuture showToastWidget(
  Widget widget, {
  BuildContext? context,
  BuildContextPredicate buildContextPredicate = _defaultContextPredicate,
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
  context ??= buildContextPredicate(_contextMap.values);

  final ToastTheme theme = ToastTheme.of(context);
  position ??= theme.position;
  handleTouch ??= theme.handleTouch;
  animationBuilder ??= theme.animationBuilder;
  animationDuration ??= theme.animationDuration;
  animationCurve ??= theme.animationCurve;
  duration ??= theme.duration;

  final bool movingOnWindowChange = theme.movingOnWindowChange;

  final TextDirection direction = textDirection ?? theme.textDirection;

  final GlobalKey<_ToastContainerState> key = GlobalKey();

  widget = Align(alignment: position.align, child: widget);

  final OverlayEntry entry = OverlayEntry(
    builder: (BuildContext ctx) {
      return IgnorePointer(
        ignoring: !handleTouch!,
        child: Directionality(
          textDirection: direction,
          child: ToastContainer(
            key: key,
            duration: duration!,
            position: position!,
            movingOnWindowChange: movingOnWindowChange,
            animationBuilder: animationBuilder!,
            animationDuration: animationDuration!,
            animationCurve: animationCurve!,
            child: widget,
          ),
        ),
      );
    },
  );

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

  void insertOverlayEntry() {
    if (!future.dismissed) {
      future._insertEntry(context!);
    }
  }

  if (!context.debugDoingBuild && context.owner?.debugBuilding != true) {
    insertOverlayEntry();
  } else {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      insertOverlayEntry();
    });
  }

  return future;
}

void dismissAllToast({bool showAnim = false}) {
  ToastManager().dismissAll(showAnim: showAnim);
}

void _throwIfNoContext(Iterable<BuildContext> contexts, String methodName) {
  if (contexts.isNotEmpty) {
    return;
  }
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
