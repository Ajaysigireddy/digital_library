import 'package:flutter/material.dart';

class FocusUtils {
  static Widget leadingButtonWithFocus({
    required FocusNode focusNode,
    required VoidCallback onPressed,
    required Icon icon,
  }) {
    return Focus(
      focusNode: focusNode,
      onFocusChange: (hasFocus) {},
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: focusNode.hasFocus ? Colors.white : Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: IconButton(
          icon: icon,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
