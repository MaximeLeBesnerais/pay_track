import 'package:flutter/material.dart';

Widget mCard(List<Widget> mChildren) {
  final cardItem = Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: mChildren
    ),
    ),
  );
  return cardItem;
}
