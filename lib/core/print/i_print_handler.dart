import 'dart:typed_data';
import 'package:flutter/material.dart';

abstract class PrintHandler {
  Future<void> printPdf(Uint8List pdfData, String name, BuildContext context);
  Future<void> printHtml(String htmlContent, String name, BuildContext context);
  Future<void> cancel();
}
