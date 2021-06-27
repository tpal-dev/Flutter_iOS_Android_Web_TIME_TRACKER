import 'package:flutter/material.dart';
import 'package:time_tracker_app/custom_widgets/show_alert_dialog.dart';
import 'package:time_tracker_app/services/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  Future<void> _signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Logout',
        content: 'Are you sure you want to logout?',
        defaultActionText: 'Logout',
        cancelActionText: "Cancel");
    if (didRequestSignOut == true) {
      _signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () => _confirmSignOut(context),
            ),
          )
        ],
      ),
    );
  }
}
