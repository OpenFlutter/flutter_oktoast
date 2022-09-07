import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import 'miui10_anim.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      // 2-A: wrap your app with OKToast
      textStyle: const TextStyle(fontSize: 19.0, color: Colors.white),
      backgroundColor: Colors.grey,
      animationCurve: Curves.easeIn,
      animationBuilder: const Miui10AnimBuilder(),
      animationDuration: const Duration(milliseconds: 200),
      duration: const Duration(seconds: 3),
      child: MaterialApp(
        title: 'Demo for OKToast',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }

  // 2-B: Or wrap child of the builder method.
  Widget buildApp() {
    return MaterialApp(
      home: const MyHomePage(),
      builder: (_, Widget? child) => OKToast(child: child!),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    _counter++;
    setState(() {});
  }

  void _showToast() {
    // 3-A use showToast method
    showToast(
      '$_counter',
      position: ToastPosition.bottom,
      backgroundColor: Colors.black.withOpacity(0.8),
      radius: 13.0,
      textStyle: const TextStyle(fontSize: 18.0),
      animationBuilder: const Miui10AnimBuilder(),
    );

    showToast(
      '$_counter',
      duration: const Duration(milliseconds: 3500),
      position: ToastPosition.top,
      backgroundColor: Colors.black.withOpacity(0.8),
      radius: 3.0,
      textStyle: const TextStyle(fontSize: 30.0),
    );

    // 3-B use showToastWidget method
    final Widget widget = Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          width: 40.0,
          height: 40.0,
          color: Colors.grey.withOpacity(0.3),
          child: const Icon(
            Icons.add,
            size: 30.0,
            color: Colors.green,
          ),
        ),
      ),
    );
    final ToastFuture toastFuture = showToastWidget(
      widget,
      duration: const Duration(seconds: 3),
      onDismiss: () {
        // The method will be called on toast dismiss.
        debugPrint('Toast has been dismissed.');
      },
    );

    // can use future
    Future<void>.delayed(const Duration(seconds: 2), () {
      toastFuture.dismiss(); // dismiss
    });
  }

  ToastFuture? _persistToast;

  void _showPersistToast() {
    _persistToast = showToastWidget(
      Center(
        child: ElevatedButton(
          onPressed: () => _persistToast?.dismiss(),
          child: const Text('Click this button to dismiss'),
        ),
      ),
      duration: Duration.zero,
      handleTouch: true,
    );
  }

  void _dismissToastSynchronously() {
    final ToastFuture toast = showToast('Synchronously dismiss');
    toast.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example for OKToast')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Center(
              child: Text('You have pushed the button this many times:'),
            ),
            Center(
              child: Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _showToast,
                child: const Text('Show toast'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _showPersistToast,
                child: const Text('Show a persist toast'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: const Text('Toast during pushing to a new page'),
                onPressed: () {
                  _showToast();
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(builder: (_) => const MyHomePage()),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _dismissToastSynchronously,
                child: const Text('Synchronously dismiss toast'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Add number',
        child: const Icon(Icons.add),
      ),
    );
  }
}
