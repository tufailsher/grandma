import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/app_theme.dart';

class HomeController extends ChangeNotifier {
  Color _currentColor = AppColors.primary;
  double _currentFontSize = 24.0;

  Color get currentColor => _currentColor;
  double get currentFontSize => _currentFontSize;

  void updateColor(Color color) {
    _currentColor = color;
    notifyListeners();
  }

  void updateFontSize(double newSize) {
    _currentFontSize = newSize;
    notifyListeners();
  }
}
