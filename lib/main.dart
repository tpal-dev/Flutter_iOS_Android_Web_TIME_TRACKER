import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/landing_screen.dart';
import 'package:window_size/window_size.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      setWindowTitle('Time Tracker');
      setWindowMinSize(const Size(400, 600));
      setWindowMaxSize(const Size(800, double.infinity));
      setWindowFrame(Rect.fromLTRB(0, 0, 600.0, 1000.0));
      // setWindowMaxSize(Size.infinite);
    }
  }
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 400,
          maxWidth: 800,
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Time Tracker',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
          ),
          home: LandingScreen(),
        ),
      ),
    );
  }
}
