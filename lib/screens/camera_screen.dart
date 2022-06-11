import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:object_detection/boxes.dart';
import 'package:object_detection/models/picture.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite/tflite.dart';

import '../widgets/camera.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final PageController _pageController;

  const CameraScreen(
    this.cameras,
    this._pageController, {
    Key? key,
  }) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool loading = true;
  FlutterTts flutterTts = FlutterTts();

  String object = "";
  String spell = "";
  double confidence = 0;
  bool visible = true;

  @override
  void initState() {
    super.initState();
    setUp();
  }

  setUp() async {
    await loadModel();
    await flutterTts.setPitch(7.0);
    //await Hive.openBox<Picture>('pictures');
    flutterTts.awaitSpeakCompletion(true);
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  var confirmSentences = ["That is a ", "I am sure, that is a "];

  var unConfirmSentences = [
    "I not quite sure, i think that is a ",
    "Sorry I cannot detect that quite clearly. I think that a ",
  ];

  loadModel() async {
    String res;
    res = (await Tflite.loadModel(
        model: "assets/mobilenet_v1.tflite",
        labels: "assets/mobilenet_v1.txt"))!;
  }

  setRecognitions(List<dynamic> recognitions, imageHeight, imageWidth) {
    if (mounted) {
      setState(() {
        if (recognitions.isNotEmpty) {
          object = recognitions.first["label"];
          confidence = recognitions.first["confidence"];
        }
      });
    }
  }

  var colorizeColors = [
    Colors.blue,
    Colors.black,
  ];
  String currentObject = "";

  @override
  void dispose() {
    //Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: loading
            ? const CircularProgressIndicator()
            : Padding(
                padding: visible
                    ? const EdgeInsets.symmetric(horizontal: 30)
                    : EdgeInsets.zero,
                child: Column(
                  children: [
                    Visibility(
                      visible: visible,
                      child: Row(
                        children: [
                          IconButton(
                            splashRadius: 20,
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft,
                            onPressed: () {
                              widget._pageController.animateToPage(0,
                                  duration: const Duration(
                                    milliseconds: 1000,
                                  ),
                                  curve: Curves.ease);
                            },
                            icon: const Icon(CupertinoIcons.home),
                          ),
                          const Spacer(),
                          Image.asset(
                            "assets/Logo PSM.png",
                            width: 40,
                          ),
                          const Spacer(),
                          IconButton(
                            splashRadius: 20,
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerRight,
                            onPressed: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: ((context) => GalleryScreen(widget._pageController))));
                              widget._pageController.animateToPage(2,
                                  duration: const Duration(
                                    milliseconds: 1000,
                                  ),
                                  curve: Curves.ease);
                            },
                            icon: const Icon(CupertinoIcons.photo),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(visible ? 30 : 0),
                            child: SizedBox(
                              height: double.infinity,
                              width: double.infinity,
                              child: Camera(
                                widget.cameras,
                                "MobileNet",
                                setRecognitions,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Visibility(
                              visible: spell != "",
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: FittedBox(
                                  child: Text(
                                    spell,
                                    style: const TextStyle(
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Visibility(
                              visible:
                                  currentObject == spell && currentObject != "",
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: FittedBox(
                                  child: AnimatedTextKit(
                                    isRepeatingAnimation: false,
                                    animatedTexts: [
                                      ColorizeAnimatedText(currentObject,
                                          textStyle: const TextStyle(
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold),
                                          colors: colorizeColors,
                                          speed: const Duration(
                                              milliseconds: 200)),
                                    ],
                                  ),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Visibility(
                    //   visible: visible,
                    //   child: BndBox(
                    //       widget.cameras,
                    //       _recognitions,
                    //       math.max(_imageHeight, _imageWidth),
                    //       math.min(_imageHeight, _imageWidth),
                    //       screen.height,
                    //       screen.width,
                    //       "MobileNet"),
                    // ),

                    Visibility(
                      visible: visible,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                              child: IconButton(
                                onPressed: () async {
                                  currentObject = object;
                                  for (int i = 0;
                                      i < currentObject.length;
                                      i++) {
                                    setState(() {
                                      spell += currentObject[i];
                                    });
                                    await flutterTts.speak(currentObject[i]);
                                  }
                                  await flutterTts.speak(currentObject);
                                  await Future.delayed(
                                      const Duration(milliseconds: 500));
                                  setState(() {
                                    spell = "";
                                  });
                                },
                                icon: const Icon(
                                  Icons.abc,
                                  size: 30,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.grey, width: 4)),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.pink),
                                child: IconButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text((confidence * 100)
                                                .toString())));
                                    if (confidence * 100 > 75) {
                                      flutterTts.speak(confirmSentences[Random()
                                              .nextInt(
                                                  confirmSentences.length)] +
                                          object);
                                    } else {
                                      flutterTts.speak(unConfirmSentences[
                                              Random().nextInt(
                                                  unConfirmSentences.length)] +
                                          object);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.data_object,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                              child: IconButton(
                                onPressed: () async {
                                  if (await getStoragePermission()) {
                                    setState(() {
                                      visible = false;
                                    });
                                    String o = object;
                                    double c = confidence;
                                    await Future.delayed(
                                        const Duration(milliseconds: 100));

                                    NativeScreenshot.takeScreenshot()
                                        .then((value) async {
                                      EasyLoading.show();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              SnackBar(content: Text(value!)));

                                      final picture = Picture()
                                        ..confidence = c
                                        ..name = o
                                        ..path = value;

                                      final box = Boxes.getPictures();
                                      box.add(picture);

                                      setState(() {
                                        visible = true;
                                      });

                                      EasyLoading.dismiss();
                                    });
                                  }
                                },
                                icon: const Icon(
                                  Icons.save,
                                  size: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<bool> getStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      return await Permission.storage.request().isGranted;
    }
    return true;
  }
}
