import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<String?> keyboardBottomSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKeyboardKey('7', context),
                  _buildKeyboardKey('8', context),
                  _buildKeyboardKey('9', context),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKeyboardKey('4', context),
                  _buildKeyboardKey('5', context),
                  _buildKeyboardKey('6', context),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKeyboardKey('1', context),
                  _buildKeyboardKey('2', context),
                  _buildKeyboardKey('3', context),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKeyboardKey('0', context),
                  _buildKeyboardKey('1/2', context),
                  _buildKeyboardKey('', context),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildKeyboardKey(String value, BuildContext context) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            if (value != '') {
              Navigator.pop<String>(context, value == '1/2' ? '0.5' : value);
            } else {
              Navigator.pop<String>(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF5F6FA),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            textStyle:
                GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          child: value == ''
              ? const Icon(
                  Icons.close,
                  color: Colors.red,
                )
              : Text(value),
        ),
      ),
    ),
  );
}
