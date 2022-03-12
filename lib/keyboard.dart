import 'src/layout.dart';
import 'package:flutter/material.dart';


class Keyboard extends StatelessWidget  {
  final keySize = 48.0;
  final cards = <String, Card>{};
  final Map<String, int> map;
  final int max;
  final Color color;
  final String title;

  Keyboard({Key? key,
    required this.title,
    required this.map,
    required this.max,
    required this.color}) : super(key: key);

  Widget _keyCard(String text) {
    Card c = Card(
      child: Center(child: Text(text)),
      color:  Color.fromARGB(255, 
        255 - (255 - color.red) * map[text]! * 255 ~/ max ~/ 255,
        255 - (255 - color.green) * map[text]! * 255 ~/ max ~/ 255,
        255 - (255 - color.blue) * map[text]! * 255 ~/ max ~/ 255),
      );
    cards[text] = c;    
    return SizedBox.square(
          child: c,
          dimension: keySize,);
  }

  @override
  Widget build(BuildContext context) {
    final w = <Widget>[];
    w.add(Text(title, style: const TextStyle(fontWeight: FontWeight.bold),));
    for (var row in layout.rows.values) {
      final r = <Widget>[];
      r.add(const Spacer());
      for (var k in row.left) {
        r.add(_keyCard(k));
      }
      if (layout.isSplit) {
        r.add(const Spacer());
      }
      for (var k in row.right) {
        r.add(_keyCard(k));
      }
      r.add(const Spacer());

      w.add(Row(children: r));
    }
    return Card(child: 
      Padding(
        padding: const EdgeInsets.all(20), 
        child: Column(children: w,)
      ),
    );
  }
}