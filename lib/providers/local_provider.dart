import 'package:flutter/material.dart';
import 'package:pest_detection/localization/app_localization.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners();
    }
  }

  String get(String key) {
    return translations[_locale.languageCode]?[key] ?? key;
  }
}