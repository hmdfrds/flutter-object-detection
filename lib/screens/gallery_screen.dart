import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:object_detection/boxes.dart';
import 'package:object_detection/models/picture.dart';
import 'package:object_detection/widgets/picture_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class GalleryScreen extends StatefulWidget {
  final PageController _pageController;
  const GalleryScreen(this._pageController, {Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];
  GlobalKey spellKey = GlobalKey();
  GlobalKey objectKey = GlobalKey();
  GlobalKey slideKey = GlobalKey();
  bool loading = false;

  @override
  void initState() {
    super.initState();

    setup();
  }

  @override
  void dispose() {
    super.dispose();
  }

  setup() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? doneTutorial = prefs.getBool('doneTutorial');
    if (doneTutorial == null || doneTutorial != true) {
      Future.delayed(const Duration(seconds: 1), showTutorial);
    }
    // await Hive.openBox<Picture>('pictures');
    // setState(() {
    //   loading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff1f1f1),
        body: loading
            ? const CircularProgressIndicator()
            : ValueListenableBuilder<Box<Picture>>(
                valueListenable: Boxes.getPictures().listenable(),
                builder: (context, box, _) {
                  final pictures = box.values.toList().cast<Picture>();

                  if (pictures.isEmpty) {
                    return NestedScrollView(
                      physics: const BouncingScrollPhysics(),
                      headerSliverBuilder: (context, innerBoxIsScrolled) => [
                        SliverAppBar(
                          leading: IconButton(
                            icon: const Icon(CupertinoIcons.camera),
                            onPressed: () {
                              widget._pageController.animateToPage(1,
                                  duration: const Duration(
                                    milliseconds: 1000,
                                  ),
                                  curve: Curves.ease);
                            },
                          ),
                          pinned: true,
                          forceElevated: true,
                          iconTheme: const IconThemeData(color: Colors.black),
                          backgroundColor: Colors.white,
                          expandedHeight: 240,
                          flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.pin,
                            background: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Picture Saved",
                                    style: TextStyle(fontSize: 20)),
                                Text(
                                  pictures.length.toString(),
                                  style: const TextStyle(fontSize: 100),
                                ),
                              ],
                            ),
                            centerTitle: true,
                            title: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "GALLERY",
                                  style: TextStyle(color: Colors.black),
                                ),
                                const SizedBox(width: 10),
                                Image.asset(
                                  "assets/Logo PSM.png",
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                      body: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/kingdom-list-is-empty.png"),
                              const Text(
                                "Look like nothing is here",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                    );
                  }
                  return NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverAppBar(
                        leading: IconButton(
                          icon: const Icon(CupertinoIcons.camera),
                          onPressed: () {
                            widget._pageController.animateToPage(1,
                                duration: const Duration(
                                  milliseconds: 1000,
                                ),
                                curve: Curves.ease);
                          },
                        ),
                        pinned: true,
                        forceElevated: true,
                        iconTheme: const IconThemeData(color: Colors.black),
                        backgroundColor: Colors.white,
                        expandedHeight: 240,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.pin,
                          background: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Picture Saved",
                                  style: TextStyle(fontSize: 20)),
                              Text(
                                pictures.length.toString(),
                                style: const TextStyle(fontSize: 100),
                              ),
                            ],
                          ),
                          centerTitle: true,
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "GALLERY",
                                style: TextStyle(color: Colors.black),
                              ),
                              const SizedBox(width: 10),
                              Image.asset(
                                "assets/Logo PSM.png",
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                    body: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Slidable(
                                key: ValueKey(index),
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      // An action can be bigger than the others.
                                      flex: 2,
                                      onPressed: (context) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    "Confirm Delete"),
                                                content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Text(
                                                          "Are you sure you want to delete this?"),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  "Cancel")),
                                                          TextButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  pictures[
                                                                          index]
                                                                      .delete();

                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                });
                                                              },
                                                              child: const Text(
                                                                  "Delete"))
                                                        ],
                                                      )
                                                    ]),
                                              );
                                            });
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: CupertinoIcons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: PictureCard(
                                  spellKey,
                                  objectKey,
                                  slideKey,
                                  picture: pictures[index],
                                ));
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 40);
                          },
                          itemCount: pictures.length),
                    ),
                  );
                }),
      ),
    );
  }

  void showTutorial() {
    initTargets();
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.red,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () async {
        print("finish");
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('doneTutorial', true);
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) async {},
      onClickOverlay: (target) async {
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
        identify: "objectKey",
        keyTarget: objectKey,
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
                    "This button is the same as before.It will make a voice speak up the object name from the image",
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
        identify: "spellKey",
        keyTarget: spellKey,
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
                    "This button also work the same as the spell key before",
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
        shape: ShapeLightFocus.RRect,
        identify: "slideKey",
        keyTarget: slideKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Lottie.asset("assets/82008-swipe-left.json",
                      height: 200, width: 200),
                  const Text(
                    "You can slide this card to delete.",
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
}
