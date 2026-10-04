import 'package:flutter/material.dart';

String getCurrentLang(BuildContext context) {
  return Localizations.localeOf(context).languageCode;
}

extension LocalizedString on Map<String, String> {
  String getLocalizedText(BuildContext context) {
    final lang = getCurrentLang(context);
    return this[lang] ?? this['en'] ?? 'Missing';
  }
}

extension LocalizedList on Map<String, List<String>> {
  List<String> get(BuildContext context) {
    final lang = getCurrentLang(context);
    return this[lang] ?? this['en'] ?? [];
  }
}
