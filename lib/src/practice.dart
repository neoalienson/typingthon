import 'dart:async';
// ignore: unused_import
import 'dart:developer';
import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:html/parser.dart' show parse;
import 'layout.dart';

enum PracticeMode {
  random,
  singleLeftHome,
  singleRightHome,
  slowKeys,
  minutes5,
}

const practisModeNames = {
  PracticeMode.minutes5 : "5 minutes",
  PracticeMode.random : "Random",
  PracticeMode.slowKeys : "Slow Keys",
};

class PracticeEngine {
  var _words = <String>[];
  bool _running = false;

  bool get running => _running;

  Timer? _testTimer;
  var _text = "";
  String get text {
    return _text;
  }
  PracticeMode mode = PracticeMode.slowKeys;

  void start() {
    _running = true;
    if (mode == PracticeMode.minutes5) {
      _testTimer = Timer(const Duration(minutes: 5), () {
         _running = false;
      });
    }
  }

  void end() {
    _running = false;
  }

  void dispose() {
    if (_testTimer != null) {
      _testTimer!.cancel();
    }
  }

  Future loadWords(AssetBundle rootBundle) async {
    final _data = await rootBundle.loadString('assets/words.txt');
    _words = _data.replaceAll("\r", "").split("\n");
  }

  Future<List<String>> loadXmlFromFile(AssetBundle rootBundle, String path) async {
    return _processXml(await rootBundle.loadString(path));
  }

  Future<List<String>> loadXmlFromUrl(String uRL, [http.Client? client]) async {
    var c = (client == null) ? http.Client() : client;

    final response = await c.get(Uri.parse(uRL));
    if (response.statusCode == 200) {
      return _processXml(response.body);
      } else {
      _text = "Error loading...";
    }

    return [];
  }

  List<String> _processXml(String text) {
    final textXml = xml.XmlDocument.parse(text);
    final elements = textXml.findAllElements("content:encoded");
    var texts = <String>[];
    for (var element in elements) {
      final html = parse(element.text);
      // change non-breaking space ASCII 160 to space
      var text = html.documentElement!.text.replaceAll(RegExp(r'(\n){2,}'), "\n").trim()
        .replaceAll('“', '"').replaceAll('”', '"').replaceAll("’", "'").replaceAll("—", " - ")
        .replaceAll("‘", "'")
        .replaceAll("\r", "\n").replaceAll(String.fromCharCode(160), " ").replaceAll("…", "...");
      final lines = text.split("\n");
      text = "";
      for (var line in lines) {
        text += line.trim();
        text += "\n";
      } 
      texts.add(text);
    }
     return texts;
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