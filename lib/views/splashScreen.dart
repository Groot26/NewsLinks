import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_wave/views/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const HomePage(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: SvgPicture.asset(
            'images/NewsLinksLogo.svg',
            semanticsLabel: 'Logo',
            fit: BoxFit.none,
          ),
        ),
      ),
    );
  }
}
