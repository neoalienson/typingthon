import 'package:flutter/material.dart';
import 'package:typingthon/src/analysis.dart';

class HistoryPage extends StatelessWidget {
  final Analysis analysis;

  const HistoryPage({Key? key, 
    required this.analysis
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: Text(analysis.trickyKeysDisplay),
    );
  }
}