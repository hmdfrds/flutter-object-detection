import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final PageController _pageController;
  const HomeScreen(this._pageController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Hero(
                  tag: "assets/Logo PSM.png",
                  child: Image.asset(
                    "assets/background.png",
                    fit: BoxFit.cover,
                  )),
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const Spacer(
                    flex: 6,
                  ),
                  const Text(
                    "Click Here To Start",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(1,
                          duration: const Duration(
                            milliseconds: 1000,
                          ),
                          curve: Curves.ease);
                    },
                    child: Hero(
                      tag: "logo",
                      child: Image.asset(
                        "assets/Logo PSM.png",
                        width: 200,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
