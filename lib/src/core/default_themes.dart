part of 'toast.dart';

Widget _defaultBuildAnimation(
  BuildContext context,
  Widget child,
  AnimationController controller,
  double percent,
) {
  return Opacity(opacity: percent, child: child);
}

const Duration _defaultDuration = Duration(milliseconds: 2300);
const Duration _defaultAnimDuration = Duration(milliseconds: 250);
const Color _defaultBackgroundColor = Color(0xDD000000);

const TextStyle _defaultTextStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.normal,
  color: Colors.white,
);
const ToastTheme defaultTheme = ToastTheme(
  radius: 10,
  textStyle: _defaultTextStyle,
  position: ToastPosition.center,
  textDirection: TextDirection.ltr,
  handleTouch: false,
  child: SizedBox(),
);
