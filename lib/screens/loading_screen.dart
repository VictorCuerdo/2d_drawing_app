// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'homepage.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToHome();
    });
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 5), () {});
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LottieBuilder.asset(
              'assets/animations/loading.json',
              width: 320,
              height: 320,
              fit: BoxFit.fill,
              animate: true,
            ),
            const SizedBox(height: 15),
            RichText(
              text: const TextSpan(
                text: 'Testing',
                style: TextStyle(
                    color: Color(0xFF5B9851),
                    fontFamily: 'Work Sans',
                    fontWeight: FontWeight.w500,
                    fontSize: 68),
                children: [
                  TextSpan(
                    text: 'App',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w500,
                      fontSize: 68,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Image.asset(
              'assets/images/moraware_logo.png',
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}
