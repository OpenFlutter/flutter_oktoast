import 'toast.dart';

class ToastManager {
  factory ToastManager() => _instance;

  ToastManager._();

  static late final ToastManager _instance = ToastManager._();

  final Set<ToastFuture> toastSet = <ToastFuture>{};

  void dismissAll({bool showAnim = false}) {
    toastSet.toList().forEach((ToastFuture v) {
      v.dismiss(showAnim: showAnim);
    });
  }

  void removeFuture(ToastFuture future) {
    toastSet.remove(future);
  }

  void addFuture(ToastFuture future) {
    toastSet.add(future);
  }
}
