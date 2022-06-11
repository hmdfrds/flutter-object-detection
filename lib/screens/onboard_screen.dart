import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/main.dart';
import 'package:object_detection/screens/onboard/onboard_screen_1.dart';
import 'package:object_detection/screens/onboard/onboard_screen_2.dart';
import 'package:object_detection/screens/onboard/onboard_screen_3.dart';
import 'package:object_detection/screens/onboard/onboard_screen_4.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({Key? key, required this.cameras}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final PageController _pageController = PageController();
  final _pages = [
    const OnboardScreen1(),
    const OnboardScreen2(),
    const OnboardScreen3(),
    OnboardScreen4(
      cameras: cameras!,
    )
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PageView.builder(
              physics: const BouncingScrollPhysics(),
              allowImplicitScrolling: true,
              controller: _pageController,
              itemCount: _pages.length,
              itemBuilder: (_, index) {
                return _pages[index];
              },
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SmoothPageIndicator(
                  count: _pages.length,
                  controller: _pageController,
                ),
              ),
            ),
            Positioned(
                child: TextButton(
              child: const Text("skip"),
              onPressed: () {
                _pageController.animateToPage(3,
                    duration: const Duration(seconds: 1), curve: Curves.ease);
              },
            )),
          ],
        ),
      ),
    );
  }
}
