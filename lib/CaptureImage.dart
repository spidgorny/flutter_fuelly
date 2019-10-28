import 'package:adv_camera/adv_camera.dart';
import 'package:flutter/material.dart';

class CaptureImage extends StatefulWidget {
  CaptureImage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CaptureImageState createState() => _CaptureImageState();
}

class _CaptureImageState extends State<CaptureImage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    cameraController.captureImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Container(
            child: AdvCamera(
              onCameraCreated: _onCameraCreated,
              onImageCaptured: (String path) {
                setState(() {
//                  imagePath = path;
                  print(path);
                });
              },
              cameraPreviewRatio: CameraPreviewRatio.r16_9,
            ),
          )),
          Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.display1,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.camera),
      ),
    );
  }

  AdvCameraController cameraController;

  _onCameraCreated(AdvCameraController controller) {
    this.cameraController = controller;

    this.cameraController.getPictureSizes().then((pictureSizes) {
      print(pictureSizes);
      setState(() {
//        this.pictureSizes = pictureSizes;
      });
    });
  }
}
