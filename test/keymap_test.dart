import 'package:flutter_test/flutter_test.dart';
import 'package:typingthon/src/keymap.dart';

void main() {
  test('Iris', () {
    var keyMap = KeyMap(true,
      KeyRow.r2,
      KeyRowKeys(KeyRow.r4, [], []),
      KeyRowKeys(KeyRow.r3, ['q','g','m','l','w'], ['y','f','u','b',';']),
      KeyRowKeys(KeyRow.r2, ['d','s','t','n','r'], ['i','a','e','o','h']),
      KeyRowKeys(KeyRow.r1, ['z','x','c','v','j'], ['k','p',',','.','/']),
    );

    expect(keyMap.rows.length, 4);
    expect(keyMap.rows[keyMap.homeRow]?.left, ['d','s','t','n','r']);
    expect(keyMap.rows[keyMap.homeRow]?.right, ['i','a','e','o','h']);
    expect(keyMap.keys.length, 30);
    expect(keyMap.keys['j']?['row'], KeyRow.r1);
    expect(keyMap.keys['j']?['hand'], KeyHand.left);
  });
}
