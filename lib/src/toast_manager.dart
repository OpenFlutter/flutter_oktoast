import 'toast.dart';

class ToastManager {
  ToastManager._();

  static ToastManager _instance;

  factory ToastManager() {
    _instance ??= ToastManager._();
    return _instance;
  }

  Set<ToastFuture> toastSet = Set();

  void dismissAll() {
    toastSet.toList().forEach((v) {
      v.dismiss();
    });
  }

  void removeFuture(ToastFuture future) {
    toastSet.remove(future);
  }

  void addFuture(ToastFuture future) {
    toastSet.add(future);
  }
}

/// use the method to dismiss all toast.
void dismissAllToast() {
  ToastManager().dismissAll();
}
