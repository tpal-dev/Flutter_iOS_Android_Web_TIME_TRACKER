import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/sign_in/email_auth_screen.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_button_with_icon.dart';
import 'package:time_tracker_app/custom_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_app/services/auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    Key key,
  }) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isLoading = false;

  void _showSignInException(BuildContext context, Exception exception) {
    if (exception is FirebaseAuthException && exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: 'Sign in failed',
      exception: exception,
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      final user = await auth.signInAnonymously();
      print('Anonymous sign in success! uid: ${user?.uid}');
    } on Exception catch (e) {
      _showSignInException(context, e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      setState(() => _isLoading = true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      final user = await auth.signInWithGoogle();
      print('Google sign in success! uid: ${user?.uid}');
    } on Exception catch (e) {
      _showSignInException(context, e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      setState(() => _isLoading = true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      final user = await auth.signInWithFacebook();
      print('Facebook sign in success! uid: ${user?.uid}');
    } on Exception catch (e) {
      _showSignInException(context, e);
    } finally {
      setState(() => _isLoading = false);
    }
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
        child: Center(
          child: SingleChildScrollView(
            child: _buildContent(context),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 100, child: _buildHeader()),
          SignInButtonWithIcon(
            icon: Image.asset('images/google-logo.png'),
            text: 'Sign in with Google',
            color: Colors.white,
            onPressed: _isLoading ? null : () => _signInWithGoogle(context),
          ),
          SignInButtonWithIcon(
            icon: Image.asset('images/facebook-logo.png'),
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            fontWeight: FontWeight.normal,
            color: Color(0xFF334d92),
            onPressed: _isLoading ? null : () => _signInWithFacebook(context),
          ),
          SignInButton(
            text: 'Sign in with email',
            textColor: Colors.white,
            fontWeight: FontWeight.normal,
            color: Colors.teal,
            onPressed: _isLoading ? null : () => _signInWithEmail(context),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('or'),
          ),
          SignInButton(
            text: 'Go anonymous',
            color: Colors.lime.shade300,
            onPressed: _isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Text(
        'Sign In',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }
}
