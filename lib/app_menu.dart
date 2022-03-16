import 'package:flutter/material.dart';
import 'package:typingthon/src/analysis.dart';
import 'package:typingthon/src/layout.dart';
import 'package:typingthon/src/practice.dart';

import 'detailed_analysis_page.dart';

class AppMenu extends StatelessWidget {
  final bool hambgerMenuMode;
  final Layout curreatLayout;
  final PracticeMode currentPracticeMode;
  final Analysis analysis;
  final Function on5minTest;

  const AppMenu({Key? key,
    required this.hambgerMenuMode,
    required this.curreatLayout,
    required this.currentPracticeMode,
    required this.analysis,
    required this.on5minTest
  }) : super(key: key);

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
                MaterialPageRoute(builder: (context) => DetailedAnalysisPage(analysis: analysis,)),
                );
          },
          selected: layouts[k] == curreatLayout,
        )
      );
    }

    items.add(DrawerHeader(child: const Text('Practise'), decoration: d,),);

    for (var k in practiseModes.keys) {
      items.add(
        ListTile(
          title: Text(k),
          onTap: () {
            if (hambgerMenuMode) {
              Navigator.pop(context);
            }
            if (practiseModes[k] == PracticeMode.minutes5) {
              on5minTest();
            }
          },
          selected: currentPracticeMode == practiseModes[k],
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