import 'dart:math';

import 'package:flutter/material.dart';
import 'package:overlap_snapping_sliver/overlap_snapping_scroll_widget.dart';

List<Widget> buildBoxes(int count) {
  assert(count > 0);
  List<Widget> boxes = [];

  for (int i = 0; i < count; i++) {
    int height = Random().nextInt(250) + 250;

    boxes.add(Container(
      height: height.toDouble(),
      decoration: BoxDecoration(
          color: Color.fromRGBO(Random().nextInt(255), Random().nextInt(255),
              Random().nextInt(255), 1)),
    ));
  }

  return boxes;
}

void main() {
  runApp(Scaffold(
    appBar: AppBar(
      title: const Text("Test the overlap display"),
    ),
    body: OverlapScroll(
      staticPart: Container(
        height: 500,
      ),
      slivers: [],
    ),
  ));
}
