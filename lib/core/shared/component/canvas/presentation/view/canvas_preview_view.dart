import 'package:flutter/material.dart';
import '../../domain/models/mark_model.dart';
import '../widgets/body_mark_canvas.dart';

class CanvasPreviewView extends StatelessWidget {
  final ImageProvider imageProvider;
  final List<Mark> marks;

  const CanvasPreviewView({
    super.key,
    required this.imageProvider,
    required this.marks,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawing Preview'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: BodyMarkCanvas(
              imageProvider: imageProvider,
              initialMarks: marks,
              enabled: true, // Read-only modes
            ),
          ),
        ),
      ),
    );
  }
}
