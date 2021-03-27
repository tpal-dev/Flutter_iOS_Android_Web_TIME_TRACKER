import 'package:flutter/material.dart';
import 'package:time_tracker_app/custom_widgets/custom_elevated_button.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton({
    @required String text,
    @required VoidCallback onPressed,
    Color color,
    Color textColor: Colors.black87,
    double fontSize: 15.0,
    FontWeight fontWeight: FontWeight.w600,
  })  : assert(text != null),
        super(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
          backgroundColor: color,
          primaryColor: textColor,
          onPressed: onPressed,
        );
}
