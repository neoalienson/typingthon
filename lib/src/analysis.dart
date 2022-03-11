// ignore: unused_import
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:clock/clock.dart';

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
  var _start = DateTime(0);
  final _lowerCase = RegExp(r'[a-z]');
  
  final _keyDuration = <String, Map<String, List<int>>>{};
  final _trickKeys = <DurationKeys>[];
  final _wrongKeys = <String, List<String>>{};
  final _hitKeys = <String, int>{};

  static const slowKeyCutoff = 5000000;
  static const trickyKeyDisplay = 5;
  static const wrongKeyDisplay = 5;

  Analysis() {
    reset();
    resetHits();

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
    for (var i = 0;  i < _trickKeys.length && i < trickyKeyDisplay; i++) {
      String n = f.format((_trickKeys[i].duration / 1000000));
      s += "${_trickKeys[i].displaykeys} ${n}s  ${_trickKeys[i].hit}\n";
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

    for (var i = 0;  i < _trickKeys.length && i < top; i++) {
      s.add(_trickKeys[i].keys);
    }
    return s;
  }

  void _sortTrickKeys() {
    // recalculate average
    _trickKeys.clear();
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
          _trickKeys.add(DurationKeys(keys.average, key, displayKey, keys.length));
          seen.add(key);
        }
      }
    }
    _trickKeys.sort();
  }

  void hit(String typed, String expected, [DateTime? on]) {
    var now = (on == null) ? clock.now() : on;
    var correct = typed == expected;
    final expectedLowered = expected.toLowerCase();
    if (_hits.isEmpty) {
      _start = now;
    }
    if (correct) {
      _correct++;
      if (_hitKeys.containsKey(expectedLowered)) {
        _hitKeys[expectedLowered] = _hitKeys[expectedLowered]! + 1;
      }
      if  (_hits.isNotEmpty && _lowerCase.hasMatch(expectedLowered)
        && _lowerCase.hasMatch(_hits.last.character)) {
        int d = now.difference(_hits.last.on).inMicroseconds;
        // do not analysis out lining 
        if (d < slowKeyCutoff) {
          _keyDuration[_hits.last.character]![expectedLowered]!.add(d);
        }
      }
    } else {
      if (_wrongKeys.containsKey(expectedLowered)) {
        _wrongKeys[expectedLowered]!.add(typed);
      }
    }
    _typed++;
    _hits.add(Hit(now, correct, expectedLowered));
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

  int get elasped {
    if (_hits.isEmpty) {
      return 0;
    }
    return clock.now().difference(_hits.first.on).inSeconds;
  }

  Duration get elaspedDuration {
    if (_hits.isEmpty) {
      return const Duration();
    }
    return clock.now().difference(_hits.first.on);
  }

  int _wpm(Duration d) {
    int h = 0;
    var now = clock.now();
    Duration dur = now.difference(_start);
    if (d < dur) {
      dur = d;
    }
    for (var hit in _hits) {
      if (hit.correct && now.difference(hit.on) <= dur) {
        h++;
      }
    }

    if (dur.inSeconds < 5) {
      return 0;
    }
    return h * 60 ~/ dur.inSeconds ~/ 5;
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