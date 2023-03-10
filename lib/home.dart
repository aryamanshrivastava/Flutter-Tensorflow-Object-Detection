// ignore_for_file: prefer_const_constructors

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  late CameraController cameraController;
  CameraImage? imageCamera;
  bool isWorking = false;
  String result = "";

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    cameraController = CameraController(firstCamera, ResolutionPreset.medium);
    await cameraController.initialize();
    cameraController.startImageStream((imagesFromStream) {
      if (!isWorking) {
        isWorking = true;
        imageCamera = imagesFromStream;
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    cameraController.stopImageStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: imageCamera != null
                  ? AspectRatio(
                      aspectRatio: cameraController.value.aspectRatio,
                      child: CameraPreview(cameraController),
                    )
                  : Center(
                      child: Icon(
                        Icons.photo_camera_front,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
