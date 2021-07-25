import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/sign_in/email_sign_in_form_bloc_based.dart';
import 'package:time_tracker_app/app/sign_in/email_sign_in_form_change_notifier.dart';

class EmailAuthScreen extends StatelessWidget {
  const EmailAuthScreen({Key key}) : super(key: key);
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
            child: EmailSignInFormChangeNotifier.create(context),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }
}
