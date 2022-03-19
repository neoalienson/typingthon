import 'package:flutter/material.dart';
import 'package:typingthon/src/analysis.dart';
import 'package:typingthon/src/practice.dart';

class StatisticCard extends StatelessWidget {
  final Analysis  _analysis;
  final PracticeEngine _practiceEngine;

  const StatisticCard({
    Key? key,
    required Analysis analysis,
    required PracticeEngine practiceEngine,
    }) : 
    _analysis = analysis,
    _practiceEngine = practiceEngine,
    super(key: key);


  @override
  Widget build(BuildContext context) {
    const bold = TextStyle(fontWeight: FontWeight.bold);
    var cardColor = Colors.white;
    if (_practiceEngine.isRunning) {
      cardColor = (_analysis.accurracy < 100) ? Colors.amber : Colors.green;
    }

    return Card(
      color: cardColor,
      child: Padding(padding: const EdgeInsets.all(20), 
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(flex: 1, fit: FlexFit.tight, child: 
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Statistic", style: bold),
              Text("Correct: ${_analysis.correct}",),
              Text("Typed: ${_analysis.typed}",),
              Text("Accurracy: ${_analysis.accurracy}%",),
            ],)),
            Flexible(flex: 1, fit: FlexFit.tight, child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Elasped", style: bold),
                Text(_analysis.elasped.toString().split('.').first.padLeft(8, "0")),
              ],)),
            Flexible(flex: 1, fit: FlexFit.tight, child: 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Practise mode", style: bold,),
                  Text(_practiceEngine.mode.name),
                ],
              )),
            Flexible(flex: 1, fit: FlexFit.tight, child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("WPM", style: bold),
                Text("${_analysis.wpmOverall}",),
                Text("${_analysis.wpmIn10s} (in 10s)",),
                Text("${_analysis.wpmIn1min} (in 1min)",),
                Text("${_analysis.wpmIn10min} (in 10min)",),
              ],)),              
            ElevatedButton(
              onPressed: () {}, 
              child: const Text("More"))
          ],
        ),
      ),
    );    
  }
}