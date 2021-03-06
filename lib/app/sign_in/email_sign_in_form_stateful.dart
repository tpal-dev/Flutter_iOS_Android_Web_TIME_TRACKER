import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_app/app/sign_in/validators.dart';
import 'package:time_tracker_app/custom_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_app/services/auth.dart';

class EmailSignInFormStateful extends StatefulWidget with EmailAndPasswordValidators {
  EmailSignInFormStateful({Key key}) : super(key: key);

  @override
  _EmailSignInFormStatefulState createState() => _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {
  final TextEditingController _emailTextFieldController = TextEditingController();
  final TextEditingController _passwordTextFieldController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;

  String get _email => _emailTextFieldController.text.trim();
  String get _password => _passwordTextFieldController.text.trim();

  @override
  void dispose() {
    _emailTextFieldController.dispose();
    _passwordTextFieldController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailTextFieldController.clear();
    _passwordTextFieldController.clear();
  }

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      // await Future.delayed(Duration(seconds: 3));
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email: _email, password: _password);
      } else {
        await auth.createUserWithEmailAndPassword(email: _email, password: _password);
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, exception: e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email) ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildColumnChildren(),
      ),
    );
  }

  List<Widget> _buildColumnChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn ? 'Sign in' : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';

    bool submitEnable = !_isLoading &&
        widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password);

    return [
      _buildEmailTextField(),
      _buildPasswordTextField(),
      SizedBox(height: 16.0),
      SignInButton(
        text: primaryText,
        textColor: Colors.white,
        fontWeight: FontWeight.normal,
        onPressed: submitEnable ? _submit : null,
      ),
      SizedBox(height: 10.0),
      Align(
        alignment: Alignment.center,
        child: TextButton(
          child: Text(secondaryText),
          onPressed: !_isLoading ? _toggleFormType : null,
        ),
      )
    ];
  }

  TextFormField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);

    return TextFormField(
      controller: _emailTextFieldController,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@gmail.com',
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        enabled: _isLoading == false,
      ),
      onEditingComplete: _emailEditingComplete,
      onChanged: (email) => _updateState(),
    );
  }

  TextFormField _buildPasswordTextField() {
    bool showErrorText = _submitted && !widget.passwordValidator.isValid(_password);
    return TextFormField(
      controller: _passwordTextFieldController,
      obscureText: true,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: _isLoading == false,
      ),
      onEditingComplete: _submit,
      onChanged: (password) => _updateState(),
    );
  }
}
