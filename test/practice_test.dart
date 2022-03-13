import 'package:flutter_test/flutter_test.dart';
import 'package:typingthon/src/practice.dart';

void main() {
  test('Safety', () {
    var practise = PracticeGenerator();
    expect(practise.buildPreferred([]), []);
    expect(practise.build(PracticeMode.singleLeftHome), []);
  });
}
