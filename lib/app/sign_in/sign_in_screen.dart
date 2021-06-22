import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/sign_in/email_auth_screen.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_button_with_icon.dart';
import 'package:time_tracker_app/services/auth.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  Future<void> _signInAnonymously() async {
    final user = await auth.signInAnonymously();
    print('Anonymous sign in success! uid: ${user?.uid}');
  }

  Future<void> _signInWithGoogle() async {
    final user = await auth.signInWithGoogle();
    print('Google sign in success! uid: ${user?.uid}');
  }

  Future<void> _signInWithFacebook() async {
    final user = await auth.signInWithFacebook();
    print('Facebook sign in success! uid: ${user?.uid}');
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailAuthScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 3.0,
      ),
      body: SafeArea(
        child: _buildContent(context),
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }

  Widget _buildContent(BuildContext context) {
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
              SignInButtonWithIcon(
                icon: Image.asset('images/google-logo.png'),
                text: 'Sign in with Google',
                color: Colors.white,
                onPressed: _signInWithGoogle,
              ),
              SignInButtonWithIcon(
                icon: Image.asset('images/facebook-logo.png'),
                text: 'Sign in with Facebook',
                textColor: Colors.white,
                fontWeight: FontWeight.normal,
                color: Color(0xFF334d92),
                onPressed: _signInWithFacebook,
              ),
              SignInButton(
                text: 'Sign in with email',
                textColor: Colors.white,
                fontWeight: FontWeight.normal,
                color: Colors.teal,
                onPressed: () => _signInWithEmail(context),
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
