import 'package:flutter/material.dart';

class DesignConfig {
  static UnderlineInputBorder setUnderlineInputBorder(Color color) {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: color),
    );
  }

  static BoxDecoration boxDecoration(Color color, double radius) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static RoundedRectangleBorder setRoundedBorder(
      Color bordercolor, double bradius, bool isboarder) {
    return RoundedRectangleBorder(
        side: BorderSide(color: bordercolor, width: isboarder ? 1.0 : 0),
        borderRadius: BorderRadius.circular(bradius));
  }

  static get appShadow => const [
        BoxShadow(
          color: Color(0x1E000000),
          blurRadius: 8,
          offset: Offset(0, 4),
          spreadRadius: 0,
        )
      ];
  static get defaultHeightSizedBox => const SizedBox(
        height: 16,
      );
  static get defaultWidthSizedBox => const SizedBox(
        width: 16,
      );
  static get smallHeightSizedBox => const SizedBox(
        height: 8,
      );
  static get smallWidthSizedBox => const SizedBox(
        width: 8,
      );
}
