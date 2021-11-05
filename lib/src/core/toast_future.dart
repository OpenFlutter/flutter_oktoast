part of 'toast.dart';

/// Use the [dismiss] to dismiss toast.
class ToastFuture {
  ToastFuture._(
    this._entry,
    this._onDismiss,
    this._containerKey,
    this.animationDuration,
  ) {
    _entry.addListener(_mountedListener);
  }

  final OverlayEntry _entry;
  final VoidCallback? _onDismiss;
  final GlobalKey<_ToastContainerState> _containerKey;
  final Duration animationDuration;

  Timer? timer;
  bool _isShow = false;
  bool _dismissed = false;
  bool _isEntryInserted = false;

  bool get mounted => _isShow;

  bool get dismissed => _dismissed;

  void _mountedListener() {
    _isShow = _entry.mounted;
  }

  void _insertEntry(BuildContext context) {
    final OverlayState? state = Overlay.of(context);
    _isEntryInserted = state != null;
    state?.insert(_entry);
  }

  void _removeEntry() {
    _entry.removeListener(_mountedListener);
    if (_isEntryInserted) {
      _entry.remove();
    }
  }

  void dismiss({bool showAnim = false}) {
    if (!_isShow) {
      ToastManager().removeFuture(this);
      timer?.cancel();
      _dismissed = true;
      _removeEntry();
      return;
    }

    _isShow = false;
    _onDismiss?.call();
    ToastManager().removeFuture(this);

    if (showAnim) {
      _containerKey.currentState?.showDismissAnim();
      Future<void>.delayed(animationDuration, _removeEntry);
    } else {
      _removeEntry();
    }

    timer?.cancel();
    _dismissed = true;
  }
}
