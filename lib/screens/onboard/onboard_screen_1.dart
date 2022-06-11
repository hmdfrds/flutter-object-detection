import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardScreen1 extends StatelessWidget {
  const OnboardScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset('assets/scan.json',
                  width: 250, height: 250, fit: BoxFit.cover),
              const SizedBox(height: 100),
              const Text(
                "Detect object from your camera",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const Text(
                "Over 1000+ of detectable objects",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
