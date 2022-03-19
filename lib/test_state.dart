
import 'package:flutter/material.dart';

class TestState {
  TestState({Key? key, required TextStyle baseStyle}) :
    _textStyleNormal = baseStyle,
    _textStyleWrong = baseStyle.copyWith(backgroundColor: Colors.red),
    _textStyleTyped = baseStyle.copyWith(color: const Color.fromARGB(255, 220, 220, 220));

  final TextStyle _textStyleWrong;
  final TextStyle _textStyleNormal;
  final TextStyle _textStyleTyped;

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
    var s = <TextSpan>[];
    s.add(TextSpan(text: text.substring(typed.length), style: _textStyleNormal));
    _display = TextSpan(text: text.substring(0, typed.length), 
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