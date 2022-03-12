import 'package:typingthon/src/layout.dart';

var qwertyLayout = Layout(
  "QWERTY",
  true,
  KeyRow.r2,
  KeyRowKeys(KeyRow.r4, [], []),
  KeyRowKeys(KeyRow.r3, ['q','w','e','r','t'], ['y','u','i','o','p']),
  KeyRowKeys(KeyRow.r2, ['a','s','d','f','g'], ['h','j','k','l',';']),
  KeyRowKeys(KeyRow.r1, ['z','x','c','v','b'], ['n','m',',','.','/']),
);
