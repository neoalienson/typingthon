import 'package:flutter_test/flutter_test.dart';
import 'package:typingthon/src/practice.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

@GenerateMocks([http.Client]) 
void main() {
  test('Safety', () {
    var practise = PracticeEngine();
    expect(practise.buildPreferred([]), []);
    expect(practise.build(PracticeModes.singleLeftHome), []);
  });
}
