import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_chat_app/screens/auth_screen.dart';
import 'package:flutter_chat_app/screens/chat_screen.dart';
import 'package:flutter_chat_app/screens/splash_screen.dart';

import 'package:firebase_core/firebase_core.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    final ThemeData theme = ThemeData();
    return FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, appSnapshot) {
          return MaterialApp(
            title: 'FlutterChat',
            theme: theme.copyWith(
              primaryColor: Colors.pink,
              backgroundColor: Colors.pink,
              brightness: ThemeData.estimateBrightnessForColor(Colors.pink),
              colorScheme: theme.colorScheme.copyWith(
                secondary: Colors.deepPurple,
                brightness: ThemeData.estimateBrightnessForColor(
                  Colors.deepPurple,
                ),
              ),
              buttonTheme: ButtonTheme.of(context).copyWith(
                buttonColor: Colors.pink,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            home: appSnapshot.connectionState != ConnectionState.done
                ? const SplashScreen()
                : StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (ctx, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SplashScreen();
                      }
                      if (userSnapshot.hasData) {
                        return const ChatScreen();
                      }
                      return const AuthScreen();
                    }),
          );
        });
  }
}
