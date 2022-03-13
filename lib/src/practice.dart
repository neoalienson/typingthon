import 'dart:math';

import 'package:flutter/material.dart';

import 'layout.dart';

enum PracticeMode {
  random,
  singleLeftHome,
  singleRightHome,
  slowKeys,
  minutes5,
}

var practiseModes = {
  "Slow Keys" : PracticeMode.slowKeys,
  "Random" : PracticeMode.random,
  "5 minutes" : PracticeMode.minutes5,
};

class PracticeGenerator {
  var _words = <String>[];

  Future loadWords(AssetBundle rootBundle) async {
    final _data = await rootBundle.loadString('assets/words.txt');
    _words = _data.replaceAll("\r", "").split("\n");
  }

  List<String> _buildHomeRow(PracticeMode strategy) {
    List<String> selected = [];
    final keys = layout.keys;
    final homeRow = layout.homeRow;

    for (var word in _words) {
      if (word.trim().runes.length < 3) {
        continue;
      }

      var leftTop = 0, leftHome = 0, leftBottom = 0;
      var rightTop = 0, rightHome = 0, rightBottom = 0;
      
      for (var ch in word.trim().characters) {
        var _ch = ch.toLowerCase();

        if (keys.containsKey(_ch)) {
          continue;
        }

        if (keys[_ch]!['row'] == homeRow) {
          switch (layout.keys[_ch]!['hand']) {
            case KeyHand.left: leftHome++; break;
            case KeyHand.right: rightHome++; break;
          }
        } else {
          switch (keys[_ch]!['hand']) {
            case KeyHand.left: leftTop++; break;
            case KeyHand.right: rightTop++; break;
          }
        }
      } // for ch in word.runes

      if (strategy == PracticeMode.singleLeftHome && leftTop == 0 && leftBottom == 0 && leftHome == 1 ) {
        selected.add(word);
      }

      if (strategy == PracticeMode.singleRightHome && rightTop == 0 && rightBottom == 0 && rightHome == 1 ) {
        selected.add(word);
      }

    } // for words in _words

    return selected;
  }

  List<String> buildPreferred(List<String> preferred) {
    List<String> selected = [];

    for (var word in _words) {
      if (word.trim().runes.length < 3) {
        continue;
      }

      for (var p in preferred) {
        if (word.contains(p)) {
          selected.add(word);
          continue;
        }
      }

    } // for words in _words
    return selected;
  }

  List<String> build([PracticeMode strategy = PracticeMode.random]) {
    switch (strategy) {
      case PracticeMode.singleLeftHome:
      case PracticeMode.singleRightHome:
        return _buildHomeRow(strategy);
      case PracticeMode.slowKeys:
        throw UnimplementedError("Use buildPreferred instead");
      case PracticeMode.random:
        var r = _words.toList(growable: false);
        r.shuffle();
        return r.sublist(0, min(30, _words.length));
      default:
        throw UnimplementedError();
    }
  }
}