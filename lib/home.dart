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
      backgroundColor: Colors.black,
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              initCamera();
            },
            child: Center(
              child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width,
                  child: imageCamera != null
                      ? AspectRatio(
                          aspectRatio: cameraController.value.aspectRatio,
                          child: CameraPreview(cameraController),
                        )
                      : Icon(Icons.photo_camera_front,
                          color: Colors.black, size: 40)),
            ),
          ),
        ],
      ),
    );
  }
}
