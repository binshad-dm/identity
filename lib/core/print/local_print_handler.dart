// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:identity/core/shared/snackbar.dart';
import 'package:printing/printing.dart';
import 'i_print_handler.dart';

class PrintHandlerImpl implements PrintHandler {
  @override
  Future<void> printPdf(
    Uint8List pdfData,
    String name,
    BuildContext context,
  ) async {
    try {
      await Printing.layoutPdf(
        usePrinterSettings: true,
        onLayout: (_) async => pdfData,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Print failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Future<void> printHtml(
    String htmlContent,
    String name,
    BuildContext context,
  ) async {
    // convertHtml relies on a platform WebView which is not available on
    // Windows / Linux desktop. Printing is web-only for this application.
    showCustomSnackBar(
      context: context,
      message: "Printing is only supported on Web Platform",
      type: SnackBarType.alert,
    );
  }

  @override
  Future<void> cancel() async {
    debugPrint('Cancelling print job');
  }
}
