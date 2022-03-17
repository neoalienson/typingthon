import 'package:flutter/material.dart';
import 'package:typingthon/src/analysis.dart';
import 'package:typingthon/src/layout.dart';
import 'package:typingthon/src/practice.dart';

import 'detailed_analysis_page.dart';

class AppMenu extends StatelessWidget {
  final bool _hambgerMenuMode;
  final Layout _curreatLayout;
  final PracticeMode _currentPracticeMode;
  final Analysis _analysis;
  final Function _on5minTest;

  const AppMenu({Key? key,
    required bool hambgerMenuMode,
    required Layout curreatLayout,
    required PracticeMode currentPracticeMode,
    required Analysis analysis,
    required Function on5minTest
  }) : 
    _hambgerMenuMode = hambgerMenuMode,
    _curreatLayout = curreatLayout,
    _currentPracticeMode = currentPracticeMode,
    _analysis = analysis,
    _on5minTest = on5minTest,
    super(key: key);

  @override
  Widget build(BuildContext context) {
  var items = <Widget>[];
    var d = const BoxDecoration(color: Colors.blue,);

    items.add(DrawerHeader(child: const Text('Layout'), decoration: d,),);


    for (var k in layouts.keys) {
      items.add(
        ListTile(
          title: Text(layouts[k]!.title),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailedAnalysisPage(analysis: _analysis,)),
                );
          },
          selected: layouts[k] == _curreatLayout,
        )
      );
    }

    items.add(DrawerHeader(child: const Text('Practise'), decoration: d,),);

    for (var k in practiseModes.keys) {
      items.add(
        ListTile(
          title: Text(k),
          onTap: () {
            if (_hambgerMenuMode) {
              Navigator.pop(context);
            }
            if (practiseModes[k] == PracticeMode.minutes5) {
              _on5minTest();
            }
          },
          selected: _currentPracticeMode == practiseModes[k],
        )
      );
    }

    items.add(DrawerHeader(child: const Text('Settings'), decoration: d,),);

    return ListView(
          padding: EdgeInsets.zero,
          children: 
            items,
    );
  }

}