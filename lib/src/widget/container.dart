part of '../core/toast.dart';

class ToastContainer extends StatefulWidget {
  const ToastContainer({
    super.key,
    required this.duration,
    required this.child,
    required this.position,
    required this.animationBuilder,
    required this.animationDuration,
    required this.animationCurve,
    this.movingOnWindowChange = false,
  });

  final Duration duration;
  final Widget child;
  final bool movingOnWindowChange;
  final ToastPosition position;
  final OKToastAnimationBuilder animationBuilder;
  final Duration animationDuration;

  final Curve animationCurve;

  @override
  State<ToastContainer> createState() => _ToastContainerState();
}

class _ToastContainerState extends State<ToastContainer>
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
    WidgetsBinding.instance.addObserver(this);

    Future<void>.delayed(const Duration(milliseconds: 30), () {
      _animateTo(1.0);
    });
    if (widget.duration != Duration.zero) {
      Future<void>.delayed(widget.duration - animationDuration, () {
        _animateTo(0.0);
      });
    }
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
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget w = AnimatedBuilder(
      animation: _animationController,
      builder: (_, Widget? child) => widget.animationBuilder(
        context,
        child!,
        _animationController,
        _animationController.value,
      ),
      child: widget.child,
    );

    final EdgeInsets offsetPadding;
    if (offset > 0) {
      offsetPadding = EdgeInsets.only(top: offset);
    } else {
      offsetPadding = EdgeInsets.only(bottom: offset.abs());
    }

    final EdgeInsets windowInsets;
    if (movingOnWindowChange) {
      // ignore: deprecated_member_use
      final mediaQuery = MediaQueryData.fromWindow(ui.window);
      // final mediaQuery = MediaQueryData.fromView(currentView);
      windowInsets = EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom);
    } else {
      windowInsets = EdgeInsets.zero;
    }

    return AnimatedPadding(
      padding: offsetPadding + windowInsets,
      duration: animationDuration,
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
