
import 'package:flutter/material.dart';
import 'main_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);
  
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