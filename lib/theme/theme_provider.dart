import 'package:flutter/material.dart';
import 'package:isarcrud/theme/theme.dart';

class ThemeProvider extends ChangeNotifier {
  // initially, theme is light mode
  ThemeData _themeData = lightMode;

  // getter method to access the theme from other part of the code
  ThemeData get themeData => _themeData;

  // getter method to see if we are in dark mode or not
  bool get isDarkMode => _themeData == darkMode;

  // setter method to set the new theme
  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }

  // we will use this toogle in a switch later
  void toogleTheme(){
    if (_themeData ==  lightMode){
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}