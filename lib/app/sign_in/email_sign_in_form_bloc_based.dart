import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_app/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_app/custom_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_app/services/auth.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  EmailSignInFormBlocBased({Key key, @required this.bloc}) : super(key: key);
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInFormBlocBased(bloc: bloc),
      ),
    );
  }

  @override
  _EmailSignInFormBlocBasedState createState() => _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final TextEditingController _emailTextFieldController = TextEditingController();
  final TextEditingController _passwordTextFieldController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailTextFieldController.dispose();
    _passwordTextFieldController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailTextFieldController.clear();
    _passwordTextFieldController.clear();
  }

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, exception: e);
    }
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus =
        model.emailValidator.isValid(model.email) ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildColumnChildren(model),
            ),
          );
        });
  }

  List<Widget> _buildColumnChildren(EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      _buildPasswordTextField(model),
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

  TextFormField _buildEmailTextField(EmailSignInModel model) {
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
      onEditingComplete: () => _emailEditingComplete(model),
      onChanged: widget.bloc.updateEmail,
    );
  }

  TextFormField _buildPasswordTextField(EmailSignInModel model) {
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
      onChanged: widget.bloc.updatePassword,
    );
  }
}
