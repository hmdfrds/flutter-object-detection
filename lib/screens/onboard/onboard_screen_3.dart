import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardScreen3 extends StatelessWidget {
  const OnboardScreen3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Lottie.asset('assets/spell.json',
                      width: 250, height: 250, fit: BoxFit.cover),
                  Positioned(
                    bottom: 0,
                    child: Lottie.asset('assets/hola.json',
                        width: 150, height: 150, fit: BoxFit.cover),
                  ),
                ],
              ),
              const SizedBox(height: 100),
              const Text(
                "Spelling",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const Text(
                "Know how to speed the object with the voice",
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
