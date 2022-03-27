// Mocks generated by Mockito 5.1.0 from annotations
// in typingthon/test/practice_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i7;
import 'dart:io' as _i9;
import 'dart:typed_data' as _i8;

import 'package:firebase_core/firebase_core.dart' as _i3;
import 'package:firebase_storage/firebase_storage.dart' as _i4;
import 'package:firebase_storage_platform_interface/firebase_storage_platform_interface.dart'
    as _i5;
import 'package:flutter/foundation.dart' as _i2;
import 'package:localstorage/localstorage.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeValueNotifier_0<T> extends _i1.Fake implements _i2.ValueNotifier<T> {
}

class _FakeFirebaseApp_1 extends _i1.Fake implements _i3.FirebaseApp {}

class _FakeDuration_2 extends _i1.Fake implements Duration {}

class _FakeReference_3 extends _i1.Fake implements _i4.Reference {}

class _FakeFirebaseStorage_4 extends _i1.Fake implements _i4.FirebaseStorage {}

class _FakeFullMetadata_5 extends _i1.Fake implements _i5.FullMetadata {}

class _FakeListResult_6 extends _i1.Fake implements _i4.ListResult {}

class _FakeUploadTask_7 extends _i1.Fake implements _i4.UploadTask {}

class _FakeDownloadTask_8 extends _i1.Fake implements _i4.DownloadTask {}

/// A class which mocks [LocalStorage].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalStorage extends _i1.Mock implements _i6.LocalStorage {
  MockLocalStorage() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.ValueNotifier<Error> get onError => (super.noSuchMethod(
      Invocation.getter(#onError),
      returnValue: _FakeValueNotifier_0<Error>()) as _i2.ValueNotifier<Error>);
  @override
  set onError(_i2.ValueNotifier<Error>? _onError) =>
      super.noSuchMethod(Invocation.setter(#onError, _onError),
          returnValueForMissingStub: null);
  @override
  _i7.Future<bool> get ready => (super.noSuchMethod(Invocation.getter(#ready),
      returnValue: Future<bool>.value(false)) as _i7.Future<bool>);
  @override
  set ready(_i7.Future<bool>? _ready) =>
      super.noSuchMethod(Invocation.setter(#ready, _ready),
          returnValueForMissingStub: null);
  @override
  _i7.Stream<Map<String, dynamic>> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<Map<String, dynamic>>.empty())
          as _i7.Stream<Map<String, dynamic>>);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  dynamic getItem(String? key) =>
      super.noSuchMethod(Invocation.method(#getItem, [key]));
  @override
  _i7.Future<void> setItem(String? key, dynamic value,
          [Object Function(Object)? toEncodable]) =>
      (super.noSuchMethod(
          Invocation.method(#setItem, [key, value, toEncodable]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> deleteItem(String? key) =>
      (super.noSuchMethod(Invocation.method(#deleteItem, [key]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> clear() => (super.noSuchMethod(Invocation.method(#clear, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
}

/// A class which mocks [FirebaseStorage].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirebaseStorage extends _i1.Mock implements _i4.FirebaseStorage {
  MockFirebaseStorage() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.FirebaseApp get app => (super.noSuchMethod(Invocation.getter(#app),
      returnValue: _FakeFirebaseApp_1()) as _i3.FirebaseApp);
  @override
  set app(_i3.FirebaseApp? _app) =>
      super.noSuchMethod(Invocation.setter(#app, _app),
          returnValueForMissingStub: null);
  @override
  String get bucket =>
      (super.noSuchMethod(Invocation.getter(#bucket), returnValue: '')
          as String);
  @override
  set bucket(String? _bucket) =>
      super.noSuchMethod(Invocation.setter(#bucket, _bucket),
          returnValueForMissingStub: null);
  @override
  Duration get maxOperationRetryTime =>
      (super.noSuchMethod(Invocation.getter(#maxOperationRetryTime),
          returnValue: _FakeDuration_2()) as Duration);
  @override
  Duration get maxUploadRetryTime =>
      (super.noSuchMethod(Invocation.getter(#maxUploadRetryTime),
          returnValue: _FakeDuration_2()) as Duration);
  @override
  Duration get maxDownloadRetryTime =>
      (super.noSuchMethod(Invocation.getter(#maxDownloadRetryTime),
          returnValue: _FakeDuration_2()) as Duration);
  @override
  Map<dynamic, dynamic> get pluginConstants =>
      (super.noSuchMethod(Invocation.getter(#pluginConstants),
          returnValue: <dynamic, dynamic>{}) as Map<dynamic, dynamic>);
  @override
  _i4.Reference ref([String? path]) =>
      (super.noSuchMethod(Invocation.method(#ref, [path]),
          returnValue: _FakeReference_3()) as _i4.Reference);
  @override
  _i4.Reference refFromURL(String? url) =>
      (super.noSuchMethod(Invocation.method(#refFromURL, [url]),
          returnValue: _FakeReference_3()) as _i4.Reference);
  @override
  void setMaxOperationRetryTime(Duration? time) =>
      super.noSuchMethod(Invocation.method(#setMaxOperationRetryTime, [time]),
          returnValueForMissingStub: null);
  @override
  void setMaxUploadRetryTime(Duration? time) =>
      super.noSuchMethod(Invocation.method(#setMaxUploadRetryTime, [time]),
          returnValueForMissingStub: null);
  @override
  void setMaxDownloadRetryTime(Duration? time) =>
      super.noSuchMethod(Invocation.method(#setMaxDownloadRetryTime, [time]),
          returnValueForMissingStub: null);
  @override
  _i7.Future<void> useEmulator({String? host, int? port}) =>
      (super.noSuchMethod(
          Invocation.method(#useEmulator, [], {#host: host, #port: port}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> useStorageEmulator(String? host, int? port) =>
      (super.noSuchMethod(Invocation.method(#useStorageEmulator, [host, port]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
}

/// A class which mocks [ListResult].
///
/// See the documentation for Mockito's code generation for more information.
class MockListResult extends _i1.Mock implements _i4.ListResult {
  MockListResult() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.FirebaseStorage get storage =>
      (super.noSuchMethod(Invocation.getter(#storage),
          returnValue: _FakeFirebaseStorage_4()) as _i4.FirebaseStorage);
  @override
  List<_i4.Reference> get items =>
      (super.noSuchMethod(Invocation.getter(#items),
          returnValue: <_i4.Reference>[]) as List<_i4.Reference>);
  @override
  List<_i4.Reference> get prefixes =>
      (super.noSuchMethod(Invocation.getter(#prefixes),
          returnValue: <_i4.Reference>[]) as List<_i4.Reference>);
}

/// A class which mocks [Reference].
///
/// See the documentation for Mockito's code generation for more information.
class MockReference extends _i1.Mock implements _i4.Reference {
  MockReference() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.FirebaseStorage get storage =>
      (super.noSuchMethod(Invocation.getter(#storage),
          returnValue: _FakeFirebaseStorage_4()) as _i4.FirebaseStorage);
  @override
  String get bucket =>
      (super.noSuchMethod(Invocation.getter(#bucket), returnValue: '')
          as String);
  @override
  String get fullPath =>
      (super.noSuchMethod(Invocation.getter(#fullPath), returnValue: '')
          as String);
  @override
  String get name =>
      (super.noSuchMethod(Invocation.getter(#name), returnValue: '') as String);
  @override
  _i4.Reference get root => (super.noSuchMethod(Invocation.getter(#root),
      returnValue: _FakeReference_3()) as _i4.Reference);
  @override
  _i4.Reference child(String? path) =>
      (super.noSuchMethod(Invocation.method(#child, [path]),
          returnValue: _FakeReference_3()) as _i4.Reference);
  @override
  _i7.Future<void> delete() =>
      (super.noSuchMethod(Invocation.method(#delete, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<String> getDownloadURL() =>
      (super.noSuchMethod(Invocation.method(#getDownloadURL, []),
          returnValue: Future<String>.value('')) as _i7.Future<String>);
  @override
  _i7.Future<_i5.FullMetadata> getMetadata() => (super.noSuchMethod(
          Invocation.method(#getMetadata, []),
          returnValue: Future<_i5.FullMetadata>.value(_FakeFullMetadata_5()))
      as _i7.Future<_i5.FullMetadata>);
  @override
  _i7.Future<_i4.ListResult> list([_i5.ListOptions? options]) =>
      (super.noSuchMethod(Invocation.method(#list, [options]),
              returnValue: Future<_i4.ListResult>.value(_FakeListResult_6()))
          as _i7.Future<_i4.ListResult>);
  @override
  _i7.Future<_i4.ListResult> listAll() =>
      (super.noSuchMethod(Invocation.method(#listAll, []),
              returnValue: Future<_i4.ListResult>.value(_FakeListResult_6()))
          as _i7.Future<_i4.ListResult>);
  @override
  _i7.Future<_i8.Uint8List?> getData([int? maxSize = 10485760]) =>
      (super.noSuchMethod(Invocation.method(#getData, [maxSize]),
              returnValue: Future<_i8.Uint8List?>.value())
          as _i7.Future<_i8.Uint8List?>);
  @override
  _i4.UploadTask putData(_i8.Uint8List? data,
          [_i5.SettableMetadata? metadata]) =>
      (super.noSuchMethod(Invocation.method(#putData, [data, metadata]),
          returnValue: _FakeUploadTask_7()) as _i4.UploadTask);
  @override
  _i4.UploadTask putBlob(dynamic blob, [_i5.SettableMetadata? metadata]) =>
      (super.noSuchMethod(Invocation.method(#putBlob, [blob, metadata]),
          returnValue: _FakeUploadTask_7()) as _i4.UploadTask);
  @override
  _i4.UploadTask putFile(_i9.File? file, [_i5.SettableMetadata? metadata]) =>
      (super.noSuchMethod(Invocation.method(#putFile, [file, metadata]),
          returnValue: _FakeUploadTask_7()) as _i4.UploadTask);
  @override
  _i4.UploadTask putString(String? data,
          {_i5.PutStringFormat? format = _i5.PutStringFormat.raw,
          _i5.SettableMetadata? metadata}) =>
      (super.noSuchMethod(
          Invocation.method(
              #putString, [data], {#format: format, #metadata: metadata}),
          returnValue: _FakeUploadTask_7()) as _i4.UploadTask);
  @override
  _i7.Future<_i5.FullMetadata> updateMetadata(_i5.SettableMetadata? metadata) =>
      (super.noSuchMethod(Invocation.method(#updateMetadata, [metadata]),
              returnValue:
                  Future<_i5.FullMetadata>.value(_FakeFullMetadata_5()))
          as _i7.Future<_i5.FullMetadata>);
  @override
  _i4.DownloadTask writeToFile(_i9.File? file) =>
      (super.noSuchMethod(Invocation.method(#writeToFile, [file]),
          returnValue: _FakeDownloadTask_8()) as _i4.DownloadTask);
}
