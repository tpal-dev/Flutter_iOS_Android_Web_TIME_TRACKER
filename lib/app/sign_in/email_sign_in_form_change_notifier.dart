import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_app/custom_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_app/services/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({Key key, @required this.model}) : super(key: key);
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(
          model: model,
        ),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() => _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailTextFieldController = TextEditingController();
  final TextEditingController _passwordTextFieldController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    _emailTextFieldController.dispose();
    _passwordTextFieldController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _toggleFormType() {
    model.toggleFormType();
    _emailTextFieldController.clear();
    _passwordTextFieldController.clear();
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, exception: e);
    }
  }

  void _emailEditingComplete() {
    final newFocus =
        model.emailValidator.isValid(model.email) ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildColumnChildren(),
      ),
    );
  }

  List<Widget> _buildColumnChildren() {
    return [
      _buildEmailTextField(),
      _buildPasswordTextField(),
      SizedBox(height: 16.0),
      SignInButton(
        text: model.primaryButtonText,
        textColor: Colors.white,
        fontWeight: FontWeight.normal,
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(height: 10.0),
      Align(
        alignment: Alignment.center,
        child: TextButton(
          child: Text(model.secondaryText),
          onPressed: !model.isLoading ? _toggleFormType : null,
        ),
      )
    ];
  }

  TextFormField _buildEmailTextField() {
    bool showErrorText = model.submitted && !model.emailValidator.isValid(model.email);

    return TextFormField(
      controller: _emailTextFieldController,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@gmail.com',
        errorText: showErrorText ? model.invalidEmailErrorText : null,
        enabled: model.isLoading == false,
      ),
      onEditingComplete: () => _emailEditingComplete(),
      onChanged: model.updateEmail,
    );
  }

  TextFormField _buildPasswordTextField() {
    bool showErrorText = model.submitted && !model.passwordValidator.isValid(model.password);
    return TextFormField(
      controller: _passwordTextFieldController,
      obscureText: true,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? model.invalidPasswordErrorText : null,
        enabled: model.isLoading == false,
      ),
      onEditingComplete: _submit,
      onChanged: model.updatePassword,
    );
  }
}
