// ignore_for_file: prefer_const_constructors

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraImage? imageCamera;
  late CameraController cameraController;
  bool isworking = false;
  String result = "";

  initCamera() {
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream((imagesFromStream) => {
              if (!isworking)
                {
                  isworking = true,
                  imageCamera = imagesFromStream,
                }
            });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                initCamera();
              },
              child: SizedBox(
                  height: 270,
                  width: 360,
                  child: imageCamera != null
                      ? AspectRatio(
                          aspectRatio: cameraController.value.aspectRatio,
                          child: CameraPreview(cameraController),
                        )
                      : Icon(Icons.photo_camera_front,
                          color: Colors.blueAccent, size: 40)),
            ),
          )
        ],
      ),
    );
  }
}
