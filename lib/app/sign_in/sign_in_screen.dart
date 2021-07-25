import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/sign_in/email_auth_screen.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_manager.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_button_with_icon.dart';
import 'package:time_tracker_app/custom_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_app/services/auth.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key key, @required this.manager, @required this.isLoading}) : super(key: key);
  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, manager, __) => SignInScreen(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

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
    try {
      await manager.signInAnonymously();
    } on Exception catch (e) {
      _showSignInException(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on Exception catch (e) {
      _showSignInException(context, e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on Exception catch (e) {
      _showSignInException(context, e);
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
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SignInButtonWithIcon(
            icon: Image.asset('images/facebook-logo.png'),
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            fontWeight: FontWeight.normal,
            color: Color(0xFF334d92),
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
          ),
          SignInButton(
            text: 'Sign in with email',
            textColor: Colors.white,
            fontWeight: FontWeight.normal,
            color: Colors.teal,
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('or'),
          ),
          SignInButton(
            text: 'Go anonymous',
            color: Colors.lime.shade300,
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
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
