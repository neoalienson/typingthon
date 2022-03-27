import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typingthon/src/extractor.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'extractor_test.mocks.dart';

class FakeUploadTask extends Fake implements UploadTask {}

@GenerateMocks([http.Client])
@GenerateMocks([FirebaseStorage])
@GenerateMocks([Reference])
@GenerateMocks([UploadTask])
void main() {
  test("Load content", () async {
    final firebaseStorage = MockFirebaseStorage();
    final reference = MockReference();
    final extractor = Extractor(firebaseStorage);
    final client = MockClient();
    final content = await File('test_resources/technologyreview.txt').readAsString();
    final expected = await File('test_resources/technologyreview_output.txt').readAsString();
    when(
      client.get(Uri.parse('https://www.technologyreview.com/feed/')))
      .thenAnswer((_) async =>
        http.Response(content, 200, headers: {
          "content-type": "application/json; charset=utf-8",
        })
    );
    when(firebaseStorage.ref(any)).thenReturn(reference);
    when(reference.putString(any)).thenAnswer((realInvocation) => FakeUploadTask());
    var respond = await extractor.loadXmlFromUrl('https://www.technologyreview.com/feed/', client);  
    // File("output.txt").writeAsStringSync(respond.join("\n"));
      
    expect(respond.join("\n"), expected);
  });
}
