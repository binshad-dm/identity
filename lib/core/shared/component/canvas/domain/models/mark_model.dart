import 'package:flutter/material.dart';

/// Represents the shape of the mark.
enum MarkType { point, path }

/// Represents the shape of the mark for specific point marks.
enum MarkShape { dot, cross, square, circle }

/// Configuration for the visual style of a mark.
class MarkStyle {
  final Color color;
  final double size;
  final MarkShape shape;
  final double strokeWidth;

  const MarkStyle({
    this.color = Colors.red,
    this.size = 10.0,
    this.shape = MarkShape.dot,
    this.strokeWidth = 2.0,
  });

  Map<String, dynamic> toJson() => {
        'color': color.value,
        'size': size,
        'shape': shape.name,
        'strokeWidth': strokeWidth,
      };

  factory MarkStyle.fromJson(Map<String, dynamic> json) => MarkStyle(
        color: Color(json['color'] as int),
        size: (json['size'] as num).toDouble(),
        shape: MarkShape.values.firstWhere(
          (e) => e.name == (json['shape'] as String? ?? 'dot'),
          orElse: () => MarkShape.dot,
        ),
        strokeWidth: (json['strokeWidth'] as num).toDouble(),
      );

  MarkStyle copyWith({
    Color? color,
    double? size,
    MarkShape? shape,
    double? strokeWidth,
  }) {
    return MarkStyle(
      color: color ?? this.color,
      size: size ?? this.size,
      shape: shape ?? this.shape,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }
}

/// Represents a mark or drawing on the canvas with normalized coordinates.
class Mark {
  /// X coordinate normalized to 0.0 - 1.0 (relative to image width).
  /// For paths, this is the first point.
  final double x;

  /// Y coordinate normalized to 0.0 - 1.0 (relative to image height).
  /// For paths, this is the first point.
  final double y;

  /// For freehand drawing, a list of points (offsets) relative to (x, y).
  /// Coordinates in these points are also normalized.
  final List<Offset>? path;

  /// Type of mark.
  final MarkType type;

  /// Optional label or metadata for the mark.
  final String? label;

  /// Style override for this specific mark.
  final MarkStyle? style;

  const Mark({
    required this.x,
    required this.y,
    this.path,
    this.type = MarkType.point,
    this.label,
    this.style,
  });

  /// Creates a [Mark] from a JSON object.
  factory Mark.fromJson(Map<String, dynamic> json) {
    return Mark(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      path: json['path'] != null
          ? (json['path'] as List)
              .map((e) => Offset(
                    (e['dx'] as num).toDouble(),
                    (e['dy'] as num).toDouble(),
                  ))
              .toList()
          : null,
      type: MarkType.values.firstWhere(
        (e) => e.name == (json['type'] as String? ?? 'point'),
        orElse: () => MarkType.point,
      ),
      style: json['style'] != null
          ? MarkStyle.fromJson(json['style'] as Map<String, dynamic>)
          : null,
      label: json['label'] as String?,
    );
  }

  /// Converts the [Mark] to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      if (path != null)
        'path': path!.map((e) => {'dx': e.dx, 'dy': e.dy}).toList(),
      'type': type.name,
      if (style != null) 'style': style!.toJson(),
      if (label != null) 'label': label,
    };
  }

  Mark copyWith({
    double? x,
    double? y,
    List<Offset>? path,
    MarkType? type,
    String? label,
    MarkStyle? style,
  }) {
    return Mark(
      x: x ?? this.x,
      y: y ?? this.y,
      path: path ?? this.path,
      type: type ?? this.type,
      label: label ?? this.label,
      style: style ?? this.style,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Mark &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          type == other.type &&
          label == other.label;

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ type.hashCode ^ label.hashCode;
}
