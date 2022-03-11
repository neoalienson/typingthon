import 'dart:async';
import 'dart:math' show max, min;
// ignore: unused_import
import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show KeyDownEvent, KeyRepeatEvent, LogicalKeyboardKey, rootBundle;
import 'package:typingthon/keyboard.dart';
import 'src/keymap.dart';
import 'src/practice.dart';
import 'src/analysis.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Typingthon',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
        ),
      ),
      home: const MyHomePage(title: 'Typingthon'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _text = "";
  String _typed = "";
  String _trickyKeys = "";
  late List<String> _words;
  late FocusNode _focusNode;
  final _analysis = Analysis();
  var _cursor = 0;
  final _heats = <String, int>{};
  var _heatsMax = 1;
  final _wrongs = <String, int>{};
  var _wrongsMax = 1;
  Timer? _updateTimer;

  void _reset() {
    _analysis.reset();
    _typed = "";
    _trickyKeys = "";
    _cursor = 0;
  }

  void _onBackspace() {
    if (_typed.isEmpty) {
      return;
    }

    setState(() {
      _analysis.remove(_text[_cursor - 1] == _typed[_cursor - 1]);
      _cursor--;
      _typed = _typed.substring(0, _typed.length - 1);
    });
  }

  void _onKeypressed(String ch) {
    assert(ch.length == 1);
    var expected = _text[_cursor];

    setState(() {
      if (_heats.containsKey(ch)) {
        _heats[ch] = min(_heats[ch]! + 1, 255);
      }
      _heatsMax = max(1, _heats.values.reduce((value, element) => max(value, element)));

      if (_wrongs.containsKey(ch)) {
        if (ch != expected) {
          _wrongs[expected] = min(_wrongs[ch]! + 1, 255);
        }
      }
      _wrongsMax = max(1, _wrongs.values.reduce((value, element) => max(value, element)));

      _analysis.hit(ch, expected);
      _cursor++;
      _typed += ch;
      _trickyKeys = _analysis.trickyKeysDisplay;
    });
  }

  @override
  void initState() {
    super.initState();

    for (var k in keyMap.keys.keys) {
      _heats[k] = 0;
      _wrongs[k] = 0;
    }

    _focusNode = FocusNode(
      onKeyEvent: (node, event) {
        // process only key down and repeat
        if (event.runtimeType != KeyDownEvent && event.runtimeType != KeyRepeatEvent) {
          return KeyEventResult.ignored;
        }

        if (event.logicalKey == LogicalKeyboardKey.backspace) {
          _onBackspace();
          return KeyEventResult.ignored;
        }

        if (event.logicalKey == LogicalKeyboardKey.enter) {
          setState(() {
            _nextRound(PracticeGenerator.buildPreferred(_words, _analysis.trickyKeys(5)));
          });
          return KeyEventResult.ignored;
        }

        // ignore other special keys
        // log("'${event.character}' '${event.logicalKey.keyLabel}'");
        if (event.character == null) {
          return KeyEventResult.ignored;
        }

        _onKeypressed(event.character!);

        return KeyEventResult.ignored;
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
    final _data = await rootBundle.loadString('assets/words.txt');
    _words = _data.replaceAll("\r", "").split("\n");
    var words = PracticeGenerator.build(_words);
    words.shuffle();
    words = words.sublist(0, min(30, words.length));

    setState(() {
      _text = words.join(" ");
    });
  }

  Widget _buildStatisticCard() {
    const bold = TextStyle(fontWeight: FontWeight.bold);

    return Card(
      color: (_analysis.accurracy < 100) ? Colors.amber : Colors.green,
      child: Padding(padding: const EdgeInsets.all(20), 
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(flex: 1, fit: FlexFit.tight, child: 
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Statistic", style: bold),
              Text("Correct: ${_analysis.correct}",),
              Text("Typed: ${_analysis.typed}",),
              Text("Accurracy: ${_analysis.accurracy}%",),
            ],)),
            Flexible(flex: 1, fit: FlexFit.tight, child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Elasped", style: bold),
                Text(_analysis.elaspedDuration.toString().split('.').first.padLeft(8, "0")),
              ],)),
            Flexible(flex: 1, fit: FlexFit.tight, child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("WPM", style: bold),
                Text("${_analysis.wpmOverall}",),
                Text("${_analysis.wpmIn10s} (in 10s)",),
                Text("${_analysis.wpmIn1min} (in 1min)",),
                Text("${_analysis.wpmIn10min} (in 10min)",),
              ],)),              
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const s = TextStyle(
      fontSize: 24,
      );

    Widget w = Column(
      children: [
        _buildStatisticCard(),
        Card(child:Padding(
          padding: const EdgeInsets.all(20), 
          child: Text(_text, style: s,))),
        Card(child: Padding(
          padding: const EdgeInsets.all(20), 
          child:Text(_typed, style: s))),
        Keyboard(title: "Hits", map: _heats, max: _heatsMax, color: const Color.fromARGB(0, 255, 255, 0),),
        Keyboard(title: "Incorrect", map: _wrongs, max: _wrongsMax, color: const Color.fromARGB(0, 255, 0, 0),),
        // Text(_trickyKeys),
        // Text(_analysis.wrongKeysDisplay),
      ],
    );

    FocusScope.of(context).requestFocus(_focusNode);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RawKeyboardListener(
        focusNode: _focusNode,
        child: w
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { 
          setState(() {
            _nextRound(PracticeGenerator.build(_words)); 
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
