import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AppCustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const AppCustomAppbar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.titleStyle,
    this.onClose,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final TextStyle? titleStyle;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 5,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      surfaceTintColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.width > 600
            ? preferredSize.height
            : 81.0,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Row(
            children: [
              if (leading != null) ...[leading!, const Gap(8)],
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style:
                      titleStyle ??
                      Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (actions != null) ...actions!,
                  const Gap(16),
                  // if (canPop)
                  //   Padding(
                  //     padding: const EdgeInsets.only(right: 8),
                  //     child: IconButton(
                  //       style: IconButton.styleFrom(
                  //         backgroundColor: Colors.red,
                  //         minimumSize: const Size(28, 28),
                  //         padding: EdgeInsets.zero,
                  //         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(5)),
                  //       ),
                  //       icon: const Icon(Icons.close,
                  //           size: 14, color: Colors.white),
                  //       onPressed: onClose ??
                  //           () {
                  //             if (Navigator.canPop(context)) {
                  //               Navigator.pop(context);
                  //             }
                  //           },
                  //     ),
                  //   ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70.0);
}
