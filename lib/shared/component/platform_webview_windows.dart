import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';

class PlatformWebViewWindows extends StatefulWidget {
  final String url;

  const PlatformWebViewWindows({super.key, required this.url});

  @override
  State<PlatformWebViewWindows> createState() => _PlatformWebViewWindowsState();
}

class _PlatformWebViewWindowsState extends State<PlatformWebViewWindows> {
  final _controller = WebviewController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initWebview();
  }

  Future<void> _initWebview() async {
    try {
      await _controller.initialize();
      await _controller.setBackgroundColor(Colors.transparent);
      await _controller.loadUrl(widget.url);
      if (!mounted) return;
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('WebView init error: $e');
    }
  }

  @override
  void didUpdateWidget(covariant PlatformWebViewWindows oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url && _isInitialized) {
      _controller.loadUrl(widget.url);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Webview(
      _controller,
      permissionRequested: _onPermissionRequested,
    );
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(
      String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    return WebviewPermissionDecision.allow;
  }
}
