part of '../core/toast.dart';

class _ToastContainer extends StatefulWidget {
  const _ToastContainer({
    Key? key,
    required this.duration,
    required this.child,
    required this.position,
    required this.animationBuilder,
    required this.animationDuration,
    required this.animationCurve,
    this.movingOnWindowChange = false,
  }) : super(key: key);

  final Duration duration;
  final Widget child;
  final bool movingOnWindowChange;
  final ToastPosition position;
  final OKToastAnimationBuilder animationBuilder;
  final Duration animationDuration;

  final Curve animationCurve;

  @override
  __ToastContainerState createState() => __ToastContainerState();
}

class __ToastContainerState extends State<_ToastContainer>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool get movingOnWindowChange => widget.movingOnWindowChange;

  double get offset => widget.position.offset;

  Duration get animationDuration => widget.animationDuration;

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: animationDuration,
    reverseDuration: animationDuration,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    Future<void>.delayed(const Duration(milliseconds: 30), () {
      _animateTo(1.0);
    });
    Future<void>.delayed(widget.duration - animationDuration, () {
      _animateTo(0.0);
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget w = AnimatedBuilder(
      child: widget.child,
      animation: _animationController,
      builder: (_, Widget? child) => widget.animationBuilder(
        context,
        Opacity(
          child: widget.child,
          opacity: _animationController.value,
        ),
        _animationController,
        _animationController.value,
      ),
    );

    if (movingOnWindowChange != true) {
      return w;
    }

    final EdgeInsets edgeInsets = EdgeInsets.only(
      bottom: MediaQueryData.fromWindow(ui.window).viewInsets.bottom,
    );

    if (offset > 0) {
      final EdgeInsets padding = EdgeInsets.only(top: offset) + edgeInsets;
      return AnimatedPadding(
        duration: animationDuration,
        padding: padding,
        child: w,
      );
    }
    if (offset < 0) {
      return AnimatedPadding(
        duration: animationDuration,
        padding: EdgeInsets.only(bottom: offset.abs()) + edgeInsets  ,
        child: w,
      );
    }
    return AnimatedPadding(
      duration: animationDuration,
      padding: edgeInsets,
      child: w,
    );
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
