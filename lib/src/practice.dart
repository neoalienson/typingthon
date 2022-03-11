import 'package:flutter/material.dart';

import 'keymap.dart';

enum Practice {
  none,
  singleLeftHome,
  singleRightHome,
  trickyKey,
}

class PracticeGenerator {

  static List<String> _buildHomeRow(List<String> words, Practice strategy) {
    List<String> selected = [];
    final keys = keyMap.keys;
    final homeRow = keyMap.homeRow;

    for (var word in words) {
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
          switch (keyMap.keys[_ch]!['hand']) {
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

      if (strategy == Practice.singleLeftHome && leftTop == 0 && leftBottom == 0 && leftHome == 1 ) {
        selected.add(word);
      }

      if (strategy == Practice.singleRightHome && rightTop == 0 && rightBottom == 0 && rightHome == 1 ) {
        selected.add(word);
      }

    } // for words in _words

    return selected;
  }

  static List<String> buildPreferred(List<String> words, List<String> preferred) {
    List<String> selected = [];

    for (var word in words) {
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

  static List<String> build(List<String> words, [Practice strategy = Practice.none]) {
    switch (strategy) {
      case Practice.singleLeftHome:
      case Practice.singleRightHome:
        return _buildHomeRow(words, strategy);
      case Practice.trickyKey:
        throw UnimplementedError("Use buildPreferred instead");
      case Practice.none:
        return words..shuffle();
      default:
        throw UnimplementedError();
    }
  }
}