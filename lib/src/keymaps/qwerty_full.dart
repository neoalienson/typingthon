import 'package:typingthon/src/keymap.dart';

var qwertyFullKeyMap = KeyMap(true,
  KeyRow.r2,
  KeyRowKeys(KeyRow.r4, ['1','2','3','4','5'], ['6','7','8','9','0']),
  KeyRowKeys(KeyRow.r3, ['q','w','e','r','t'], ['y','u','i','o','p']),
  KeyRowKeys(KeyRow.r2, ['a','s','d','f','g'], ['h','j','k','l',';']),
  KeyRowKeys(KeyRow.r1, ['z','x','c','v','b'], ['n','m',',','.','/']),
);
