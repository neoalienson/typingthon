import 'package:flutter/material.dart';
import 'main_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Typingthon',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
        ),
      ),
      home: const MainPage(title: 'Typingthon'),
    );
  }
}