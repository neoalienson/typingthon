import 'dart:async';
import 'dart:math' show min;
// ignore: unused_import
import 'dart:developer' show log;
// ignore: unused_import
import 'package:firebase_storage/firebase_storage.dart';
// ignore: unused_import
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_auth/firebase_auth.dart' as fa_;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show KeyDownEvent, KeyRepeatEvent, LogicalKeyboardKey;
import 'package:localstorage/localstorage.dart';
import 'package:typingthon/app_menu.dart';
import 'package:typingthon/history_page.dart';
import 'package:typingthon/src/records.dart';
import 'package:typingthon/statistic_card.dart';
import 'package:typingthon/src/test_state.dart';
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
  static final TextStyle _textStyleNormal = GoogleFonts.robotoMono(
      fontSize: 24, color: Colors.black);
  final test = TestState(baseStyle: _textStyleNormal);
  late FocusNode _focusNode;
  var _analysis = Analysis(layout);
  Timer? _updateTimer;
  var _showInfo = false;
  final _practice = PracticeEngine();
  final _textScrollController = ScrollController();
  final _typedScrollController = ScrollController();
  void _reset() {
    test.clearTyped();
    _textScrollController.jumpTo(0);
  }
  late final TextEditingController _username;
  late final TextEditingController _password;

  void _signin() async {
    try {
      await fa_.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _username.text,
        password: _password.text,
      );
    } on fa_.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
    }

  }

  KeyEventResult _onBackspace() {
    if (test.typed.isEmpty) {
      return KeyEventResult.ignored;
    }

    setState(() {
      _analysis.remove(test.isLastCorrect);
      test.typeBackspace();
    });

    return KeyEventResult.ignored;
  }

  KeyEventResult _onKeypressed(String ch) {
    assert(ch.length == 1);

    // expected must not be changed
    setState(() {
      _analysis.hit(ch, test.expected);
      test.typeCharacter(ch);
    });

     return KeyEventResult.ignored;
  }

  KeyEventResult _onF5() {
    setState(() {
      _showInfo = true;
      _nextRound(_practice.buildPreferred(_analysis.trickyKeys(5)));
    });

    return KeyEventResult.ignored;
  }
  fa_.User? _user;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(
      onKeyEvent: _onKeyEvent
    );        

    fa_.FirebaseAuth.instance
    .authStateChanges()
    .listen((fa_.User? user) {
      if (user == null) {
        log('User is currently signed out!');
      } else {
        log('User is signed in!');

        // usersRef.doc("wH3hmn9Z5tMaUHu3tfBB").history.get().then((value) {
        // List<HistoryRecord> h = [];
        //   for (var r in value.docs) {
        //     h.add(HistoryRecord(datetime: r.data.datetime, wpm: r.data.wpm));
        //   }
        //   h.sort(((a, b) => a.datetime.difference(b.datetime).inSeconds));
        //   history.clear();
        //   history.addAll(h);
        // });
      }
      _user = user;

    });

    _username = TextEditingController();
    _password = TextEditingController();

    _loadData();
    _addTimer();
  }

  void _addTimer() {
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (t) {
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
    if (!_practice.isRunning && _practice.hasKeyTyped) {
      return KeyEventResult.ignored;
    }
    _practice.hasKeyTyped = true;
    _analysis.start();

    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      _updateTextScrolls();
      return _onBackspace();
    }

    // ignore other special keys
    if (event.character == null && event.logicalKey != LogicalKeyboardKey.enter) {
      return KeyEventResult.ignored;
    }

    String ch = (event.character == null) ? "\n" : event.character!;

    _onKeypressed(ch);
    _updateTextScrolls();

    return KeyEventResult.ignored;
  }

  void _updateTextScrolls() {
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
    test.text = words.join(" ");
    _reset();
  }

  void _loadData() async {
    // await _practice.loadWords(rootBundle);
    // text = _practice.build(PracticeMode.random).join(" ")
    // var texts = await _practice.loadXmlFromUrl(");
    // var texts = await _practice.loadXmlFromFile(rootBundle, "assets/texts/1.txt"); 
    var text = await _practice.loadXmlFromFireStore(
      LocalStorage('text_library.json' ),
      FirebaseStorage.instance); 

    setState(() {
      test.text = text;
    });
  }

  void _onMinsTest(PracticeMode mode) {
    _practice.end();
    _reset();
    _loadData();
    _analysis = Analysis(layout);
    _analysis.testLength = mode.duration;
    _practice.mode = mode;
    _practice.onCompleted = () {
      // final h = HistoryRecord(datetime: DateTime.now(), wpm: _analysis.wpmOverall);
      // usersRef.doc("wH3hmn9Z5tMaUHu3tfBB").history.add(h);
      // history.add(HistoryRecord(datetime: h.datetime, wpm: h.wpm));
    };
    _practice.start();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final separator = Container(width: 0.5, color: Colors.black);
    const breakpoint1 = 800.0;
    const breakpoint2 = 1300.0;
    const breakpoint3 = 2000.0;

    final appMenu = AppMenu(
      hambgerMenuMode: (screenWidth < breakpoint1),
      curreatLayout: layout, 
      currentPracticeMode: _practice.mode, 
      analysis: _analysis,
      onMinTest: _onMinsTest,
      );
    const subStyle = TextStyle(fontSize: 12);
    const _textStyleInfo = TextStyle(
      fontSize: 12,
      fontStyle: FontStyle.italic,
    );

    var login = (_user == null) ? <Widget>[
      Card(child:Padding(
        padding: const EdgeInsets.all(20), 
        child: Column(children: [
          TextField(
            controller: _username,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),   
          TextField(
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
          ElevatedButton(
            onPressed: () { _signin(); }, 
            child: const Text("Login")),
          ]
          )
        )
      )]
      : <Widget>[];
    Widget w = Column(
      children: [
        StatisticCard(analysis: _analysis, practiceEngine: _practice,),
        SizedBox(height: 300, child: 
          Card(child:Padding(
            padding: const EdgeInsets.all(20), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 220, child: 
                SingleChildScrollView(child:
                  RichText(text: test.display,
                    overflow: TextOverflow.fade,
                  ),
                  controller: _textScrollController,
                ),),
                const SizedBox(height: 10,),
                (_showInfo) ? const Text("") 
                  : const Text("Once complete, press F5 to generate next word set.", style: _textStyleInfo),
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
                  Text(test.progress, style: subStyle,)
                  ),
                (test.typed.isEmpty) ? 
                const Text("Type anyway from screen to begin.", style: _textStyleInfo,):
                Expanded(child: 
                  SingleChildScrollView(child: 
                    Text(test.typed, style: _textStyleNormal),
                    controller: _typedScrollController,
                  ),
                ),
              ]
            ),
          )
        )),
        ...login
        ,
      ],
    );

    if (screenWidth >= breakpoint1) {
      final rightWidgets = <Widget>[];
      if (screenWidth >= breakpoint2) { 
        rightWidgets.add(separator);
        rightWidgets.add(Expanded(child: DetailedAnalysisPage(analysis: _analysis,)));
      }
      if (screenWidth >= breakpoint3) { 
        rightWidgets.add(separator);
        // rightWidgets.add(Expanded(child: HistoryPage(seriesList: records)));
      }      
      w = Row(
        children: [
          SizedBox(
            width: 240,
            child: appMenu,
          ),
          separator,
          Expanded(child: w), 
          ...rightWidgets,
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
