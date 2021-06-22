import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:time_tracker_app/app/landing_screen.dart';
import 'package:time_tracker_app/services/auth.dart';
import 'package:window_size/window_size.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      setWindowTitle('Time Tracker');
      setWindowMinSize(const Size(400, 500));
      setWindowMaxSize(const Size(800, double.infinity));
      setWindowFrame(Rect.fromLTRB(0, 0, 600.0, 1000.0));
      // setWindowMaxSize(Size.infinite);
    }
  }
  await Firebase.initializeApp();
  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    FacebookAuth.i.webInitialize(
      appId: "315154693676920", //<-- YOUR APP_ID
      cookie: true,
      xfbml: true,
      version: "v9.0",
    );
  }
  FacebookAuth.i.isWebSdkInitialized;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 400,
          maxWidth: 500,
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Time Tracker',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            canvasColor: Colors.green,
          ),
          home: LandingScreen(
            auth: Auth(),
          ),
        ),
      ),
    );
  }
}
