import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typingthon/src/test_state.dart';

void main() {
  test('Exceptional cases', () {
    final t = TestState(baseStyle: const TextStyle());
    t.typeBackspace();
    expect(t.typed, "");
    t.typeCharacter("a");
    expect(t.typed, "");
  });

  test('Normal cases', () {
    final t = TestState(baseStyle: const TextStyle());
    t.text = "test";
    t.typeCharacter("a");
    expect(t.typed, "a");
    t.typeBackspace();
    expect(t.typed, "");
    t.typeCharacter("t");
    expect(t.typed, "t");
    t.clearTyped();
    expect(t.typed, "");
  });
}