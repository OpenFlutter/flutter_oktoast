part of 'toast.dart';

/// use the [dismiss] to dismiss toast.
class ToastFuture {
  final OverlayEntry _entry;
  final VoidCallback _onDismiss;
  bool _isShow = true;
  Timer timer;
  final GlobalKey<__ToastContainerState> _containerKey;
  final Duration animationDuration;

  ToastFuture._(
    this._entry,
    this._onDismiss,
    this._containerKey,
    this.animationDuration,
  );

  void dismiss({bool showAnim = false}) {
    if (!_isShow) {
      return;
    }
    _isShow = false;
    _onDismiss?.call();
    ToastManager().removeFuture(this);

    if (showAnim) {
      _containerKey.currentState.showDismissAnim();
      Future.delayed(animationDuration, () {
        _entry.remove();
      });
    } else {
      _entry.remove();
    }

    timer?.cancel();
    timer = null;
  }
}
