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

  final d = const BoxDecoration(color: Colors.blue,);

  Widget _buildDrawerHeader(String text) {
    return SizedBox(height: 60, child: DrawerHeader(child: Text(text), decoration: d,),);
  }

  @override
  Widget build(BuildContext context) {
    var items = <Widget>[];

    items.add(_buildDrawerHeader("Layout"));

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

    items.add(_buildDrawerHeader("Practise"));

    for (var k in PracticeMode.values) {
      if (k == PracticeMode.minutes5 || !practisModeNames.containsKey(k)) {
        continue;
      }
      items.add(
        ListTile(
          title: Text(practisModeNames[k]!),
          onTap: () {
            if (_hambgerMenuMode) {
              Navigator.pop(context);
            }
          },
          selected: _currentPracticeMode == k,
        )
      );
    }

    items.add(_buildDrawerHeader("Benchmark"));

    items.add(
      ListTile(
        title: Text(practisModeNames[PracticeMode.minutes5]!),
        onTap: () {
          if (_hambgerMenuMode) {
            Navigator.pop(context);
          }
            _on5minTest();
          },
        selected: _currentPracticeMode == PracticeMode.minutes5,
      )
    );

    items.add(_buildDrawerHeader("Settings"));

    return ListView(
          padding: EdgeInsets.zero,
          children: 
            items,
    );
  }

}