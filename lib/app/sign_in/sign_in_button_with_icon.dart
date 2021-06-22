import 'package:flutter/material.dart';
import 'package:time_tracker_app/custom_widgets/custom_elevated_button.dart';

class SignInButtonWithIcon extends CustomElevatedButton {
  SignInButtonWithIcon({
    @required Widget icon,
    @required String text,
    VoidCallback onPressed,
    Color color,
    Color textColor: Colors.black87,
    double fontSize: 15.0,
    FontWeight fontWeight: FontWeight.w600,
  })  : assert(icon != null),
        assert(text != null),
        super(
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.centerLeft,
            children: [
              Positioned(
                left: 5,
                child: icon,
              ),
              Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: color,
          primaryColor: textColor,
          onPressed: onPressed,
        );
}
