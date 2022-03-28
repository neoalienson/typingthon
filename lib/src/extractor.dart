import 'dart:async';
// ignore: unused_import
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:html/parser.dart' show parse;
import 'package:firebase_storage/firebase_storage.dart' show FirebaseStorage, ListResult;
import 'dart:convert';
import 'package:crypto/crypto.dart';

class Extractor {
  final FirebaseStorage firebaseStorage;

  Extractor(this.firebaseStorage);

  Future<String> loadXmlFromFireStore() async {
    ListResult result =
      await firebaseStorage.ref('texts').listAll();

    final list = result.items.toList(growable: false);
    list.shuffle();
    final path = list.first.fullPath;
    Uint8List bytes = (await firebaseStorage.ref(path).getData())!;

    return utf8.decode(bytes);
  }

  Future<List<String>> loadXmlFromFile(AssetBundle rootBundle, String path) async {
    return _processXml(await rootBundle.loadString(path));
  }

  Future<List<String>> loadXmlFromUrl(String uRL, [http.Client? client]) async {
    var c = (client == null) ? http.Client() : client;

    final response = await c.get(Uri.parse(uRL));
    if (response.statusCode == 200) {
      return _processXml(response.body);
    } else {
    }

    return [];
  }

  List<String> _processXml(String text) {
    final textXml = xml.XmlDocument.parse(text);
    final elements = textXml.findAllElements("content:encoded");
    var texts = <String>[];
    for (var element in elements) {
      final html = parse(element.text);
      // change non-breaking space ASCII 160 to space
      var text = html.documentElement!.text.replaceAll(RegExp(r'(\n){2,}'), "\n").trim()
        .replaceAll('“', '"').replaceAll('”', '"').replaceAll("’", "'").replaceAll("—", " - ")
        .replaceAll("‘", "'")
        .replaceAll("\r", "\n").replaceAll(String.fromCharCode(160), " ").replaceAll("…", "...");
      final lines = text.split("\n");
      text = "";
      for (var line in lines) {
        text += line.trim();
        text += "\n";
      }
      if (text.length < 500) {
        continue;
      }
      texts.add(text);
      _uploadToFireStore(text);
    }
     return texts;
  }

  void _uploadToFireStore(String text) {
    final filename = md5.convert(utf8.encode(text)).toString();
    firebaseStorage
      .ref('texts/$filename.txt')
      .putString(text);
  }

}