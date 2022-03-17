import 'src/layout.dart';
import 'package:flutter/material.dart';


class Keyboard extends StatelessWidget  {
  final _keyCardSize = 48.0;
  final _cards = <String, Card>{};
  final Map<String, int> _map;
  final Map<String, int>? _topRight;
  final String? _topRightFormat;
  final Map<String, int>? _lowerRight;
  final String? _lowerRightFormat;
  final int _max;
  final Color _colorMultipler;
  final bool _colorInverse;
  final Color _colorBase;
  final String _title;
  final _subTextStyle = const TextStyle(fontSize: 8);

  Keyboard({Key? key,
    required String title,
    required Map<String, int> map,
    required int max,
    required Color colorMultipler,
    Map<String, int>? lowerRight,
    String? lowerRightFormat,
    Map<String, int>? topRight,
    String? topRightFormat,
    bool colorInverse = false,
    Color colorBase = const Color.fromARGB(0, 0, 0, 0)
  }) : 
    _title = title,
    _map = map,
    _max = max,
    _colorMultipler = colorMultipler,
    _topRight = topRight,
    _topRightFormat = topRightFormat,
    _lowerRight = lowerRight,
    _lowerRightFormat = lowerRightFormat,
    _colorBase = colorBase,
    _colorInverse = colorInverse,
    super(key: key);

  Widget _keyCard(String text, [int? lowerRight, int? topRight]) {
    String lr = "", tr = "";

    if (lowerRight != null) {
      lr = (_lowerRightFormat == null) ? lowerRight.toString() 
        : _lowerRightFormat!.replaceAll("%d", lowerRight.toString());
    }

    if (topRight != null) {
      tr = (_topRightFormat == null) ? topRight.toString() 
        : _topRightFormat!.replaceAll("%d", topRight.toString());
    }

    var normalisedColor = colorNormalise(_map[text]!, _colorInverse);
      
    Card c = Card(
      child: Stack(children: [
        Center(child: Text(text)), 
          ...(lowerRight == null) ?  
            <Widget>[] : <Widget>[
              Align(
                alignment: const FractionalOffset(0.95, 0.2),
                child: Text(tr, style: _subTextStyle,)
              ),
              Align(
                alignment: const FractionalOffset(0.95, 0.98), 
                child: Text(lr, style: _subTextStyle,)
              ),              
            ],
        ]),
      color: normalisedColor, 
      );
    _cards[text] = c;    
    return SizedBox.square(
          child: c,
          dimension: _keyCardSize,);
  }

  Color colorNormalise(int v, bool inverse) {
    var normalised = [
      (v / _max) * (255 - _colorBase.red), 
      (v / _max) * (255 - _colorBase.green),
      (v / _max) * (255 - _colorBase.blue),
      ];

    var adjusted = (inverse) ? [
      255 - (255 - _colorMultipler.red) * normalised[0] ~/ 255,
      255 - (255 - _colorMultipler.green) *normalised[1] ~/ 255,
      255 - (255 - _colorMultipler.blue) * normalised[2] ~/ 255,
    ] : [
      _colorMultipler.red * normalised[0] ~/ 255 + _colorBase.red,
      _colorMultipler.green * normalised[1] ~/ 255 + _colorBase.green,
      _colorMultipler.blue * normalised[2] ~/ 255 + _colorBase.blue,
    ];

    return 
      Color.fromARGB(255, 
        adjusted[0], adjusted[1], adjusted[2]
      );
  }

  @override
  Widget build(BuildContext context) {
    final w = <Widget>[];

    w.add(Text(_title, style: const TextStyle(fontWeight: FontWeight.bold),));
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
    if (_lowerRight?[k] != null) {
      lrHasCount = true;
    }
    if (_topRight?[k] != null) {
      trHasCount = true;
    } 
    r.add(_keyCard(k,
      (lrHasCount) ? _lowerRight![k] :null, 
      (trHasCount) ? _topRight![k] : null
      ));
  }
}