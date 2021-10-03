import 'package:flutter/material.dart';

class XProvider extends ChangeNotifier {
  int currentIndex = 0;

  changeCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
