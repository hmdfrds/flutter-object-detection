import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/screens/onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, required this.cameras}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();

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
        duration: 2500,
        splash: Image.asset("assets/Logo PSM.png"),
        // Lottie.asset('assets/blinking.json',
        //     width: 250, height: 250, fit: BoxFit.cover),
        nextScreen: OnboardScreen(
          cameras: widget.cameras,
        ),
        splashTransition: SplashTransition.rotationTransition,
      ),
    );
  }
}
