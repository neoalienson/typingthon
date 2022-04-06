import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:typingthon/src/practice.dart';
import 'package:mockito/annotations.dart';
import 'package:clock/clock.dart';
import 'package:localstorage/localstorage.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'practice_test.mocks.dart';

@GenerateMocks([LocalStorage])
@GenerateMocks([FirebaseStorage])
@GenerateMocks([ListResult])
@GenerateMocks([Reference])
void main() {
  test('Safety', () {
    var practise = PracticeEngine();
    expect(practise.buildPreferred([]), []);
    expect(practise.build(PracticeModes.singleLeftHome), []);
  });

  test("Load while local storage is empty", () {
    final practice = PracticeEngine();
    final localStorage = MockLocalStorage();
    final firebaseStorage = MockFirebaseStorage();
    final listResult = MockListResult();
    final reference = MockReference();

    when(localStorage.ready).thenAnswer((_) async => true);
    when(localStorage.getItem("list")).thenReturn(null);
    when(localStorage.getItem("a")).thenAnswer((_) async => "text");
    when(firebaseStorage.ref('texts')).thenReturn(reference);
    when(reference.listAll()).thenAnswer((_) async => listResult);
    when(reference.fullPath).thenReturn("a");
    when(firebaseStorage.ref("a")).thenReturn(reference);
    when(reference.getData(10485760)).thenAnswer((_) async => Uint8List.fromList("b".codeUnits));
    when(listResult.items).thenReturn([reference]);

    withClock(
      Clock.fixed(DateTime(0)), () async {
        practice.loadXmlFromFireStore(localStorage, firebaseStorage);
        await untilCalled(localStorage.setItem("list", ""));
      }
    );
  });

  test("Load when last update is older than 1 day", () {
    final practice = PracticeEngine();
    final localStorage = MockLocalStorage();
    final firebaseStorage = MockFirebaseStorage();
    final listResult = MockListResult();
    final reference = MockReference();

    when(localStorage.ready).thenAnswer((_) async => true);
    when(localStorage.getItem("list")).thenReturn({"last_update":"2022-01-01 00:00:00.000"});
    when(localStorage.getItem("a")).thenAnswer((_) async => "text");
    when(firebaseStorage.ref('texts')).thenReturn(reference);
    when(reference.listAll()).thenAnswer((_) async => listResult);
    when(reference.fullPath).thenReturn("a");
    when(firebaseStorage.ref("a")).thenReturn(reference);
    when(reference.getData(10485760)).thenAnswer((_) async => Uint8List.fromList("b".codeUnits));
    when(listResult.items).thenReturn([reference]);

    withClock(
      Clock.fixed(DateTime(2022, 2)), () async {
        practice.loadXmlFromFireStore(localStorage, firebaseStorage);
        await untilCalled(localStorage.setItem("list", ""));
      }
    );
  });

  test("Use cache when last update is less than 1 day old", () {
    final practice = PracticeEngine();
    final localStorage = MockLocalStorage();
    final firebaseStorage = MockFirebaseStorage();
    final reference = MockReference();

    when(localStorage.ready).thenAnswer((_) async => true);
    when(localStorage.getItem("list")).thenReturn({
      "last_update":"0000-01-01 02:27:54.067",
      "list":[
        "a"
      ]});
    when(localStorage.getItem("a")).thenAnswer((_) async => "text");
    when(reference.fullPath).thenReturn("a");
    when(firebaseStorage.ref("a")).thenReturn(reference);
    when(reference.getData(10485760)).thenAnswer((_) async => Uint8List.fromList("b".codeUnits));

    withClock(
      Clock.fixed(DateTime(0)), () async {
        practice.loadXmlFromFireStore(localStorage, firebaseStorage);
        await untilCalled(localStorage.setItem("list", ""));
      }
    );
  });
}
