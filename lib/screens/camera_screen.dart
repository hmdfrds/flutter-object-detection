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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite/tflite.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];

  GlobalKey objectButton = GlobalKey();
  GlobalKey spellButton = GlobalKey();
  GlobalKey saveButton = GlobalKey();
  GlobalKey galleryButton = GlobalKey();

  bool loading = true;
  FlutterTts flutterTts = FlutterTts();
  bool again = true;
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
    await flutterTts.setPitch(1.0);
    await getStoragePermission();
    //await Hive.openBox<Picture>('pictures');
    flutterTts.awaitSpeakCompletion(true);
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
    final prefs = await SharedPreferences.getInstance();
    final bool? doneTutorial = prefs.getBool('doneTutorial');
    if (doneTutorial == null || doneTutorial != true) {
      Future.delayed(const Duration(seconds: 1), showTutorial);
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
                            key: galleryButton,
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
                              key: spellButton,
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
                              key: objectButton,
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
                                    if (confidence * 100 > 65) {
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
                              key: saveButton,
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

  void showTutorial() {
    if (again) {
      initTargets();
      again = false;
    }

    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.red,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) async {
        if (target.keyTarget == objectButton) {
          if (confidence * 100 > 65) {
            flutterTts.speak(
                confirmSentences[Random().nextInt(confirmSentences.length)] +
                    object);
          } else {
            flutterTts.speak(unConfirmSentences[
                    Random().nextInt(unConfirmSentences.length)] +
                object);
          }
        } else if (target.keyTarget == spellButton) {
          currentObject = object;
          for (int i = 0; i < currentObject.length; i++) {
            setState(() {
              spell += currentObject[i];
            });
            await flutterTts.speak(currentObject[i]);
          }
          await flutterTts.speak(currentObject);
          await Future.delayed(const Duration(milliseconds: 500));
          setState(() {
            spell = "";
          });
        } else if (target.keyTarget == saveButton) {
          if (await getStoragePermission()) {
            setState(() {
              visible = false;
            });
            String o = object;
            double c = confidence;
            await Future.delayed(const Duration(milliseconds: 1000));

            NativeScreenshot.takeScreenshot().then((value) async {
              EasyLoading.show();
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(value!)));

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
              targets.clear();
              targets.add(
                TargetFocus(
                  shape: ShapeLightFocus.Circle,
                  identify: "galleryButton",
                  keyTarget: galleryButton,
                  alignSkip: Alignment.centerRight,
                  contents: [
                    TargetContent(
                      align: ContentAlign.bottom,
                      builder: (context, controller) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const <Widget>[
                            Text(
                              "This button will bring you to the gallery",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
              showTutorial();
            });
          }
        } else if (target.keyTarget == galleryButton) {
          widget._pageController.animateToPage(2,
              duration: const Duration(
                milliseconds: 1000,
              ),
              curve: Curves.ease);
        } else {}
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () async {
        print("skip");
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('doneTutorial', true);
      },
    )..show();
  }

  void initTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        shape: ShapeLightFocus.Circle,
        identify: "objectButton",
        keyTarget: objectButton,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    "This button will make a voice speak up the object name that pointed at the camera",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        shape: ShapeLightFocus.Circle,
        identify: "spellButton",
        keyTarget: spellButton,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    "This button will make a voice spell the object",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        shape: ShapeLightFocus.Circle,
        identify: "saveButton",
        keyTarget: saveButton,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    "This button will save the current images from your camera view",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
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
