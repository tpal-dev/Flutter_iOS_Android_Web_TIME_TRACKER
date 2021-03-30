import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/home_screen.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_screen.dart';
import 'package:time_tracker_app/services/auth.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  User _user;

  @override
  void initState() {
    super.initState();
    _updateUser(widget.auth.currentUser);
  }

  void _updateUser(User user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInScreen(
        auth: widget.auth,
        onSignIn: _updateUser,
      );
    }
    return HomeScreen(
      auth: widget.auth,
      onSignOut: () => _updateUser(null),
    );
  }
}
