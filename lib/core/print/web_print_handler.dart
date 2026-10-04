// ignore_for_file: use_build_context_synchronously
// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
// This file is conditionally compiled only on web targets via print_handler_factory.dart.

import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:identity/core/shared/snackbar.dart';
import 'i_print_handler.dart';
import 'dart:html' as html;

class PrintHandlerImpl implements PrintHandler {
  @override
  Future<void> printPdf(
    Uint8List pdfData,
    String name,
    BuildContext context,
  ) async {
    if (kIsWeb) {
      try {
        final base64Pdf = base64Encode(pdfData);

        final htmlContent =
            '''
        <html>
          <head><title>$name</title></head>
          <body style="margin:0" onload="print(); window.close();">
            <embed src="data:application/pdf;base64,$base64Pdf"
                   type="application/pdf"
                   width="100%" height="100%">
          </body>
        </html>
        ''';

        final blob = html.Blob([htmlContent], 'text/html');
        final url = html.Url.createObjectUrlFromBlob(blob);

        html.window.open(url, '_blank');
        html.Url.revokeObjectUrl(url);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Web print failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      showCustomSnackBar(
        context: context,
        message: "Printing is only supported on Web Platform",
        type: SnackBarType.alert,
      );
    }
  }

  @override
  Future<void> printHtml(
    String htmlContent,
    String name,
    BuildContext context,
  ) async {
    if (kIsWeb) {
      try {
        // 1. Inject the auto-print script into the HTML (just like your original code)
        String finalHtml = htmlContent;
        if (!htmlContent.contains('onload=')) {
          finalHtml = htmlContent.replaceFirst(
            '<body',
            '<body onload="window.print();"',
            // Notice we removed window.close() here because iframes handle lifecycle differently
          );
        }

        // 2. Create a Blob holding your modified HTML string
        final blob = html.Blob([finalHtml], 'text/html');
        final url = html.Url.createObjectUrlFromBlob(blob);

        // 3. Create a hidden IFrame
        final iframe = html.IFrameElement()
          ..style.display =
              'none' // Completely invisible
          ..src = url;

        // 4. Attach the IFrame to the browser's DOM
        html.document.body?.children.add(iframe);

        // 5. Clean up memory and the iframe after a short delay.
        // The browser will automatically trigger the print dialog thanks to the onload script!
        Future.delayed(const Duration(seconds: 3), () {
          iframe.remove();
          html.Url.revokeObjectUrl(url);
        });
      } catch (e) {
        showCustomSnackBar(
          message: 'Web HTML print failed: $e',
          context: context,
          type: SnackBarType.failure,
        );
      }
    } else {
      showCustomSnackBar(
        message: 'Printing is only supported on Web',
        context: context,
        type: SnackBarType.alert,
      );
    }
  }

  @override
  Future<void> cancel() async {
    debugPrint('Cancelling print job');
  }
}
