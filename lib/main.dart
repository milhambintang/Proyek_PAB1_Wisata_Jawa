import 'package:flutter/material.dart';
import 'package:proyek_pab1_wisata_jawa/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyek_pab1_wisata_jawa/screens/sign_in.dart';
import 'package:proyek_pab1_wisata_jawa/screens/sign_up.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<bool> _checkSignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isSignedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkSignedIn(),
      builder: (context, snapshot) {
        // While waiting show a blank container to avoid layout issues
        if (!snapshot.hasData) return const SizedBox.shrink();

        final bool isSignedIn = snapshot.data!;

        return MaterialApp(
          initialRoute: isSignedIn ? '/' : '/signinscreen',
          routes: {
            '/': (_) => const HomeScreen(),
            '/signinscreen': (_) => const SignIn(),
            '/signupscreen': (_) => const SignUp(),
          },
        );
      },
    );
  }
}
