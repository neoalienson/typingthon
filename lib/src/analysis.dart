// ignore: unused_import
import 'dart:developer';
import 'dart:math' show max;

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:clock/clock.dart';
import 'package:typingthon/src/layout.dart';

class Hit {
  DateTime on;
  bool correct;
  String character;

  Hit(this.on, this.correct, this.character);
}

class DurationKeys with Comparable<DurationKeys> {
  double duration;
  String keys;
  String displaykeys;
  int hit;

  DurationKeys(this.duration, this.keys, this.displaykeys, this.hit);

  @override
  int compareTo(DurationKeys other) {
    return other.duration.compareTo(duration);
  }
}

class Analysis {
  final _hits = <Hit>[];
  var _correct = 0;
  var _typed = 0;
  var testLength = const Duration();
  var _start = DateTime(0);
  DateTime get start {
    return _start;
  }
  final _lowerCase = RegExp(r'[a-z]');
  final Layout layout;
  final _keyDuration = <String, Map<String, List<int>>>{};
  final _slowKeys = <DurationKeys>[];
  final _wrongKeys = <String, List<String>>{};
  final _hitKeys = <String, int>{};
  final totals = <String, int>{};
  int get totalMax {
    return max(1, totals.values.reduce((value, element) => max(value, element)));
  }
  final wrongs = <String, int>{};
  final percetages = <String, int>{};

  static const slowKeyCutoff = 5000000;
  static const slowKeyDisplay = 30;
  static const wrongKeyDisplay = 26;

  Analysis(this.layout) {
    reset();
    resetHits();

    for (var ch in layout.keys.keys) {
      totals[ch] = 0;
      wrongs[ch] = 0;
      percetages[ch] = 100;
    }

    var start = "a".codeUnitAt(0);
    var end = "z".codeUnitAt(0);
    for (var a = start; a <= end; a++) {
      var ch = String.fromCharCode(a);
      _keyDuration[ch] = {};
      _wrongKeys[ch] = [];
      _hitKeys[ch] = 0;
      for (var b = start; b <= end; b++) {
        _keyDuration[String.fromCharCode(a)]![String.fromCharCode(b)] = [];
      }      
    }
  }

  List<Hit> get hits {
    return List<Hit>.from(_hits);
  }

  int get correct {
    return _correct;
  }

  int get typed {
    return _typed;
  }

  String get trickyKeysDisplay {
    String s = "";

    _sortTrickKeys();

    var f = NumberFormat("###.00");
    for (var i = 0;  i < _slowKeys.length && i < slowKeyDisplay; i++) {
      String n = f.format((_slowKeys[i].duration / 1000000));
      s += "${_slowKeys[i].displaykeys} ${n}s  ${_slowKeys[i].hit}\n";
    }
    return s;
  }

  String get wrongKeysDisplay {
    String s = "";
    var sortedKeys = _wrongKeys.keys.toList(growable: false)..sort(
      ((a, b) => _wrongKeys[b]!.length - _wrongKeys[a]!.length)
    );

    for (var i = 0;  i < sortedKeys.length && i < wrongKeyDisplay; i++) {
      s += "${sortedKeys[i]}:${_wrongKeys[sortedKeys[i]]!.length.toString()}\n";
    }
    return s;
  }

  Map<String, List<String>> get wrongKeys {
    return Map<String, List<String>>.from(_wrongKeys);
  }

  List<String> trickyKeys(int top) {
    List<String> s = [];

    _sortTrickKeys();

    for (var i = 0;  i < _slowKeys.length && i < top; i++) {
      s.add(_slowKeys[i].keys);
    }
    return s;
  }

  void _sortTrickKeys() {
    // recalculate average
    _slowKeys.clear();
    var seen = <String>{};

    for (var i = 0; i < _hits.length - 1; i++) {
      String ch1 = _hits[i].character.toLowerCase();
      String ch2 = _hits[i + 1].character.toLowerCase();

      if (!_lowerCase.hasMatch(ch1) || !_lowerCase.hasMatch(ch2)) {
        continue;
      }
      var keys = _keyDuration[ch1]![ch2];
      if (keys!.isNotEmpty) {
        var displayKey = "${_hits[i].character} => ${_hits[i + 1].character}";
        var key = "${_hits[i].character}${_hits[i + 1].character}";
        if (!seen.contains(key)) {
          _slowKeys.add(DurationKeys(keys.average, key, displayKey, keys.length));
          seen.add(key);
        }
      }
    }
    _slowKeys.sort();
  }

  void hit(String typedRaw, String expectedRaw, [DateTime? on]) {
    var now = (on == null) ? clock.now() : on;
    var correct = typedRaw == expectedRaw;
    final expected = expectedRaw.toLowerCase();
    final typed = typedRaw.toLowerCase();

    if (_start == DateTime(0)) {
      _start = now;
    }

    if (totals.containsKey(expected)) {
        totals[expected] = totals[expected]! + 1;
      }

    if (correct) {
      _correct++;
      if (_hitKeys.containsKey(expected)) {
        _hitKeys[expected] = _hitKeys[expected]! + 1;
      }
      if  (_hits.isNotEmpty && _lowerCase.hasMatch(expected)
        && _lowerCase.hasMatch(_hits.last.character)) {
        int d = now.difference(_hits.last.on).inMicroseconds;
        // do not analysis out lining 
        if (d < slowKeyCutoff) {
          _keyDuration[_hits.last.character]![expected]!.add(d);
        }
      }
    } else {
      if (_wrongKeys.containsKey(expected)) {
        _wrongKeys[expected]!.add(typed);
      }
      if (wrongs.containsKey(expected)) {
        wrongs[expected] = wrongs[expected]! + 1;
      }
    }
    _typed++;
 
    _hits.add(Hit(now, correct, expected));
    _updatePercentages(typed, expected);
  }

  void _updatePercentages(String typed, String expected) {
    if (wrongs.containsKey(typed)) {
      if (totals.containsKey(expected)) {
        if (totals[expected]! > 0) {
          percetages[expected] = (totals[expected]! - wrongs[expected]!) * 100 ~/ totals[expected]!;
        } else {
          percetages[expected] = 0;
        }
      }
    }
  }

  void remove(bool correct) {
    if (_hits.isEmpty) {
      return;
    }
    if (correct) {
      _correct--;
    }
    _typed--;
    _hits.removeLast();
  }

  void resetHits() {
    _hits.clear();
  }

  void reset() {
    _correct = 0;
    _typed = 0;
  }

  Duration get elasped {
    if (testLength.inSeconds == 0
      || testLength > clock.now().difference(_start)) {
      return (_start == DateTime(0)) ? const Duration(seconds: 0) : clock.now().difference(_start);
    }
    return testLength;
  }

  int _wpm(Duration d) {
    int h = 0;
    for (var hit in _hits) {
      if (hit.correct && start.add(elasped).difference(hit.on) <= d) {
        h++;
      }
    }

    if (elasped.inSeconds < 4) {
      return 0;
    }
    return h * 60 ~/ ((d > elasped) ? elasped : d).inSeconds ~/ 5;
  }

  int get wpmIn10s {
    return _wpm(const Duration(seconds: 10));
  } 

  int get wpmIn1min {
    return _wpm(const Duration(minutes: 1));
  } 

  int get wpmIn10min {
    return _wpm(const Duration(minutes: 10));
  }

  int get wpmOverall {
    return _wpm(const Duration(hours: 10000));
  }

  int get accurracy {
    if (_typed == 0) {
      return 0;
    }
    return _correct * 100 ~/ _typed;
  }
}