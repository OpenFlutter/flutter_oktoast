//
// [Author] Alex (https://github.com/AlexV525)
// [Date] 2021/11/5 15:53
//
import 'package:flutter/material.dart' hide Overlay, OverlayEntry, OverlayState;
import 'package:flutter_test/flutter_test.dart';
import 'package:oktoast/src/core/position.dart';
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

  testWidgets('Offset test when movingOnWindowChange is true',
      (WidgetTester tester) async {
    const double verticalOffset = 400.0;

    await _pumpWidget(
      tester,
      onPressed: () {
        showToast(
          'Test toast',
          position: const ToastPosition(offset: verticalOffset),
        );
      },
    );

    await tester.tap(find.byKey(_wButtonKey));
    await tester.pumpAndSettle();
    final AnimatedPadding widget = tester.firstWidget(
      find.byType(AnimatedPadding),
    ) as AnimatedPadding;
    final findMediaQuery = find.ancestor(
      of: find.byType(AnimatedPadding),
      matching: find.byType(MediaQuery),
    );
    final MediaQueryData mediaQueryData;
    if (tester.any(findMediaQuery)) {
      mediaQueryData = tester.widget<MediaQuery>(findMediaQuery).data;
    } else {
      // ignore: deprecated_member_use
      mediaQueryData = MediaQueryData.fromWindow(
        // ignore: deprecated_member_use
        TestWidgetsFlutterBinding.instance.window,
      );
    }
    final windowInsets = EdgeInsets.only(
      bottom: mediaQueryData.viewInsets.bottom,
    );
    expect(
      const EdgeInsets.only(top: verticalOffset) + windowInsets,
      widget.padding,
    );
    await tester.pumpAndSettle(_defaultDuration);
    expect(find.byType(ToastContainer), findsNothing);
  });

  testWidgets('Offset test when movingOnWindowChange is false',
      (WidgetTester tester) async {
    const double verticalOffset = 400.0;

    await _pumpWidget(
      tester,
      movingOnWindowChange: false,
      onPressed: () {
        showToast(
          'Test toast',
          position: const ToastPosition(offset: verticalOffset),
        );
      },
    );

    await tester.tap(find.byKey(_wButtonKey));
    await tester.pumpAndSettle();
    final AnimatedPadding widget =
        tester.firstWidget(find.byType(AnimatedPadding)) as AnimatedPadding;
    expect(const EdgeInsets.only(top: verticalOffset), widget.padding);
    await tester.pumpAndSettle(_defaultDuration);
    expect(find.byType(ToastContainer), findsNothing);
  });
}

const Duration _defaultDuration = Duration(milliseconds: 2300);
const Duration _defaultAnimDuration = Duration(milliseconds: 250);

const String _wTitle = 'OKToast test app';
final GlobalKey _wButtonKey = GlobalKey();

Future<void> _pumpWidget(
  WidgetTester tester, {
  bool movingOnWindowChange = true,
  VoidCallback? onPressed,
}) async {
  await tester.pumpWidget(
    OKToast(
      movingOnWindowChange: movingOnWindowChange,
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
