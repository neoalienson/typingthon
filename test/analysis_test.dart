import 'package:flutter_test/flutter_test.dart';
import 'package:typingthon/src/analysis.dart';
import 'package:clock/clock.dart';
import 'package:typingthon/src/layout.dart';

DateTime t(int s) {
  return DateTime(0).add(const Duration(seconds: 1) * s);
}
void main() {
  test('single correct', () {
    var a = Analysis(layout);
    a.hit("a", "a");
    expect(a.correct, 1);
    expect(a.accurracy, 100);
    expect(a.typed, 1);
  });

  test('single wrong', () {
    var a = Analysis(layout);
    a.hit("a", "b");
    expect(a.correct, 0);
    expect(a.accurracy, 0);
    expect(a.typed, 1);
    expect(a.wrongKeys['b'], ['a']);
  });

  test('delete right', () {
    var a = Analysis(layout);
    a.hit("a", "a");
    a.remove(true);
    expect(a.correct, 0);
    expect(a.accurracy, 0);
    expect(a.typed, 0);
  });

  test('delete wrong', () {
    var a = Analysis(layout);
    a.hit("a", "b");
    a.remove(false);
    expect(a.correct, 0);
    expect(a.accurracy, 0);
    expect(a.typed, 0);
  });

  test('ab', () {
    var a = Analysis(layout);
    a.hit("a", "a");
    a.hit("b", "a");
    expect(a.correct, 1);
    expect(a.accurracy, 50);
    expect(a.typed, 2);
  });

  test('aa', () {
    var a = Analysis(layout);
    a.hit("a", "a", t(0));
    a.hit("a", "a", t(1));    
    expect(a.correct, 2);
    expect(a.accurracy, 100);
    expect(a.typed, 2);
    expect(a.trickyKeys(5), ["aa"]);
  });

  test('a a', () {
    var a = Analysis(layout);
    a.hit("a", "a", t(0));
    a.hit(" ", " ", t(1));
    a.hit("a", "a", t(2));    
    expect(a.correct, 3);
    expect(a.accurracy, 100);
    expect(a.typed, 3);
    expect(a.trickyKeys(5).length, 0);
  });

  test('a aa ab', () {
    var a = Analysis(layout);
    a.hit("a", "a", t(0));
    a.hit(" ", " ", t(1));
    a.hit("a", "a", t(2));
    a.hit("a", "a", t(3));
    a.hit(" ", " ", t(4));
    a.hit("a", "a", t(5));
    a.hit("b", "b", t(7));
    expect(a.correct, 7);
    expect(a.accurracy, 100);
    expect(a.typed, 7);
    expect(a.trickyKeys(5), ["ab", "aa"]);
  });

  test('a aaa< ab', () {
    var a = Analysis(layout);
    a.hit("a", "a", t(0));
    a.hit(" ", " ", t(1));
    a.hit("a", "a", t(2));
    a.hit("a", "a", t(3));
    a.hit("a", " ", t(4));
    a.remove(false);
    a.hit(" ", " ", t(5));
    a.hit("a", "a", t(6));
    a.hit("b", "b", t(9));
    expect(a.correct, 7);
    expect(a.accurracy, 100);
    expect(a.typed, 7);
    expect(a.trickyKeys(5), ["ab", "aa"]);
  });
  test('a aa<a ab', () {
    var a = Analysis(layout);
    a.hit("a", "a", t(0));
    a.hit(" ", " ", t(1));
    a.hit("a", "a", t(2));
    a.hit("a", "a", t(3));
    a.remove(true);
    a.hit("a", "a", t(4));
    a.hit(" ", " ", t(5));
    a.hit("a", "a", t(6));
    a.hit("b", "b", t(9));
    expect(a.correct, 7);
    expect(a.accurracy, 100);
    expect(a.typed, 7);
    expect(a.trickyKeys(5), ["ab", "aa"]);
  });
  test('a ab<a ab', () {
    var a = Analysis(layout);
    a.hit("a", "a", t(0));
    a.hit(" ", " ", t(1));
    a.hit("a", "a", t(2));
    a.hit("b", " ", t(3));
    a.remove(false);
    a.hit("a", "a", t(4));
    a.hit(" ", " ", t(5));
    a.hit("a", "a", t(6));
    a.hit("b", "b", t(9));
    expect(a.correct, 7);
    expect(a.accurracy, 100);
    expect(a.typed, 7);
    expect(a.trickyKeys(5), ["ab", "aa"]);
  });

  test('wpm should be zero within first 5 second', () {
    var a = Analysis(layout);
    a.hit("a", "a", t(0));
    withClock(
      Clock.fixed(t(4)),
      () {
        expect(a.wpmIn10min, 0);
        expect(a.wpmIn1min, 0);
        expect(a.wpmIn10s, 0);
        expect(a.wpmOverall, 0);
      }
      );    
  });

  test('wpm', () {
    var a = Analysis(layout);
    a.hit("a", "a", t(0));
    a.hit("a", "a", t(1));
    a.hit("a", "a", t(2));
    a.hit("a", "a", t(3));
    a.hit("a", "a", t(4));
    withClock(
      Clock.fixed(t(5)),
      () {
        expect(a.wpmIn10min, 12);
        expect(a.wpmIn1min, 12);
        expect(a.wpmIn10s, 12);
        expect(a.wpmOverall, 12);
      }
      );
    withClock(
      Clock.fixed(t(20)),
      () {
        expect(a.wpmIn10s, 0);
        expect(a.wpmIn10min, 3);
        expect(a.wpmIn1min, 3);
        expect(a.wpmOverall, 3);
      }
      );
  });

  test('should not clear hits on reset', () {
    var a = Analysis(layout);
    a.hit("a", "a", t(0));
    a.reset();
    expect(a.hits.length, 1); 
    a.hits.add(Hit(t(0), true, "a"));
    expect(a.hits.length, 1);
  });
}
