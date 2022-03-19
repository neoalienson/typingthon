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
  final Function _onMinTest;

  const AppMenu({Key? key,
    required bool hambgerMenuMode,
    required Layout curreatLayout,
    required PracticeMode currentPracticeMode,
    required Analysis analysis,
    required Function onMinTest,
  }) : 
    _hambgerMenuMode = hambgerMenuMode,
    _curreatLayout = curreatLayout,
    _currentPracticeMode = currentPracticeMode,
    _analysis = analysis,
    _onMinTest = onMinTest,
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

    for (var v in practiceModes.values) {
      if (v.isTimed) {
        continue;
      }
      items.add(
        ListTile(
          title: Text(v.name),
          onTap: () {
            if (_hambgerMenuMode) {
              Navigator.pop(context);
            }
          },
          selected: _currentPracticeMode == v,
        )
      );
    }

    items.add(_buildDrawerHeader("Benchmark"));

    for (var v in practiceModes.values) {
      if (!v.isTimed) {
        continue;
      }
      items.add(
        ListTile(
          title: Text(v.name),
          onTap: () {
            if (_hambgerMenuMode) {
              Navigator.pop(context);
            }
            _onMinTest(v);
          },
          selected: _currentPracticeMode == v,
        )
      );
    }

    items.add(_buildDrawerHeader("Settings"));

    return ListView(
          padding: EdgeInsets.zero,
          children: 
            items,
    );
  }

}