part of 'toast.dart';

const TextStyle _defaultTextStyle = const TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.normal,
  color: Colors.white,
);

const _ToastTheme defaultTheme = const _ToastTheme(
  radius: 10,
  textStyle: _defaultTextStyle,
  position: ToastPosition.center,
  textDirection: TextDirection.ltr,
  handleTouch: false,
  child: const SizedBox(),
  animationBuilder: _defaultBuildAnimation,
);

Widget _defaultBuildAnimation(BuildContext context, Widget child,
    AnimationController controller, double percent) {
  return Opacity(
    opacity: percent,
    child: child,
  );
}

const _defaultDuration = Duration(
  milliseconds: 2300,
);

const _defaultAnimDuration = const Duration(milliseconds: 250);

const _defaultBackgroundColor = const Color(0xDD000000);
