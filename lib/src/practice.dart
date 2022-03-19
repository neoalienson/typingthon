import 'dart:async';
// ignore: unused_import
import 'dart:developer';
import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:html/parser.dart' show parse;
import 'layout.dart';

enum PracticeModes {
  random,
  singleLeftHome,
  singleRightHome,
  slowKeys,
  minutes5,
  minute1,
}

var practiceModes = {
  PracticeModes.minute1  : PracticeMode("1 minute", true, const Duration(minutes: 1)),
  PracticeModes.minutes5 : PracticeMode("5 minutes", true, const Duration(minutes: 5)),
  PracticeModes.random   : PracticeMode("Random", false, const Duration(minutes: 0)),
  PracticeModes.slowKeys : PracticeMode("Slow Keys", false, const Duration(minutes: 0)),
};

class PracticeMode {
  String name;
  bool isTimed;
  Duration duration;
  
  PracticeMode(
    this.name,
    this.isTimed,
    this.duration);
}

class PracticeEngine {
  var _words = <String>[];
  bool _isRunning = false;
  bool get isRunning => _isRunning;
  bool _hasKeyTyped = false;
  bool get hasKeyTyped => _hasKeyTyped;

  set hasKeyTyped(bool typed) {
    if (mode.isTimed && !hasKeyTyped) {
      _testTimer = Timer(mode.duration, () {
         _isRunning = false;
      });
    }
    _hasKeyTyped = typed;
  }

  Timer? _testTimer;
  var _text = "";
  String get text {
    return _text;
  }
  PracticeMode mode = practiceModes[PracticeModes.slowKeys]!;

  void start() {
    _isRunning = true;
    _hasKeyTyped = false;
  }

  void end() {
    _isRunning = false;
    _testTimer?.cancel();
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

  List<String> _buildHomeRow(PracticeModes strategy) {
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

      if (strategy == PracticeModes.singleLeftHome && leftTop == 0 && leftBottom == 0 && leftHome == 1 ) {
        selected.add(word);
      }

      if (strategy == PracticeModes.singleRightHome && rightTop == 0 && rightBottom == 0 && rightHome == 1 ) {
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

  List<String> build([PracticeModes strategy = PracticeModes.random]) {
    switch (strategy) {
      case PracticeModes.singleLeftHome:
      case PracticeModes.singleRightHome:
        return _buildHomeRow(strategy);
      case PracticeModes.slowKeys:
        throw UnimplementedError("Use buildPreferred instead");
      case PracticeModes.random:
        var r = _words.toList(growable: false);
        r.shuffle();
        return r.sublist(0, min(30, _words.length));
      default:
        throw UnimplementedError();
    }
  }
}