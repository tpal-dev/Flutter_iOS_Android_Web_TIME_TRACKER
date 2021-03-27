import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key key,
    this.child,
    this.primaryColor,
    this.onPressed,
    this.backgroundColor,
    this.shape,
  }) : super(key: key);

  final Widget child;
  final Color primaryColor;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final OutlinedBorder shape;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: child,
      style: TextButton.styleFrom(
        shape: shape,
        textStyle: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w600,
        ),
        primary: primaryColor,
        backgroundColor: backgroundColor,
      ),
      onPressed: onPressed,
    );
  }
}
