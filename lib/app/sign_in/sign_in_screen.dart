import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_with_logo_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key key, @required this.onSignIn}) : super(key: key);
  final void Function(User) onSignIn;

  Future<void> _signInAnonymously() async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      onSignIn(userCredential.user);
      print('Anonymous sign in success! uid: ${userCredential.user.uid}');
    } catch (e) {
      print('Error -> Exception details:\n $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 3.0,
      ),
      body: SafeArea(
        child: _buildContent(),
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Sign In',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 70),
              SignInButtonWithLogo(
                assetName: 'images/google-logo.png',
                text: 'Sign in with Google',
                color: Colors.white,
                onPressed: () {},
              ),
              SignInButtonWithLogo(
                assetName: 'images/facebook-logo.png',
                text: 'Sign in with Facebook',
                textColor: Colors.white,
                fontWeight: FontWeight.normal,
                color: Color(0xFF334d92),
                onPressed: () {},
              ),
              SignInButton(
                text: 'Sign in with email',
                textColor: Colors.white,
                fontWeight: FontWeight.normal,
                color: Colors.teal,
                onPressed: () {},
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('or'),
              ),
              SignInButton(
                text: 'Go anonymous',
                color: Colors.lime.shade300,
                onPressed: _signInAnonymously,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
