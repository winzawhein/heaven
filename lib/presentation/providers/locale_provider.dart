import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  // Pass your application's default locale here
  LocaleNotifier() : super(const Locale('en'));

  void changeLocale(String languageCode) {
    state = Locale(languageCode);
  }
}