import 'package:flutter_test/flutter_test.dart';
import 'package:typingthon/src/practice.dart';

void main() {
  test('Safety', () {
    expect(PracticeGenerator.buildPreferred([], []), []);
    expect(PracticeGenerator.build([], Practice.singleLeftHome), []);
  });
}
