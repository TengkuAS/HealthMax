import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // ==========================================
  // 1. PREMIUM LIGHT THEME
  // ==========================================
  static final lightTheme = ThemeData(
    fontFamily: "LexendExaNormal", 
    scaffoldBackgroundColor: const Color(0xFFF8F9FA), 
    primaryColor: const Color(0xFF8E33FF),            
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF8E33FF),
      surface: Colors.white,           
      onSurface: Colors.black87,       
      secondary: Color(0xFFF8F9FA),    
    ),
    cardColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.black87),
    dividerColor: Colors.grey.shade200,
  );

  // ==========================================
  // 2. PREMIUM DARK THEME
  // ==========================================
  static final darkTheme = ThemeData(
    fontFamily: "LexendExaNormal", 
    scaffoldBackgroundColor: const Color(0xFF09090B), 
    primaryColor: const Color(0xFF8E33FF),            
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF8E33FF),
      surface: Color(0xFF18181B),      
      onSurface: Colors.white,         
      secondary: Color(0xFF2C2C2E),    
    ),
    cardColor: const Color(0xFF18181B),
    iconTheme: const IconThemeData(color: Colors.white),
    dividerColor: Colors.white10,
  );
}