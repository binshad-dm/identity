import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

import 'platform_iframe_stub.dart'
    if (dart.library.js_interop) 'platform_iframe_web.dart';
import 'platform_webview.dart';
import 'platform_webview_windows.dart';

class PlatformUrlViewer extends StatelessWidget {
  final String url;

  const PlatformUrlViewer({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return buildIFrame(url);
    } else if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      return PlatformWebView(url: url);
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      return PlatformWebViewWindows(url: url);
    } else {
      return Center(
        child: Text(
          'WebView is not supported on this platform.\nTarget URL: $url',
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
