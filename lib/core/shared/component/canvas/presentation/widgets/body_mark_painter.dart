import 'package:flutter/material.dart';
import '../../domain/models/mark_model.dart';

/// A [CustomPainter] that renders marks on top of an image.
class BodyMarkPainter extends CustomPainter {
  final List<Mark> marks;
  final MarkStyle defaultStyle;

  BodyMarkPainter({
    required this.marks,
    required this.defaultStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final mark in marks) {
      final style = mark.style ?? defaultStyle;
      final paint = Paint()
        ..color = style.color
        ..strokeWidth = style.strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final double px = mark.x * size.width;
      final double py = mark.y * size.height;
      final Offset position = Offset(px, py);

      if (mark.type == MarkType.path &&
          mark.path != null &&
          mark.path!.isNotEmpty) {
        final path = Path();
        path.moveTo(px, py);
        for (final offset in mark.path!) {
          path.lineTo(
            px + (offset.dx * size.width),
            py + (offset.dy * size.height),
          );
        }
        canvas.drawPath(path, paint);
      } else {
        _drawMark(canvas, position, style, paint);
      }
    }
  }

  void _drawMark(Canvas canvas, Offset position, MarkStyle style, Paint paint) {
    switch (style.shape) {
      case MarkShape.dot:
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(position, style.size / 2, paint);
        break;
      case MarkShape.cross:
        final double halfSize = style.size / 2;
        canvas.drawLine(
          position - Offset(halfSize, halfSize),
          position + Offset(halfSize, halfSize),
          paint,
        );
        canvas.drawLine(
          position - Offset(-halfSize, halfSize),
          position + Offset(-halfSize, halfSize),
          paint,
        );
        break;
      case MarkShape.square:
        final Rect rect = Rect.fromCenter(
          center: position,
          width: style.size,
          height: style.size,
        );
        canvas.drawRect(rect, paint);
        break;
      case MarkShape.circle:
        canvas.drawCircle(position, style.size / 2, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant BodyMarkPainter oldDelegate) {
    return oldDelegate.marks != marks ||
        oldDelegate.defaultStyle != defaultStyle;
  }
}
