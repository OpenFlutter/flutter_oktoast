part of '../core/toast.dart';

class _ToastContainer extends StatefulWidget {
  final Duration duration;
  final Widget child;
  final bool movingOnWindowChange;
  final ToastPosition position;
  final OKToastAnimationBuilder animationBuilder;
  final Duration animationDuration;

  final Curve animationCurve;

  const _ToastContainer({
    Key? key,
    required this.duration,
    required this.child,
    this.movingOnWindowChange = false,
    required this.position,
    required this.animationBuilder,
    required this.animationDuration,
    required this.animationCurve,
  }) : super(key: key);

  @override
  __ToastContainerState createState() => __ToastContainerState();
}

class __ToastContainerState extends State<_ToastContainer>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool get movingOnWindowChange => widget.movingOnWindowChange;

  double get offset => widget.position.offset;

  Duration get animationDuration => widget.animationDuration;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: animationDuration,
      reverseDuration: animationDuration,
    );

    Future.delayed(const Duration(milliseconds: 30), () {
      _animateTo(1.0);
    });

    Future.delayed(widget.duration - animationDuration, () {
      _animateTo(0.0);
    });

    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (this.mounted) setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget w = AnimatedBuilder(
      child: widget.child,
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          child: child,
          opacity: _animationController.value,
        );
      },
    );

    if (movingOnWindowChange != true) {
      return w;
    }

    var mediaQueryData = MediaQueryData.fromWindow(ui.window);
    Widget container = w;

    var edgeInsets = EdgeInsets.only(bottom: mediaQueryData.viewInsets.bottom);
    if (offset > 0) {
      var padding = EdgeInsets.only(top: offset) + edgeInsets;

      container = AnimatedPadding(
        duration: animationDuration,
        padding: padding,
        child: container,
      );
    } else if (offset < 0) {
      container = AnimatedPadding(
        duration: animationDuration,
        padding: EdgeInsets.only(bottom: offset.abs()) + edgeInsets,
        child: container,
      );
    } else {
      container = AnimatedPadding(
        duration: animationDuration,
        padding: edgeInsets,
        child: container,
      );
    }

    return container;
  }

  void showDismissAnim() {
    _animateTo(0);
  }

  void _animateTo(double value) {
    if (!mounted) {
      return;
    }
    if (value == 0) {
      _animationController.animateTo(
        value,
        duration: animationDuration,
        curve: widget.animationCurve,
      );
    } else {
      _animationController.animateBack(
        value,
        duration: animationDuration,
        curve: widget.animationCurve,
      );
    }
  }
}
