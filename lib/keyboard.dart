import 'src/layout.dart';
import 'package:flutter/material.dart';


class Keyboard extends StatelessWidget  {
  final keySize = 48.0;
  final cards = <String, Card>{};
  final Map<String, int> map;
  final Map<String, int>? topRight;
  final String? topRightFormat;
  final Map<String, int>? lowerRight;
  final String? lowerRightFormat;
  final int max;
  final Color color;
  final bool colorInverse;
  final String title;
  final subStyle = const TextStyle(fontSize: 8);

  Keyboard({Key? key,
    required this.title,
    required this.map,
    required this.max,
    required this.color,
    this.lowerRight,
    this.lowerRightFormat,
    this.topRight,
    this.topRightFormat,
    this.colorInverse = false,
    }) : super(key: key);

  Widget _keyCard(String text, [int? lowerRight, int? topRight]) {
    String lr = "", tr = "";

    if (lowerRight != null) {
      lr = (lowerRightFormat == null) ? lowerRight.toString() 
        : lowerRightFormat!.replaceAll("%d", lowerRight.toString());
    }

    if (topRight != null) {
      tr = (topRightFormat == null) ? topRight.toString() 
        : topRightFormat!.replaceAll("%d", topRight.toString());
    }
    
    var normalisedColor = (colorInverse) ? 
      Color.fromARGB(255, 
        color.red * map[text]! * 255 ~/ max ~/ 255,
        color.green * map[text]! * 255 ~/ max ~/ 255,
        color.blue * map[text]! * 255 ~/ max ~/ 255,
        ) :
      Color.fromARGB(255, 
        255 - (255 - color.red) * map[text]! * 255 ~/ max ~/ 255,
        255 - (255 - color.green) * map[text]! * 255 ~/ max ~/ 255,
        255 - (255 - color.blue) * map[text]! * 255 ~/ max ~/ 255,
        );

    Card c = Card(
      child: Stack(children: [
        Center(child: Text(text)), 
          ...(lowerRight == null) ?  
            <Widget>[] : <Widget>[
              Align(
                alignment: const FractionalOffset(0.95, 0.2),
                child: Text(tr, style: subStyle,)
              ),
              Align(
                alignment: const FractionalOffset(0.95, 0.9), 
                child: Text(lr, style: subStyle,)
              ),              
            ],
        ]),
      color: normalisedColor, 
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
        _keyCardSetup(k, r);
      }
      if (layout.isSplit) {
        r.add(const Spacer());
      }
      for (var k in row.right) {
        _keyCardSetup(k, r);
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

  void _keyCardSetup(String k, List<Widget> r) {
    var lrHasCount = false, trHasCount = false;
    if (lowerRight?[k] != null) {
      lrHasCount = true;
    }
    if (topRight?[k] != null) {
      trHasCount = true;
    } 
    r.add(_keyCard(k,
      (lrHasCount) ? lowerRight![k] :null, 
      (trHasCount) ? topRight![k] : null
      ));
  }
}