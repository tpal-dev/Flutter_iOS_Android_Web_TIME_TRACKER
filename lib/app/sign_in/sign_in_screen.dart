import 'package:flutter/material.dart';
import 'package:time_tracker_app/custom_widgets/custom_elevated_button.dart';

class SignInScreen extends StatelessWidget {
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Sign In',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 15.0),
          CustomElevatedButton(
            child: Text('Sign in with Google'),
            primaryColor: Colors.black,
            backgroundColor: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
