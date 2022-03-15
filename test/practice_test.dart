import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:typingthon/src/practice.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'practice_test.mocks.dart';

@GenerateMocks([http.Client]) 
void main() {
  test('Safety', () {
    var practise = PracticeGenerator();
    expect(practise.buildPreferred([]), []);
    expect(practise.build(PracticeMode.singleLeftHome), []);
  });

  test("Load content", () async {
    var practise = PracticeGenerator();
    final client = MockClient();

    final content = await File('test_resources/technologyreview.txt').readAsString();
    final expected = await File('test_resources/technologyreview_output.txt').readAsString();

    when(client
        .get(Uri.parse('https://www.technologyreview.com/feed/')))
      .thenAnswer((_) async =>
        http.Response(content, 200, headers: {
          "content-type": "application/json; charset=utf-8",
          }));
      expect(await practise.loadXmlFromUrl('https://www.technologyreview.com/feed/', client), expected);
  });
}
