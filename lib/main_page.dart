import 'dart:async';
import 'dart:math' show max, min;
// ignore: unused_import
import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show KeyDownEvent, KeyRepeatEvent, LogicalKeyboardKey, rootBundle;
import 'package:typingthon/app_menu.dart';
import 'package:typingthon/keyboard.dart';
import 'package:typingthon/statistic_card.dart';
import 'detailed_analysis_page.dart';
import 'src/layout.dart';
import 'src/practice.dart';
import 'src/analysis.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _text = "";
  String _typed = "";
  late FocusNode _focusNode;
  final _analysis = Analysis();
  var _cursor = 0;
  final _totals = <String, int>{};
  var _totalMax = 1;
  final _wrongs = <String, int>{};
  final _percetages = <String, int>{};
  Timer? _updateTimer;
  final _practiceMode = PracticeMode.slowKeys;
  var _enterPressed = false;
  final _practice = PracticeGenerator();
  final _textStyleTyping = const TextStyle(
    fontSize: 24,
    );
  final _textStyleInfo = const TextStyle(
    fontSize: 12,
    fontStyle: FontStyle.italic,
  );

  void _reset() {
    _analysis.reset();
    _typed = "";
    _cursor = 0;
  }

  KeyEventResult _onBackspace() {
    if (_typed.isEmpty) {
      return KeyEventResult.ignored;
    }

    setState(() {
      _analysis.remove(_text[_cursor - 1] == _typed[_cursor - 1]);
      _cursor--;
      _typed = _typed.substring(0, _typed.length - 1);
    });

    return KeyEventResult.ignored;
  }

  KeyEventResult _onKeypressed(String ch) {
    assert(ch.length == 1);
    var expected = _text[_cursor];

    setState(() {
      if (_totals.containsKey(ch)) {
        _totals[ch] = min(_totals[ch]! + 1, 255);
      }
      _totalMax = max(1, _totals.values.reduce((value, element) => max(value, element)));

      if (_wrongs.containsKey(ch)) {
        if (ch != expected) {
          _wrongs[expected] = min(_wrongs[ch]! + 1, 255);
        }
        if (_totals.containsKey(expected)) {
          if (_totals[expected]! > 0) {
            _percetages[expected] = (_totals[expected]! - _wrongs[expected]!) * 100 ~/ _totals[expected]!;
          }
        }
      }

      _analysis.hit(ch, expected);
      _cursor++;
      _typed += ch;
    });

    return KeyEventResult.ignored;
  }

  KeyEventResult _onEnter() {
    setState(() {
      _enterPressed = true;
      _nextRound(_practice.buildPreferred(_analysis.trickyKeys(5)));
    });

    return KeyEventResult.ignored;
  }

  @override
  void initState() {
    super.initState();

    for (var k in layout.keys.keys) {
      _totals[k] = 0;
      _wrongs[k] = 0;
      _percetages[k] = 100;
    }

    _focusNode = FocusNode(
      onKeyEvent: (node, event) {
        // process only key down and repeat
        if (event.runtimeType != KeyDownEvent && event.runtimeType != KeyRepeatEvent) {
          return KeyEventResult.ignored;
        }

        if (event.logicalKey == LogicalKeyboardKey.backspace) {
          return _onBackspace();
        }

        if (event.logicalKey == LogicalKeyboardKey.enter) {
          return _onEnter();
        }

        // ignore other special keys
        if (event.character == null) {
          return KeyEventResult.ignored;
        }

        return _onKeypressed(event.character!);
      }
    );
    _loadData();

    _updateTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
      });
    });
  }

  void _nextRound(List<String> words) {
    words.shuffle();
    words = words.sublist(0, min(30, words.length));
    _text = words.join(" ");
    _reset();
  }

  void _loadData() async {
    await _practice.loadWords(rootBundle);

    setState(() {
      _text = _practice.build(PracticeMode.random).join(" ");
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final separator = Container(width: 0.5, color: Colors.black);
    const breakpoint1 = 800.0;
    const breakpoint2 = 1300.0;
    final appMenu = AppMenu(
      curreatLayout: layout, 
      currentPracticeMode: _practiceMode, 
      analysis: _analysis,);

    Widget w = Column(
      children: [
        StatisticCard(analysis: _analysis),
        Card(child:Padding(
          padding: const EdgeInsets.all(20), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_text, style: _textStyleTyping,),
              const Text(""),
              (_enterPressed) ? const Text("") 
                : Text("Once complete, press ENTER to generate next word set.", style: _textStyleInfo),
            ]))),
        Card(child: Padding(
          padding: const EdgeInsets.all(20), 
          child: Row(children: [
            (_typed.isEmpty) ? 
            Text("Type anyway from screen to begin.", style: _textStyleInfo,):
            Flexible(
              flex: 1,
              child: Text(_typed, style: _textStyleTyping),
            ),
          ]))),
        Keyboard(title: "Hits", map: _totals, max: _totalMax, color: const Color.fromARGB(0, 255, 255, 0),),
        Keyboard(
          title: "Incorrect",
          map: _percetages, 
          max: 100, 
          color: const Color.fromARGB(0, 255, 255, 255),
          colorInverse: true,
          lowerRight: _percetages,
          lowerRightFormat: "%d%",
          topRight: _totals,
          ),
        // Text(_trickyKeys),
        // Text(_analysis.wrongKeysDisplay),
      ],
    );

    if (screenWidth >= breakpoint1) {
      final rightPanel = (screenWidth >= breakpoint2) ? <Widget>[
        separator,
        Expanded(child: DetailedAnalysisPage(analysis: _analysis,)),
      ] : <Widget>[];
      w = Row(
        children: [
          SizedBox(
            width: 240,
            child: appMenu,
          ),
          separator,
          Expanded(child: w), 
          ...rightPanel,
        ],
      );
    }

    FocusScope.of(context).requestFocus(_focusNode);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: (screenWidth >= breakpoint1) ? null : 
        Drawer( child: appMenu),
      body: RawKeyboardListener(
        focusNode: _focusNode,
        child: w
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { 
          setState(() {
            _nextRound(_practice.build()); 
          });
          },
        tooltip: 'Reset',
        child: const Icon(Icons.refresh_rounded)
      ),
    );
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
}
