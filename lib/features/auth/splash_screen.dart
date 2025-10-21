import 'package:e_commerce/core/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(Duration(seconds: 4));

    final authProvider = context.read<AuthenticationProvider>();

    if (authProvider.currentUser == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else if (!authProvider.isEmailVerified) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      await authProvider.loadUserAndInitialize(context);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'app_logo',
          child: LottieBuilder.asset(
            'assets/splash.json',
            width: 180,
            height: 180,
          ),
        ),
      ),
    );
  }
}
