# oktoast

[![pub package](https://img.shields.io/pub/v/oktoast.svg)](https://pub.dartlang.org/packages/oktoast)
![GitHub](https://img.shields.io/github/license/OpenFlutter/flutter_oktoast.svg)
[![GitHub stars](https://img.shields.io/github/stars/OpenFlutter/flutter_oktoast.svg?style=social&label=Stars)](https://github.com/OpenFlutter/flutter_oktoast)

A library for flutter.

A pure dart toast Library.

You can completely customize the style of toast.

## screenshot

default
![pic](https://raw.githubusercontent.com/CccFans/images/master/img/20181207161700.png)

custom position and widget
![pic](https://raw.githubusercontent.com/CccFans/images/master/img/20181207161742.png)

gif:

![pic](https://raw.githubusercontent.com/CaiJingLong/some_asset/master/ktoast2.gif)

## about version 1.X.X

if you use oktoast 1.X.X ,Please use the 1.X branch, and read version readme.

Proposed migration to 2.X.X version. The new version does not require buildContext.

And you can completely customize the style of toast, because now you can use `showToastWidget`.

## use

1. add library to your pubspec.yaml

```yaml
dependencies:
  oktoast: ^2.1.5
```

2. import library in dart file

```dart
import 'package:oktoast/oktoast.dart';
```

3. wrap your app widget

```dart
OKToast(
  /// set toast style, optional
  child:MaterialApp()
);
```

4. call method `showToast`

```dart
showToast("content");

// position and second have default value, is optional

showToastWidget(Text('hello oktoast'));
```

```dart

```

## properties

oktoast have default style, and you also can custom textStyle.

```properties
textStyle: the toast text style
radius: the toast background color radius
backgroundColor: the background color
position: the toast align and padding
child: the application
onDismiss: on toast dismiss will be called.
dismissOtherOnShow: If true, other toasts will be dismissed. Default false.
movingOnWindowChange: If true, when the size changes, toast is moved. Default true.
textDirection: TextDirection.ltr or TextDirection.rtl.
```

about return type:  
`showToast` and `showToastWidget` change return type from `void` to `ToastFuture` in version 2.1.0  
The `ToastFuture` can be use to dismiss the toast.

## examples

```dart
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart'; // 1. import library

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      //2. wrap your app with OKToast
      textStyle: TextStyle(fontSize: 19.0, color: Colors.white),
      backgroundColor: Colors.grey,
      radius: 10.0,
      child: new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    _counter++;

    // 3.1 use showToast method
    showToast(
      "$_counter",
      duration: Duration(seconds: 2),
      position: ToastPosition.bottom,
      backgroundColor: Colors.black.withOpacity(0.8),
      radius: 13.0,
      textStyle: TextStyle(fontSize: 18.0),
    );

    showToast(
      "$_counter",
      duration: Duration(seconds: 2),
      position: ToastPosition.top,
      backgroundColor: Colors.black.withOpacity(0.8),
      radius: 3.0,
      textStyle: TextStyle(fontSize: 30.0),
    );

    // 3.2 use showToastWidget method to custom widget
    Widget widget = Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          width: 40.0,
          height: 40.0,
           color: Colors.grey.withOpacity(0.3),
          child: Icon(
            Icons.add,
            size: 30.0,
            color: Colors.green,
          ),
        ),
      ),
    );

    ToastFuture toastFuture = showToastWidget(
      widget,
      duration: Duration(seconds: 3),
      onDismiss: () {
        print("the toast dismiss"); // the method will be called on toast dismiss.
      },
    );

    // can use future
    Future.delayed(Duration(seconds: 1), () {
      toastFuture.dismiss(); // dismiss
    });

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("ktoast demo"),
      ),
      body: Stack(
        children: <Widget>[
          new Center(
            child: ListView(
              children: <Widget>[
                new Text(
                  'You have pushed the button this many times:',
                ),
                new Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.display1,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => MyHomePage()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: _incrementCounter,
                    child: Text('toast'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


```

---

Since version `2.1.1`, you can use `dismissAllToast()` to dismiss all toast.
