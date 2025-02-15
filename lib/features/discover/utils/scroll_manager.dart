import 'package:flutter/material.dart';

class ScrollManager {
  static final ScrollController horizontalScrollController = ScrollController();

  static void scrollToIndex(int index, double itemWidth) {
    if (!horizontalScrollController.hasClients) return;
    
    horizontalScrollController.animateTo(
      index * itemWidth,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
