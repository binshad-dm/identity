import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  final SharedPreferences prefs;

  LocaleCubit(this.prefs) : super(_loadInitialLocale(prefs));

  static Locale _loadInitialLocale(SharedPreferences prefs) {
    final languageCode = prefs.getString('language_code') ?? 'en';
    return Locale(languageCode);
  }

  void changeLocale(String languageCode) {
    prefs.setString('language_code', languageCode);
    emit(Locale(languageCode));
  }
}
