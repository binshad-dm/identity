import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SheetAction {
  final IconData icon;
  final String title;
  final Color? iconColor;
  final VoidCallback onTap;

  SheetAction({
    required this.icon,
    required this.title,
    this.iconColor,
    required this.onTap,
  });
}

class AppActionSheet extends StatelessWidget {
  final List<SheetAction> actions;
  final String? title;

  const AppActionSheet({
    super.key,
    required this.actions,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ...actions.map(
            (a) => ListTile(
              leading: Icon(a.icon, color: a.iconColor ?? Colors.black),
              title: Text(a.title),
              onTap: () {
                Navigator.pop(context);
                a.onTap();
              },
            ),
          ),
        ],
      ),
    );
  }
}
