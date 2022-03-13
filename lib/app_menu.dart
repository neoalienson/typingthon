import 'package:flutter/material.dart';
import 'package:typingthon/src/analysis.dart';
import 'package:typingthon/src/layout.dart';
import 'package:typingthon/src/practice.dart';

import 'history_page.dart';

class AppMenu extends StatelessWidget {
  final Layout curreatLayout;
  final PracticeMode currentPracticeMode;
  final Analysis analysis;

  const AppMenu({Key? key,
    required this.curreatLayout,
    required this.currentPracticeMode,
    required this.analysis,
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
                MaterialPageRoute(builder: (context) => HistoryPage(analysis: analysis,)),
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
            Navigator.pop(context);
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