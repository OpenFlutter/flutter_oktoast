part of 'toast.dart';

/// Use the [dismiss] to dismiss toast.
class ToastFuture {
  ToastFuture._(
    this._entry,
    this._onDismiss,
    this._containerKey,
    this.animationDuration,
  );

  final OverlayEntry _entry;
  final VoidCallback? _onDismiss;
  final GlobalKey<__ToastContainerState> _containerKey;
  final Duration animationDuration;

  Timer? timer;
  bool _isShow = true;

  void dismiss({bool showAnim = false}) {
    if (!_isShow) {
      return;
    }
    _isShow = false;
    _onDismiss?.call();
    ToastManager().removeFuture(this);

    if (showAnim) {
      _containerKey.currentState?.showDismissAnim();
      Future<void>.delayed(animationDuration, _entry.remove);
    } else {
      _entry.remove();
    }

    timer?.cancel();
  }
}
