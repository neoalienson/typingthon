import 'dart:async';
import 'dart:math' show min;
// ignore: unused_import
import 'dart:developer' show log;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show KeyDownEvent, KeyRepeatEvent, LogicalKeyboardKey, rootBundle;
import 'package:typingthon/app_menu.dart';
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
  var _analysis = Analysis(layout);
  var _cursor = 0;

  Timer? _updateTimer;
  var _enterPressed = false;
  final _practice = PracticeEngine();
  final _textStyleTyping = GoogleFonts.robotoMono(
    fontSize: 24);
  final _textStyleInfo = const TextStyle(
    fontSize: 12,
    fontStyle: FontStyle.italic,
  );

  final _textScrollController = ScrollController();
  final _typedScrollController = ScrollController();

  void _reset() {
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

  KeyEventResult _onKeypressed(String typed) {
    assert(typed.length == 1);
    if ((_cursor >= _text.length)) {
      return KeyEventResult.ignored;
    }

    var expected = _text[_cursor];
    if (expected == "\r") {
      expected = "\n";
    } 

    setState(() {
      _analysis.hit(typed, expected);
      _cursor++;
      _typed += typed;
    });

    return KeyEventResult.ignored;
  }

  KeyEventResult _onF5() {
    setState(() {
      _enterPressed = true;
      _nextRound(_practice.buildPreferred(_analysis.trickyKeys(5)));
    });

    return KeyEventResult.ignored;
  }

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode(
      onKeyEvent: _onKeyEvent
    );
    _loadData();

    _updateTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_practice.mode == PracticeMode.minutes5 && _analysis.elaspedDuration.inMinutes >= 5) {
        _updateTimer!.cancel();
      }
      setState(() {
      });
    });
  }

  KeyEventResult _onKeyEvent(node, event) {
    // process only key down and repeat
    if (event.runtimeType != KeyDownEvent && event.runtimeType != KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    if (event.logicalKey == LogicalKeyboardKey.f5) {
      return _onF5();
    }

    // practice was started and practice timer is ended
    if (_analysis.start.year != 0 && !_practice.running) {
      return KeyEventResult.ignored;
    }
    if (!_practice.running) {
      _practice.start();
    }

    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      _updateTextScrolls(context);
      return _onBackspace();
    }



    // ignore other special keys
    if (event.character == null && event.logicalKey != LogicalKeyboardKey.enter) {
      return KeyEventResult.ignored;
    }

    String ch = (event.character == null) ? "\n" : event.character!;

    _onKeypressed(ch);
    _updateTextScrolls(context);

    return KeyEventResult.ignored;
  }

  void _updateTextScrolls(BuildContext context) {
    if (_typedScrollController.hasClients) {
      _typedScrollController.animateTo(_typedScrollController.position.maxScrollExtent,
        curve: Curves.ease, duration: const Duration(milliseconds: 200));
      _textScrollController.animateTo(_typedScrollController.position.maxScrollExtent,
        curve: Curves.ease, duration: const Duration(milliseconds: 200));
    }
  }

  void _nextRound(List<String> words) {
    words.shuffle();
    words = words.sublist(0, min(30, words.length));
    _text = words.join(" ");
    _reset();
  }

  void _loadData() async {
    // await _practice.loadWords(rootBundle);
    // text = _practice.build(PracticeMode.random).join(" ")
    // text = await _practice.loadXmlFromUrl("https://www.technologyreview.com/feed/");
    var texts = await _practice.loadXmlFromFile(rootBundle, "assets/texts/1.txt"); 
    texts.shuffle();

    setState(() {
      _text = texts.first;
    });
  }

  void _on5minsTest() {
    _practice.mode = PracticeMode.minutes5;
    _reset();
    _loadData();
    _analysis = Analysis(layout);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final separator = Container(width: 0.5, color: Colors.black);
    const breakpoint1 = 800.0;
    const breakpoint2 = 1300.0;
    final appMenu = AppMenu(
      hambgerMenuMode: (screenWidth < breakpoint1),
      curreatLayout: layout, 
      currentPracticeMode: _practice.mode, 
      analysis: _analysis,
      on5minTest: _on5minsTest,
      );
    const subStyle = TextStyle(fontSize: 12);

    Widget w = Column(
      children: [
        StatisticCard(analysis: _analysis, practiceEngine: _practice,),
        SizedBox(height: 300, child: 
          Card(child:Padding(
            padding: const EdgeInsets.all(20), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 200, child: 
                SingleChildScrollView(child:
                  Text(_text,
                    style: _textStyleTyping,
                    overflow: TextOverflow.fade,
                  ),
                  controller: _textScrollController,
                ),),
                const SizedBox(height: 10,),
                (_enterPressed) ? const Text("") 
                  : Text("Once complete, press F5 to generate next word set.", style: _textStyleInfo),
            ])

          ))
        ),
       
        Card(child: Padding(
          padding: const EdgeInsets.all(20), 
          child: SizedBox(height: 100, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(alignment: Alignment.topRight, child:
                  Text("${_typed.length.toString()}/${_text.length.toString()}", style: subStyle,)
                  ),
                (_typed.isEmpty) ? 
                Text("Type anyway from screen to begin.", style: _textStyleInfo,):
                Expanded(child: 
                  SingleChildScrollView(child: 
                    Text(_typed, style: _textStyleTyping),
                    controller: _typedScrollController,
                  ),
                ),
              ]
            ),
          )
        ))
        ,
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
    _practice.dispose();
    super.dispose();
  }
}
