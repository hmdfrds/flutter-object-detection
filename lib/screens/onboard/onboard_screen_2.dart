import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardScreen2 extends StatelessWidget {
  const OnboardScreen2({Key? key}) : super(key: key);

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
              Lottie.asset('assets/speaking.json',
                  width: 250, height: 250, fit: BoxFit.cover),
              const SizedBox(height: 100),
              const Text(
                "Voice ",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const Text(
                "Will speak the object's name",
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
