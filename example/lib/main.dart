import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart'; // 1. import library

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      //2. wrap your app with OKToast
      textStyle: TextStyle(fontSize: 19.0, color: Colors.white),
      backgroundColor: Colors.grey,
      radius: 10.0,
      child: MaterialApp(
        title: 'Demo for OKToast',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
      animationCurve: Curves.easeIn,
      animationBuilder: Miui10AnimBuilder(),
      animationDuration: Duration(milliseconds: 200),
      duration: Duration(seconds: 3),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    _counter++;

    setState(() {});
  }

  void _showToast() {
    // 3.1 use showToast method
    showToast(
      "$_counter",
      position: ToastPosition.bottom,
      backgroundColor: Colors.black.withOpacity(0.8),
      radius: 13.0,
      textStyle: TextStyle(fontSize: 18.0),
      animationBuilder: Miui10AnimBuilder(),
    );

    showToast(
      "$_counter",
      duration: Duration(milliseconds: 3500),
      position: ToastPosition.top,
      backgroundColor: Colors.black.withOpacity(0.8),
      radius: 3.0,
      textStyle: TextStyle(fontSize: 30.0),
    );

    // 3.2 use showToastWidget method
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
        print(
            "the toast dismiss"); // the method will be called on toast dismiss.
      },
    );

    // can use future
    Future.delayed(Duration(seconds: 2), () {
      toastFuture.dismiss(); // dismiss
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Example for OKToast"),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: ListView(
              children: <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.display1,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Tooltip(
                    message: "Toast status when using this to test routing.",
                    child: RaisedButton(
                      child: Text("New page"),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) => MyHomePage()));
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Tooltip(
                    message: "Add number.",
                    child: RaisedButton(
                      onPressed: _incrementCounter,
                      child: Text('Add'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Tooltip(
                    message: "Show toast.",
                    child: RaisedButton(
                      onPressed: _showToast,
                      child: Text('Toast'),
                    ),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Use TextField to test the toast of softkey."),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
