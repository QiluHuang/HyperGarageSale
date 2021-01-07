import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hypergaragesale/model/rounded_button.dart';
import 'package:hypergaragesale/screens/camera_screen.dart';

class PicturePreviewScreen extends StatelessWidget {
  static String id = "picture";
  final String imagePath;

  const PicturePreviewScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.file(File(imagePath)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text('Retake'),
                elevation: 8.0,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                onPressed: () async {
                  final cameras = await availableCameras();
                  final camera = cameras.first;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraScreen(camera: camera),
                    ),
                  );
                },
              ),
              RaisedButton(
                child: Text('Use It'),
                elevation: 8.0,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                onPressed: () {
                  Navigator.pop(context, imagePath);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
