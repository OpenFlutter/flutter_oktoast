part of oktoast;

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
