import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/sign_in/email_sign_in_form.dart';
import 'package:time_tracker_app/services/auth.dart';

class EmailAuthScreen extends StatelessWidget {
  const EmailAuthScreen({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Sign In'),
        elevation: 3.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Card(
            margin: EdgeInsets.all(16.0),
            child: EmailSignInForm(
              auth: auth,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }
}
