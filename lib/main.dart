import 'package:adv_camera/adv_camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuelly Bon Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Fuelly Bon Scanner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Map<PermissionGroup, PermissionStatus> permissions = {};

  void initState() {
    super.initState();
    this.initAsyncState();
  }

  void initAsyncState() async {
    var p =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    print('checkPermissionStatus:' + p.toString());
    setState(() {
      permissions[PermissionGroup.camera] = p;
    });
    requestPermissions();
  }

  requestPermissions() async {
    if (!cameraAllowed()) {
      print('Please allow...');
      var p = await PermissionHandler()
          .requestPermissions([PermissionGroup.camera]);
      setState(() {
        permissions = p;
      });
    } else {
      print('Camera already allowed');
    }
  }

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
      body: !cameraAllowed()
          ? Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Checking permissions...',
                      textScaleFactor: 1.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: LinearProgressIndicator(),
                    ),
                    Text(
                      'Camera permission is required to make a photo',
                      textScaleFactor: 1.25,
                    ),
                    RaisedButton(
                      child: Text('Try again'),
                      onPressed: () {
                        this.requestPermissions();
                      },
                    )
                  ]))
          : Column(
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
      floatingActionButton: cameraAllowed()
          ? FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  bool cameraAllowed() {
    bool cameraAllowed = permissions != null &&
        permissions[PermissionGroup.camera] == PermissionStatus.granted;
    print('cameraAllowed: ${cameraAllowed.toString()}');
    return cameraAllowed;
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
