import 'package:flutter/material.dart';
import 'dart:ui_web' as ui_web;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

final Set<String> _registeredViewTypes = {};

Widget buildIFrame(String url) {
  final String viewType = 'iframeElement_$url';
  
  // Register the view factory for the iframe only if it hasn't been registered yet.
  if (!_registeredViewTypes.contains(viewType)) {
    ui_web.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) => html.IFrameElement()
        ..src = url
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%',
    );
    _registeredViewTypes.add(viewType);
  }
  
  return HtmlElementView(viewType: viewType);
}

