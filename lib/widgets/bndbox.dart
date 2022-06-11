
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';


class BndBox extends StatelessWidget {
  final List<CameraDescription> cameras;
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final String model;

  const BndBox(this.cameras, this.results, this.previewH, this.previewW,
      this.screenH, this.screenW, this.model,
      {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<String> object = [];

    List<Widget> _renderStrings() {
      object = [];
      double offset = -10;
      return results.map((re) {
        object.add(re["label"]);
        offset = offset + 14;
        return Positioned(
          left: 10,
          top: offset,
          width: screenW,
          height: screenH,
          child: Text(
            "${re["label"]} ${(re["confidence"] * 100).toStringAsFixed(0)}%",
            style: const TextStyle(
              color: Color.fromRGBO(37, 213, 253, 1.0),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList();
    }

    var render = _renderStrings();
    return Stack(children: render);
  }
}
