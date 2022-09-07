# Change log

## 3.3.0

- Abstract `BuildContextPredicate`. (#95)
- More text fields for `showToast`. (#96)

## 3.2.0

Migrate to Flutter 3, drop supports for previous Flutter versions.

- Remove deprecated `Miui10AnimBuilder`.

## 3.1.5

- `_ToastContainer` -> `ToastContainer`.
- Add tests.

## 3.1.4

- Fix dismiss is invalid when called synchronously. (#88)
- Deprecated inner `Miui10AnimBuilder`.

## 3.1.3+1

- Quick fix for the `_throwIfNoContext`.

## 3.1.3

- Throw a more precise error if the `OKToast` widget is not wrapped correctly.
- Bind `ToastFuture` with `OverlayEntry` mounted state.

## 3.1.2

- Deliver overlay insertion into microtask.

## 3.1.1

- Expose `constraints` and `margin` for `showToast` method. (#84)

## 3.1.0

- Support `copyWith` for `ToastPosition`. (#82)
- Integrate `animationBuilder` properly. (#81)
- **BREAKING CHANGE**: `handleTouth` -> `handleTouch`.
- Code cleanup.

## 3.0.0

- Null safety version.

## 2.3.2

- Fixed a memory leak issue.

## 2.3.1+1

- Fix health for pub.

## 2.3.1

- Fix [#46](https://github.com/OpenFlutter/flutter_oktoast/issues/46).

## 2.3.0

New feature:

- Add animation for show/hide the oktoast.

## 2.2.1

Fix:

- `textAlign` of method `showToast`.

## 2.2.0

New feature:

- handleTouch: Caller can use this property to respond to click events.

Change:

- This is a **breaking change** : The default value of dismissOtherToast of showToast is changed to better match the OKToast overall settings. .

## 2.1.9

Fix:

- `position` is not valid in `showToastWidget`.

## 2.1.8

Add param `showAnim` param for dismiss method:

- dismissAllToast
- ToastManager.dismissAll
- ToastFuture.dismiss

## 2.1.7

Add for `OKToast`:

- textAlign
- textPadding

Add for `showToast`:

- textAlign

## 2.1.6

add textPadding for showToast method.

## 2.1.5

fix `ToastPosition` offset params

## 2.1.4

add textDirection params

## 2.1.3

When ui.window's size changes, toast is moved.

## 2.1.2

Now, `OKToast` add a params `dismissOtherOnShow` to dismiss other toast.

## 2.1.1

use manager to manage ToastFuture

add a method `dismissAllToast` to dismiss all toast.

add a param with showToast to dismiss other toast.

## 2.1.0

add new params to helper user listen toast dismiss

showToast and showToastWidget will return `ToastFuture` the toastFuture call `dismiss()` to dismiss toast.

## 2.0.1

oktoast support page level.

you can use oktoast wrap your Scaffold.

## 2.0.0

use BuildContext cache. then `showToast` not need context, you can use the `showToast` in anywhere.

## 1.0.4

support flutter sdk 0.10 ,fix bug

## 1.0.3

update the textAlign : TextAlign.center  
update the overflow: TextOverflow.ellipsis,

## 1.0.2

fix `defaultPosition` is invalid.

## [1.0.1+2]

update readme

## [1.0.1+1]

update readme

## [1.0.1] rename library name

now libray is oktoast

## [1.0.0] first release version

stable version

## [0.0.3] add the toast position

the toast can set position

1. showToast
2. defaultPosition

## [0.0.2] - add toast style

add the textStyle
radius
backgroundColor

## [0.0.1] - first version

init commit
