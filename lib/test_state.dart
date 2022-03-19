
import 'package:flutter/material.dart';

class TestState {
  TestState({Key? key, required TextStyle baseStyle}) :
    _textStyleNormal = baseStyle,
    _textStyleUnderline = baseStyle.copyWith(decoration: TextDecoration.underline),
    _textStyleWrong = baseStyle.copyWith(backgroundColor: Colors.red),
    _textStyleTyped = baseStyle.copyWith(color: const Color.fromARGB(255, 220, 220, 220));

  final TextStyle _textStyleUnderline;
  final TextStyle _textStyleNormal;
  final TextStyle _textStyleTyped;
  final TextStyle _textStyleWrong;

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
    int firstDiff = typed.length;
    for (var i = 0; i < typed.length; i++) {
      if (_text[i] == _typed[i]) {
        continue;
      }
      firstDiff = i;
      break;
    }
    s.add(TextSpan(text:text.substring(0, firstDiff), style: _textStyleTyped));
    if (firstDiff != typed.length) {
      if (text[typed.length - 1] == "\n") {
        s.add(TextSpan(text:text.substring(firstDiff, typed.length - 1), style: _textStyleWrong));
        s.add(TextSpan(text:"¶", style: _textStyleWrong));
        s.add(const TextSpan(text:"\n"));
      } else {
        s.add(TextSpan(text:text.substring(firstDiff, typed.length), style: _textStyleWrong));
      }
    }
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