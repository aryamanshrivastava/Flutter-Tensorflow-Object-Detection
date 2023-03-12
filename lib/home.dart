// ignore_for_file: prefer_const_constructors

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/main.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController cameraController;
  CameraImage? imageCamera;
  bool isWorking = false;
  String result = "";

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/label.txt",
    );
  }

  Future<void> initCamera() async {
    cameraController = CameraController(
      cameras![0],
      ResolutionPreset.medium,
    );
    await cameraController.initialize();
    if (!mounted) return;
    cameraController.startImageStream((imageFromStream) {
      if (!isWorking) {
        isWorking = true;
        imageCamera = imageFromStream;
        runModelOnStreamFrames();
      }
    });
  }

  Future<void> runModelOnStreamFrames() async {
    if (imageCamera == null) return;
    var recognitions = await Tflite.runModelOnFrame(
      bytesList: imageCamera!.planes.map((plane) => plane.bytes).toList(),
      imageHeight: imageCamera!.height,
      imageWidth: imageCamera!.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      numResults: 1,
      threshold: 0.1,
      asynch: true,
    );
    result = "";
    recognitions?.forEach((response) {
      result +=
          "${response["label"]} ${(response["confidence"] as double).toStringAsFixed(2)}\n\n";
    });
    setState(() {});
    isWorking = false;
  }

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  void dispose() async {
    await Tflite.close();
    await cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          ElevatedButton(
            onPressed: initCamera,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: imageCamera != null
                  ? AspectRatio(
                      aspectRatio: cameraController.value.aspectRatio,
                      child: CameraPreview(cameraController),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width,
                      child: Icon(
                        Icons.photo_camera_front,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          Center(
            child: Text(
              result,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
