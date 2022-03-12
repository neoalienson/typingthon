import 'package:flutter/material.dart';
import 'package:typingthon/src/analysis.dart';

class StatisticCard extends StatelessWidget {
  final Analysis analysis;

  const StatisticCard({Key? key, required this.analysis}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    const bold = TextStyle(fontWeight: FontWeight.bold);

    return Card(
      color: (analysis.accurracy < 100) ? Colors.amber : Colors.green,
      child: Padding(padding: const EdgeInsets.all(20), 
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(flex: 1, fit: FlexFit.tight, child: 
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Statistic", style: bold),
              Text("Correct: ${analysis.correct}",),
              Text("Typed: ${analysis.typed}",),
              Text("Accurracy: ${analysis.accurracy}%",),
            ],)),
            Flexible(flex: 1, fit: FlexFit.tight, child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Elasped", style: bold),
                Text(analysis.elaspedDuration.toString().split('.').first.padLeft(8, "0")),
              ],)),
            Flexible(flex: 1, fit: FlexFit.tight, child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("WPM", style: bold),
                Text("${analysis.wpmOverall}",),
                Text("${analysis.wpmIn10s} (in 10s)",),
                Text("${analysis.wpmIn1min} (in 1min)",),
                Text("${analysis.wpmIn10min} (in 10min)",),
              ],)),              
          ],
        ),
      ),
    );    
  }
}