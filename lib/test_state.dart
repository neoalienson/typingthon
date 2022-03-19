
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

  var _cursor = 0;
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

  void typeCharacter(String ch) {
    if (hasTypedAll) {
      return;
    }
    _cursor++;
    _updateTyped(_typed + ch);
  }

  void typeBackspace() {
    if (_cursor == 0) {
      _updateTyped("");
      return;
    }
    _cursor--;
    _updateTyped(typed.substring(0, typed.length - 1));
  }

  void clearTyped() {
    _updateTyped("");
  }

  void _updateTyped(String t) {
    _typed = t;
    if (t.isEmpty) {
      _display = TextSpan(text: _text, style: _textStyleNormal);
      _cursor = 0;
      return;
    }
    var s = <TextSpan>[];
    s.add(TextSpan(text:text.substring(0, typed.length), style: _textStyleTyped));
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

  bool get isLastCorrect {
    return text[_cursor - 1] == typed[_cursor - 1];
  }

  bool get hasTypedAll {
    return _cursor >= text.length;
  }

  String get expected {
    return text[_cursor];
  }
}