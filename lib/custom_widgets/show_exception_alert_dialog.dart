import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_app/custom_widgets/show_alert_dialog.dart';

Future<void> showExceptionAlertDialog(
  BuildContext context, {
  String title,
  @required Exception exception,
}) =>
    showAlertDialog(context,
        title: title ?? _title(exception), content: _message(exception), defaultActionText: 'OK');

String _title(Exception exception) {
  if (exception is FirebaseAuthException) {
    return exception.code.toUpperCase().replaceAll('-', ' ');
  }
  return 'Exception Alert';
}

String _message(Exception exception) {
  if (exception is FirebaseAuthException) {
    return exception.message;
  }
  return exception.toString();
}
