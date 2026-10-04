import 'package:flutter/material.dart';
import '../../domain/models/mark_model.dart';
import 'body_mark_painter.dart';

class BodyMarkCanvas extends StatefulWidget {
  /// The image provider for the background image.
  final ImageProvider imageProvider;

  /// Default style for marks if not specified per mark.
  final MarkStyle defaultMarkStyle;

  /// Callback when the list of marks changes.
  final ValueChanged<List<Mark>>? onMarksChanged;

  /// Initial list of marks.
  final List<Mark> initialMarks;

  /// Whether drawing is enabled.
  final bool enabled;

  /// Color to use for freehand drawing.
  final Color drawingColor;

  const BodyMarkCanvas({
    super.key,
    required this.imageProvider,
    this.defaultMarkStyle = const MarkStyle(),
    this.onMarksChanged,
    this.initialMarks = const [],
    this.enabled = true,
    this.drawingColor = Colors.red,
  });

  @override
  State<BodyMarkCanvas> createState() => BodyMarkCanvasState();
}

class BodyMarkCanvasState extends State<BodyMarkCanvas> {
  late List<Mark> _marks;
  final List<List<Mark>> _undoStack = [];
  final List<List<Mark>> _redoStack = [];
  double? _imageAspectRatio;
  bool _isImageLoaded = false;

  @override
  void initState() {
    super.initState();
    _marks = List.from(widget.initialMarks);
    _resolveImage();
  }

  @override
  void didUpdateWidget(BodyMarkCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageProvider != widget.imageProvider) {
      _resolveImage();
    }
    if (oldWidget.initialMarks != widget.initialMarks && widget.initialMarks != _marks) {
      setState(() {
        _marks = List.from(widget.initialMarks);
        _undoStack.clear();
        _redoStack.clear();
      });
    }
  }

  void _resolveImage() {
    final ImageStream stream =
        widget.imageProvider.resolve(const ImageConfiguration());
    final listener =
        ImageStreamListener((ImageInfo info, bool synchronousCall) {
      if (mounted) {
        setState(() {
          _imageAspectRatio = info.image.width / info.image.height;
          _isImageLoaded = true;
        });
      }
    });
    stream.addListener(listener);
  }

  /// Undoes the last mark placement.
  void undo() {
    if (_undoStack.isEmpty) return;

    setState(() {
      _redoStack.add(List.from(_marks));
      _marks = _undoStack.removeLast();
      widget.onMarksChanged?.call(_marks);
    });
  }

  /// Redoes the last undone mark placement.
  void redo() {
    if (_redoStack.isEmpty) return;

    setState(() {
      _undoStack.add(List.from(_marks));
      _marks = _redoStack.removeLast();
      widget.onMarksChanged?.call(_marks);
    });
  }

  /// Clears all marks from the canvas.
  void clear() {
    if (_marks.isEmpty) return;

    setState(() {
      _undoStack.add(List.from(_marks));
      _redoStack.clear();
      _marks = [];
      widget.onMarksChanged?.call(_marks);
    });
  }

  void _startPath(Offset localPosition, Size canvasSize) {
    if (!widget.enabled) return;

    final double nx = (localPosition.dx / canvasSize.width).clamp(0.0, 1.0);
    final double ny = (localPosition.dy / canvasSize.height).clamp(0.0, 1.0);

    setState(() {
      _undoStack.add(List.from(_marks));
      _redoStack.clear();
      _marks.add(Mark(
        x: nx,
        y: ny,
        type: MarkType.path,
        style: MarkStyle(color: widget.drawingColor),
        path: [Offset.zero], // Initial point relative to starting point
      ));
    });
  }

  void _updatePath(Offset localPosition, Size canvasSize) {
    if (!widget.enabled || _marks.isEmpty) return;
    if (_marks.last.type != MarkType.path) return;

    final double nx = (localPosition.dx / canvasSize.width).clamp(0.0, 1.0);
    final double ny = (localPosition.dy / canvasSize.height).clamp(0.0, 1.0);

    final startX = _marks.last.x;
    final startY = _marks.last.y;

    final relativeOffset = Offset(nx - startX, ny - startY);

    setState(() {
      final lastMark = _marks.last;
      final updatedPath = List<Offset>.from(lastMark.path ?? [])
        ..add(relativeOffset);
      _marks[_marks.length - 1] = lastMark.copyWith(path: updatedPath);
    });
  }

  void _endPath() {
    if (!widget.enabled) return;
    widget.onMarksChanged?.call(_marks);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isImageLoaded || _imageAspectRatio == null) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: AspectRatio(
            aspectRatio: _imageAspectRatio!,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image - fills the AspectRatio perfectly
                Image(
                  image: widget.imageProvider,
                  fit: BoxFit.fill,
                ),
                // Layer that perfectly overlays the image bounds since both match the AspectRatio
                LayoutBuilder(builder: (context, innerConstraints) {
                  final canvasSize = Size(
                      innerConstraints.maxWidth, innerConstraints.maxHeight);
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (details) =>
                        _startPath(details.localPosition, canvasSize),
                    onPanUpdate: (details) =>
                        _updatePath(details.localPosition, canvasSize),
                    onPanEnd: (_) => _endPath(),
                    child: CustomPaint(
                      painter: BodyMarkPainter(
                        marks: _marks,
                        defaultStyle: widget.defaultMarkStyle,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Returns the current list of marks.
  List<Mark> get marks => List.unmodifiable(_marks);

  /// Checks if undo is possible.
  bool get canUndo => _undoStack.isNotEmpty;

  /// Checks if redo is possible.
  bool get canRedo => _redoStack.isNotEmpty;
}
