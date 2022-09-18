import 'dart:developer';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/main.dart';
import 'package:object_detection/screens/main_screen.dart';
import 'package:object_detection/screens/onboard_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, required this.cameras}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  dynamic nextScreen = OnboardScreen(cameras: cameras!);

  @override
  void initState() {
    super.initState();
    setup();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splashIconSize: 250,
        duration: 3000,
        splash: Hero(
            tag: "assets/Logo PSM.png",
            child: Image.asset("assets/Logo PSM.png")),
        nextScreen: nextScreen,
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.bottomToTop,
      ),
    );
  }

  setup() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? firstTime = prefs.getBool('firstTime');

    log(firstTime.toString());
    if (firstTime != null && !firstTime) {
      setState(() {
        nextScreen = MainScreen(cameras: cameras!);
        log("message");
      });
    }
  }
}
