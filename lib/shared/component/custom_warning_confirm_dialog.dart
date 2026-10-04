import 'package:flutter/material.dart';

class CustomWarningConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelLabel;
  final String confirmLabel;
  final bool isDestructive;
  final IconData icon;
  final Color? accentColor;

  const CustomWarningConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    required this.cancelLabel,
    required this.confirmLabel,
    this.isDestructive = false,
    this.icon = Icons.warning_amber_rounded,
    this.accentColor,
  });

  /// Displays the custom premium confirmation dialog with a slide-up and fade-in animation.
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String content,
    required String cancelLabel,
    required String confirmLabel,
    bool isDestructive = false,
    IconData icon = Icons.warning_amber_rounded,
    Color? accentColor,
  }) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss dialog',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return CustomWarningConfirmDialog(
          title: title,
          content: content,
          cancelLabel: cancelLabel,
          confirmLabel: confirmLabel,
          isDestructive: isDestructive,
          icon: icon,
          accentColor: accentColor,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Premium slide-up + fade-in transition
        final slideCurve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutQuart,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.12),
            end: Offset.zero,
          ).animate(slideCurve),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Define colors using self-contained premium slate palettes
    final backgroundColor = isDark 
        ? const Color(0xFF1E293B) // Slate 800
        : Colors.white;

    final borderColor = isDark 
        ? const Color(0xFF334155) // Slate 700
        : const Color(0xFFE2E8F0); // Slate 200

    // Compute the base accent color based on configuration or defaults
    final resolvedAccentColor = accentColor ?? 
        (isDestructive 
            ? (isDark ? const Color(0xFFF87171) : const Color(0xFFEF4444))
            : (isDark ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6)));

    final warningBgColor = resolvedAccentColor.withOpacity(isDark ? 0.2 : 0.1);

    final titleColor = isDark 
        ? Colors.white 
        : const Color(0xFF0F172A); // Slate 900

    final descriptionColor = isDark 
        ? const Color(0xFF94A3B8) // Slate 400
        : const Color(0xFF475569); // Slate 600

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 380,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.45) : const Color(0x1A000000),
                blurRadius: 36,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Styled Content Block
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dynamic Header Icon Badge (Outer Circular Container)
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: warningBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          color: resolvedAccentColor,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Title
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Message Content
                    Text(
                      content,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                        color: descriptionColor,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons Row
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  children: [
                    // Outlined Cancel Button
                    Expanded(
                      child: _DialogActionButton(
                        onPressed: () => Navigator.pop(context, false),
                        isFilled: false,
                        borderColor: borderColor,
                        child: Text(
                          cancelLabel,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Filled Confirm Button
                    Expanded(
                      child: _DialogActionButton(
                        onPressed: () => Navigator.pop(context, true),
                        isFilled: true,
                        backgroundColor: resolvedAccentColor,
                        child: Text(
                          confirmLabel,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom interactive button with built-in scale shrink animations for satisfying tactile feedback.
class _DialogActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final bool isFilled;
  final Color? backgroundColor;
  final Color? borderColor;

  const _DialogActionButton({
    required this.onPressed,
    required this.child,
    required this.isFilled,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  State<_DialogActionButton> createState() => _DialogActionButtonState();
}

class _DialogActionButtonState extends State<_DialogActionButton> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animController.forward(),
      onTapUp: (_) {
        _animController.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _animController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.isFilled ? widget.backgroundColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: widget.isFilled 
                ? null 
                : Border.all(color: widget.borderColor ?? Colors.transparent, width: 1.5),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
