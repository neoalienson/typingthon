import 'keymaps/qgmlw.dart';
import 'keymaps/qwerty.dart';
import 'keymaps/qwerty_full.dart';
final keyMapList = [
  qgmlwKeyMap,
  qwertyKeyMap,
  qwertyFullKeyMap,
  ];

class KeyRowKeys {
  final KeyRow row;
  final List<String> left;
  final List<String> right;

  KeyRowKeys(this.row, this.left, this.right);
}

enum KeyHand {
  left,
  right,
}

enum KeyRow {
  r4,
  r3,
  r2,
  r1
}

class KeyMap {
  final bool isSplit;
  final KeyRowKeys r1;
  final KeyRowKeys r2;
  final KeyRowKeys r3;
  final KeyRowKeys r4;
  final KeyRow homeRow;
  final keys = <String, Map>{};
  var rows = <KeyRow, KeyRowKeys>{};

  KeyMap(this.isSplit, this.homeRow, this.r4, this.r3, this.r2, this.r1) {
    rows = {
      KeyRow.r4: r4,
      KeyRow.r3: r3,
      KeyRow.r2: r2,
      KeyRow.r1: r1,
    };

    for (var r in rows.keys) {
      for (var k in rows[r]!.left) {
        keys[k] = {'row': r, 'hand': KeyHand.left};
      }
      for (var k in rows[r]!.right) {
        keys[k] = {'row': r, 'hand': KeyHand.right};
      }
    }
  }
}

var keyMap = keyMapList[0];