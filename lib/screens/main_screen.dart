import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/screens/camera_screen.dart';
import 'package:object_detection/screens/gallery_screen.dart';
import 'package:object_detection/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.cameras}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(keepPage: false);
    pages = [
      HomeScreen(_pageController),
      CameraScreen(widget.cameras, _pageController),
      GalleryScreen(_pageController),
    ];
  }

  var pages = [];
  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pages.length,
          controller: _pageController,
          itemBuilder: ((context, index) {
            return pages[index];
          })),
    );
  }
}
