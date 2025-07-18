import 'package:flutter/material.dart';

class MainState extends ChangeNotifier {
  int _pageIndex = 0;
  bool _navigationBarVisible = true;

  int get pageIndex => _pageIndex;
  bool get navigationBarVisible => _navigationBarVisible;

  void updatePageIndex(int pageIndex) {
    _pageIndex = pageIndex;
    notifyListeners();
  }

  void showNavigationBar() {
    _navigationBarVisible = true;
    notifyListeners();
  }

  void hideNavigationBar() {
    _navigationBarVisible = false;
    notifyListeners();
  }
}
