
import 'package:flutter/material.dart';

class TestState {
  TestState({Key? key, required TextStyle baseStyle}) :
    _textStyleNormal = baseStyle,
    _textStyleUnderline = baseStyle.copyWith(decoration: TextDecoration.underline),
    _textStyleSpace = baseStyle.copyWith(backgroundColor: const Color.fromARGB(255, 245, 245, 245)),
    _textStyleTyped = baseStyle.copyWith(color: const Color.fromARGB(255, 220, 220, 220));

  final TextStyle _textStyleUnderline;
  final TextStyle _textStyleNormal;
  final TextStyle _textStyleTyped;
  final TextStyle _textStyleSpace;

  String _text = "";
  String get text {
    return _text;
  }
  set text(String t) {
    _text = t;
    _display = TextSpan(text: t, style: _textStyleNormal);
  }
  String _typed = "";
  String get typed {
    return _typed;
  }
  set typed(String t) {
    _typed = t;
    if (t.isEmpty) {
      _display = const TextSpan();
      return;
    }
    var s = <TextSpan>[];
    var typeds = text.substring(0, typed.length).split(" ");
    for (var t in typeds) {
      s.add(TextSpan(text:t, style: _textStyleTyped));
      s.add(TextSpan(text:' ', style: _textStyleSpace));
    }
    s.removeLast();
    if (text[typed.length] == "\n") {
      s.add(TextSpan(text:"¶", style: _textStyleUnderline));
    }
    s.add(TextSpan(text:text[typed.length], style: _textStyleUnderline));
    s.add(TextSpan(text:text.substring(typed.length + 1), style: _textStyleNormal));
    _display = TextSpan(text: "", 
      style: _textStyleTyped, 
      children: s);
  }
  var _display = const TextSpan(text: "");
  TextSpan get display {
    return _display;
  }

  String get progress {
    return "${typed.length.toString()}/${text.length.toString()}";
  }
}