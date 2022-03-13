import 'package:flutter/material.dart';
import 'package:typingthon/src/analysis.dart';

class DetailedAnalysisPage extends StatelessWidget {
  final Analysis analysis;

  const DetailedAnalysisPage({Key? key, 
    required this.analysis
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detailed Analysis"),
      ),
      body: Text(analysis.trickyKeysDisplay),
    );
  }
}