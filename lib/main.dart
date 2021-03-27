import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 200,
          maxWidth: 800,
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Time Tracker',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
          ),
          home: SignInScreen(),
        ),
      ),
    );
  }
}
