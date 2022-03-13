import 'package:flutter/material.dart';
import 'package:typingthon/src/analysis.dart';

import 'keyboard.dart';

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
      body: Column(children: [
        Keyboard(
          title: "Hits", 
          map: analysis.totals, 
          max: analysis.totalMax,
          colorInverse: true,
          colorMultipler: const Color.fromARGB(0, 255, 255, 0),
          lowerRight: analysis.totals,
          ),
        Keyboard(
          title: "Incorrect",
          map: analysis.percetages, 
          max: 100, 
          colorMultipler: const Color.fromARGB(0, 255, 255, 255),
          colorBase: const Color.fromARGB(0, 64, 64, 64),
          lowerRight: analysis.percetages,
          lowerRightFormat: "%d%",
          ),
      ],)
    );
  }
}