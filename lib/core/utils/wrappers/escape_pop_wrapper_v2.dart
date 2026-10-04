import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EscapePoppableWrapperV2 extends StatefulWidget {
  final Widget child;
  final Future<bool> Function()? onPop;
  final Map<LogicalKeyboardKey, VoidCallback> shortcuts; // Existing shortcuts
  final Map<GroupedKey, VoidCallback> groupedShortcuts; // New grouped shortcuts

  const EscapePoppableWrapperV2({
    super.key,
    required this.child,
    this.onPop,
    this.shortcuts = const {}, // Default to an empty map
    this.groupedShortcuts = const {}, // Default to an empty map
  });

  @override
  State<EscapePoppableWrapperV2> createState() =>
      _EscapePoppableWrapperV2State();
}

class _EscapePoppableWrapperV2State extends State<EscapePoppableWrapperV2> {
  final FocusNode _focusNode = FocusNode();

  void _handleKey(KeyEvent event) async {
    if (event is KeyDownEvent) {
      // Handle the Escape key (only when this route is the current/top route)
      if (event.physicalKey == PhysicalKeyboardKey.escape) {
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          _tryPop();
        }
      }

      // Handle existing shortcuts (LogicalKeyboardKey only)
      for (final entry in widget.shortcuts.entries) {
        final key = entry.key;
        final callback = entry.value;
        if (event.logicalKey == key) {
          callback();
        }
      }

      // Handle grouped shortcuts (GroupedKey: Physical + Logical)
      for (final entry in widget.groupedShortcuts.entries) {
        final groupedKey = entry.key;
        final callback = entry.value;

        if (event.logicalKey == groupedKey.secondKey &&
            HardwareKeyboard.instance.logicalKeysPressed
                .contains(groupedKey.firstKey)) {
          callback();
        }
      }
    }
  }

  Future<void> _tryPop() async {
    // Check if Navigator can pop before proceeding
    if (!Navigator.canPop(context)) {
      return; // Exit early if there's nothing to pop
    }

    // Check if the custom onPop function allows popping
    final canPop = widget.onPop != null ? await widget.onPop!() : true;
    if (canPop && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent, // Captures clicks on empty space
      onTap: () {
        // Remove focus from any focused widget (like TextField)
        FocusScope.of(context).unfocus();
        // Request focus back to our listener
        _focusNode.requestFocus();
      },
      child: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: _handleKey,
        autofocus: true,
        child: widget.child,
      ),
    );
  }
}

class GroupedKey {
  final LogicalKeyboardKey firstKey;
  final LogicalKeyboardKey secondKey;

  const GroupedKey({
    required this.firstKey,
    required this.secondKey,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GroupedKey &&
        other.firstKey == firstKey &&
        other.secondKey == secondKey;
  }

  @override
  int get hashCode => firstKey.hashCode ^ secondKey.hashCode;
}
