import 'package:flutter/material.dart';
import '../../domain/models/mark_model.dart';
import '../widgets/body_mark_canvas.dart';
import 'canvas_preview_view.dart';

class CanvasView extends StatefulWidget {
  const CanvasView({super.key});

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  final GlobalKey<BodyMarkCanvasState> _canvasKey =
      GlobalKey<BodyMarkCanvasState>();
  List<Mark> _currentMarks = [];

  Color _selectedColor = Colors.red;

  final List<Color> _availableColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.black,
    Colors.white,
  ];

  // A sample image of a human body part for demonstration
  static const String _demoImageUrl =
      'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=1000&auto=format&fit=crop';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Mark Canvas Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () => _canvasKey.currentState?.undo(),
            tooltip: 'Undo',
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: () => _canvasKey.currentState?.redo(),
            tooltip: 'Redo',
          ),
          IconButton(
            icon: const Icon(Icons.remove_red_eye_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CanvasPreviewView(
                    imageProvider: const NetworkImage(_demoImageUrl),
                    marks: _currentMarks,
                  ),
                ),
              );
            },
            tooltip: 'Preview',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildColorPalette(),
          Expanded(
            child: Center(
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
                    key: _canvasKey,
                    imageProvider: const NetworkImage(_demoImageUrl),
                    drawingColor: _selectedColor,
                    onMarksChanged: (marks) {
                      // Avoid calling setState if we just ended a path to prevent rebuilding the whole tree unnecessarily if possible,
                      // but ok for demo.
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _currentMarks = marks;
                          });
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPalette() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Color: ', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          ..._availableColors.map((color) {
            final isSelected = _selectedColor == color;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = color;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 1,
                      )
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
