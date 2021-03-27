import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key key,
    this.child,
    this.primaryColor,
    @required this.onPressed,
    this.backgroundColor,
    this.shape,
    this.minWidth: 450,
    this.minHeight: 50,
  })  : assert(minWidth != null),
        assert(minHeight != null),
        super(key: key);

  final Widget child;
  final Color primaryColor;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final OutlinedBorder shape;
  final double minWidth;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        child: child,
        style: TextButton.styleFrom(
          fixedSize: Size(minWidth, minHeight),
          shape: shape,
          primary: primaryColor,
          backgroundColor: backgroundColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
