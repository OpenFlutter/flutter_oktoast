# ktoast

A library for flutter.

A pure dart toast Library.

## screenshot

![image](https://github.com/CaiJingLong/some_asset/blob/master/ktoast2.gif)

## use

1.  add library to your pubspec.yaml

```yaml
dependencies:
  ktoast: ^0.0.3
```

2.  import library in dart file

```dart
import 'package:ktoast/ktoast.dart';
```

3.  wrap your app widget

```dart
...
KToast(
  /// set toast style
  child:MaterialApp()
);
...
```

4.  call `showToast()` method

```dart
showToast(context, "$_counter", second: 2); //3. show toast
```

## properties

```properties
textStyle: the toast text style
radius: the toast background color radius
backgroundColor: the background color
position: the toast align and padding
child: the application
```

## examples

```dart
import 'package:flutter/material.dart';
import 'package:ktoast/ktoast.dart';  // 1. import library

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
@override
  Widget build(BuildContext context) {
    return KToast( //2. wrap your app with KToast
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
    showToast(context, "$_counter", second: 5); //3. show toast
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
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => MyHomePage()));
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
