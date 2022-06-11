import 'dart:io';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:object_detection/models/picture.dart';

class PictureCard extends StatefulWidget {
  final Picture picture;
  const PictureCard({Key? key, required this.picture}) : super(key: key);

  @override
  State<PictureCard> createState() => _PictureCardState();
}

class _PictureCardState extends State<PictureCard> {
  FlutterTts flutterTts = FlutterTts();
  var confirmSentences = ["That is a ", "I am sure, that is a "];

  var unConfirmSentences = [
    "I not quite sure, i think that is a ",
    "Sorry I cannot detect that quite clearly. I think that a ",
  ];

  String spell = "";
  var colorizeColors = [
    Colors.blue,
    Colors.red,
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 175,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Confidence Level",
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${(widget.picture.confidence * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 35),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: Image.file(File(widget.picture.path)),
                          );
                        });
                  },
                  child: Image.file(
                    File(widget.picture.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (spell == "") {
                            for (int i = 0;
                                i < widget.picture.name.length;
                                i++) {
                              setState(() {
                                spell += widget.picture.name[i];
                              });
                              await flutterTts.speak(widget.picture.name[i]);
                            }
                            await flutterTts.speak(widget.picture.name);
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            setState(() {
                              spell = "";
                            });
                          }
                        },
                        child: const Text("spell"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          minimumSize:
                              const Size(double.infinity, double.infinity),
                        ),
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.picture.confidence * 100 > 75) {
                            flutterTts.speak(confirmSentences[
                                    Random().nextInt(confirmSentences.length)] +
                                widget.picture.name);
                          } else {
                            flutterTts.speak(unConfirmSentences[Random()
                                    .nextInt(unConfirmSentences.length)] +
                                widget.picture.name);
                          }
                        },
                        child: const Text(
                          "What is this",
                          textAlign: TextAlign.center,
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pink,
                          minimumSize:
                              const Size(double.infinity, double.infinity),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(color: Colors.white),
          alignment: Alignment.center,
          width: double.infinity,
          child: Stack(
            children: [
              Text(
                widget.picture.name,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              Text(
                spell,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Colors.red),
              ),
              Visibility(
                visible: widget.picture.name == spell,
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    ColorizeAnimatedText(widget.picture.name,
                        textStyle: const TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                        colors: colorizeColors,
                        speed: const Duration(milliseconds: 200)),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
