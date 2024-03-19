import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kwikq_app/pages/bottomnav.dart';
import 'package:kwikq_app/pages/home.dart';
import 'package:kwikq_app/pages/login.dart';
import 'package:kwikq_app/pages/onboard.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BottomNav();
          } else {
            return Onboard();
          }
        },
      ),
    );
  }
}
