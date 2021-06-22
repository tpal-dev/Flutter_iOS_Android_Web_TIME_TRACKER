import 'package:flutter/material.dart';

class EmailSignInForm extends StatelessWidget {
  const EmailSignInForm({Key key}) : super(key: key);

  List<Widget> _buildChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: "test@gmail.com",
        ),
      ),
      TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
      ),
      SizedBox(height: 16.0),
      ElevatedButton(
        child: Text('Sign in'),
        onPressed: () {},
      ),
      SizedBox(height: 10.0),
      Align(
        alignment: Alignment.center,
        child: TextButton(
          child: Text(' Need an account? Register '),
          onPressed: () {},
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }
}
