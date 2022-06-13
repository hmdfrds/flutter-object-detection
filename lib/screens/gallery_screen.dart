import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:hive_flutter/adapters.dart';
import 'package:object_detection/boxes.dart';
import 'package:object_detection/models/picture.dart';
import 'package:object_detection/widgets/picture_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class GalleryScreen extends StatefulWidget {
  final PageController _pageController;
  const GalleryScreen(this._pageController, {Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
    //setup();
  }

  @override
  void dispose() {
    super.dispose();
  }

  setup() async {
    await Hive.openBox<Picture>('pictures');
    setState(() {
      loading = false;
    });
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
}
