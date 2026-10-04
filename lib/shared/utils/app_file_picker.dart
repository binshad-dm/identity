import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:cross_file/cross_file.dart';

/// Reusable model to wrap file data consistently across platforms
class AppFile {
  final String name;
  final int size;
  final Uint8List? bytes;
  final String? path;
  final String? extension;

  AppFile({
    required this.name,
    required this.size,
    this.bytes,
    this.path,
    this.extension,
  });
}

/// Utility for handling native file picker logic
class AppFilePickerUtil {
  /// Picks files natively using file_picker
  static Future<List<AppFile>> pickFiles({
    bool allowMultiple = false,
    List<String>? allowedExtensions,
    FileType type = FileType.any,
  }) async {
    try {
      final result = await FilePicker.pickFiles(
        allowMultiple: allowMultiple,
        type: allowedExtensions != null ? FileType.custom : type,
        allowedExtensions: allowedExtensions,
        withData: kIsWeb, // Need to request bytes directly on Web
      );

      if (result == null || result.files.isEmpty) {
        return [];
      }

      return result.files.map((file) {
        return AppFile(
          name: file.name,
          size: file.size,
          bytes: file.bytes,
          path: file.path,
          extension: file.extension,
        );
      }).toList();
    } catch (e) {
      debugPrint("Error picking files: $e");
      return [];
    }
  }
}

/// A reusable widget that provides a Drag and Drop zone for Desktop/Web
/// Also handles tap-to-select via the native file picker
class AppDropzoneWidget extends StatefulWidget {
  final Widget child;
  final Function(List<AppFile> files) onFilesSelected;
  final bool allowMultiple;
  final List<String>? allowedExtensions;
  final bool enableTapToSelect;

  const AppDropzoneWidget({
    super.key,
    required this.child,
    required this.onFilesSelected,
    this.allowMultiple = false,
    this.allowedExtensions,
    this.enableTapToSelect = true,
  });

  @override
  State<AppDropzoneWidget> createState() => _AppDropzoneWidgetState();
}

class _AppDropzoneWidgetState extends State<AppDropzoneWidget> {
  bool _isDragging = false;

  Future<void> _handleDroppedFiles(List<XFile> droppedFiles) async {
    List<AppFile> appFiles = [];

    // Limit to single file if allowMultiple is false
    final filesToProcess =
        widget.allowMultiple ? droppedFiles : droppedFiles.take(1);

    for (final file in filesToProcess) {
      final bytes = await file.readAsBytes();
      final length = await file.length();
      final name = file.name;
      final extension =
          name.contains('.') ? name.split('.').last.toLowerCase() : null;

      // Filter by extension if necessary
      if (widget.allowedExtensions != null &&
          widget.allowedExtensions!.isNotEmpty) {
        if (extension == null ||
            !widget.allowedExtensions!.contains(extension)) {
          continue; // Skip unsupported files
        }
      }

      appFiles.add(AppFile(
        name: name,
        size: length,
        bytes: bytes,
        path: file.path,
        extension: extension,
      ));
    }

    if (appFiles.isNotEmpty) {
      widget.onFilesSelected(appFiles);
    }
  }

  Future<void> _handleTap() async {
    if (!widget.enableTapToSelect) return;

    final files = await AppFilePickerUtil.pickFiles(
      allowMultiple: widget.allowMultiple,
      allowedExtensions: widget.allowedExtensions,
    );

    if (files.isNotEmpty) {
      widget.onFilesSelected(files);
    }
  }

  @override
  Widget build(BuildContext context) {
    // If on mobile (Android/iOS) where drag-and-drop from OS isn't typical,
    // fallback to just a tap gesture detector if tap is enabled.
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      return GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: widget.child,
      );
    }

    // For Web and Desktop, wrap with DropTarget from desktop_drop package
    return DropTarget(
      onDragEntered: (details) => setState(() => _isDragging = true),
      onDragExited: (details) => setState(() => _isDragging = false),
      onDragDone: (details) {
        setState(() => _isDragging = false);
        _handleDroppedFiles(details.files);
      },
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            widget.child,
            if (_isDragging)
              Positioned.fill(
                child: Container(
                  color: Colors.blue.withOpacity(0.15),
                  child: const Center(
                    child: Icon(Icons.file_upload_outlined,
                        size: 48, color: Colors.blue),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
