import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  
  Locale _currentLocale = const Locale('en', 'US');
  
  Locale get currentLocale => _currentLocale;
  
  final Map<String, Map<String, String>> _languages = {
    'en_US': {
      'code': 'en',
      'country': 'US',
      'name': 'English (US)',
      'flag': '🇺🇸',
    },
    'es_ES': {
      'code': 'es',
      'country': 'ES', 
      'name': 'Español',
      'flag': '🇪🇸',
    },
    'fr_FR': {
      'code': 'fr',
      'country': 'FR',
      'name': 'Français',
      'flag': '🇫🇷',
    },
    'ar_SA': {
      'code': 'ar',
      'country': 'SA',
      'name': 'العربية',
      'flag': '🇸🇦',
    },
    'zh_CN': {
      'code': 'zh',
      'country': 'CN',
      'name': '中文',
      'flag': '🇨🇳',
    },
  };
  
  Map<String, Map<String, String>> get languages => _languages;
  
  String get currentLanguageKey {
    return '${_currentLocale.languageCode}_${_currentLocale.countryCode}';
  }
  
  String get currentLanguageName {
    return _languages[currentLanguageKey]?['name'] ?? 'English (US)';
  }
  
  String get currentLanguageFlag {
    return _languages[currentLanguageKey]?['flag'] ?? '🇺🇸';
  }
  
  Future<void> initLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey) ?? 'en_US';
    
    final langData = _languages[savedLanguage];
    if (langData != null) {
      _currentLocale = Locale(langData['code']!, langData['country']!);
      notifyListeners();
    }
  }
  

  Future<void> changeLanguage(String languageKey) async {
    final langData = _languages[languageKey];
    if (langData != null) {
      _currentLocale = Locale(langData['code']!, langData['country']!);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageKey);
      
      notifyListeners();
    }
  }
}