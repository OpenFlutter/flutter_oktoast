///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/11/5 15:53
///
import 'package:flutter/material.dart' hide Overlay, OverlayEntry, OverlayState;
import 'package:flutter_test/flutter_test.dart';
import 'package:oktoast/src/core/toast.dart';

void main() {
  testWidgets('Show toast test', (WidgetTester tester) async {
    await _pumpWidget(
      tester,
      onPressed: () {
        showToast('Test toast');
      },
    );
    await tester.tap(find.byKey(_wButtonKey));
    await tester.pumpAndSettle();
    expect(find.byType(ToastContainer), findsOneWidget);
    await tester.pumpAndSettle(_defaultAnimDuration);
    expect(find.byType(ToastContainer), findsOneWidget);
    await tester.pumpAndSettle(_defaultDuration);
    expect(find.byType(ToastContainer), findsNothing);
  });

  testWidgets('Dismiss synchronously', (WidgetTester tester) async {
    await _pumpWidget(
      tester,
      onPressed: () {
        final ToastFuture future = showToast('Test toast');
        future.dismiss();
      },
    );
    await tester.tap(find.byKey(_wButtonKey));
    expect(find.byType(ToastContainer), findsNothing);
    await tester.pumpAndSettle(_defaultAnimDuration);
    expect(find.byType(ToastContainer), findsNothing);
  });
}

const Duration _defaultDuration = Duration(milliseconds: 2300);
const Duration _defaultAnimDuration = Duration(milliseconds: 250);

const String _wTitle = 'OKToast test app';
final GlobalKey _wButtonKey = GlobalKey();

Future<void> _pumpWidget(
  WidgetTester tester, {
  VoidCallback? onPressed,
}) async {
  await tester.pumpWidget(
    OKToast(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text(_wTitle)),
          body: Center(
            child: ElevatedButton(
              key: _wButtonKey,
              onPressed: onPressed,
              child: const Text('Button'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle(const Duration(seconds: 2));
}
