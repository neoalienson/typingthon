import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typingthon/keyboard.dart';

void main() {
  final grey = Color.fromARGB(255, Colors.grey.red, Colors.grey.green, Colors.grey.blue);
  const yellow = Color.fromARGB(255, 255, 255, 0);
  test('Normalise color inversed', () {
    var k = Keyboard(title: "", map: const {}, max: 100, colorMultipler: Colors.white);
    expect(k.colorNormalise(0, true), Colors.white);
    expect(k.colorNormalise(100, true), Colors.white);
  });

  test('Normalise based color inversed', () {
    var k = Keyboard(title: "", map: const {}, max: 100, colorMultipler: Colors.white, colorBase: Colors.grey,);
    expect(k.colorNormalise(0, true), Colors.white);
    expect(k.colorNormalise(100, true), Colors.white);    
  });

  test('Normalise color inversed', () {
    var k = Keyboard(title: "", map: const {}, max: 100, colorMultipler: yellow);
    expect(k.colorNormalise(0, true), Colors.white);
    expect(k.colorNormalise(100, true), yellow);
  });

  test('Normalise based color inversed', () {
    var k = Keyboard(title: "", map: const {}, max: 100, colorMultipler: yellow, colorBase: Colors.grey,);
    expect(k.colorNormalise(0, true), Colors.white);
    expect(k.colorNormalise(100, true), Color.fromARGB(255, 255, 255, grey.blue));    
  });

  test('Normalise color', () {
    var k = Keyboard(title: "", map: const {}, max: 100, colorMultipler: Colors.white);
    expect(k.colorNormalise(0, false), Colors.black);
    expect(k.colorNormalise(100, false), Colors.white);    
  });

  test('Normalise based color', () {
    var k = Keyboard(title: "", map: const {}, max: 100, colorMultipler: Colors.white, colorBase: Colors.grey,);
    expect(k.colorNormalise(0, false), grey);
    expect(k.colorNormalise(100, false), Colors.white);    
  });
}