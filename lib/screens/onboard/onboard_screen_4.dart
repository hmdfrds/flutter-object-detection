import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardScreen4 extends StatelessWidget {
  const OnboardScreen4({Key? key, required this.cameras}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/ai.png",
                height: 250,
              ),
              const SizedBox(height: 50),
              const Text(
                "Let's start with the tutorial",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('firstTime', false);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => MainScreen(
                                cameras: cameras,
                              ))));
                },
                child: const Text(
                  "Let's start",
                  style: TextStyle(fontSize: 30),
                ),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Colors.purple,
                  onSurface: Colors.grey,
                  side: const BorderSide(color: Colors.black, width: 1),
                  elevation: 10,
                  minimumSize: const Size(300, 75),
                  shadowColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
