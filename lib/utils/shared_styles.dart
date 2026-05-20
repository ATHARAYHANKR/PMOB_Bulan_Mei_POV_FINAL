import 'package:flutter/material.dart';

class AppStyles {
  AppStyles._();

  static const Color primaryColor = Color(0xFF5C3317);

  // Button
  static final double buttonRadius = 10;
  static final double buttonHeight = 48;

  static ButtonStyle primaryButtonStyle() => ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        minimumSize: Size.fromHeight(buttonHeight),
        padding: const EdgeInsets.symmetric(vertical: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius)),
      );

  static ButtonStyle outlinedButtonStyle() => OutlinedButton.styleFrom(
        side: const BorderSide(color: primaryColor),
        minimumSize: Size.fromHeight(buttonHeight),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius)),
      );

  // Card
  static final double cardRadius = 14;

  static BoxDecoration cardDecoration({Color? color}) => BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );
}
