import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fuelly/CaptureImage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'NavigationService.dart';
import 'locator.dart';

class CheckPermissions extends StatefulWidget {
  final String title;
  CheckPermissions({Key key, this.title}) : super(key: key);

  @override
  _CheckPermissionsState createState() => _CheckPermissionsState();
}

class _CheckPermissionsState extends State<CheckPermissions> {
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
    if (!cameraAllowed()) {
      requestPermissions();
    } else {
      goToNextPage();
    }
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
      goToNextPage();
    }
  }

  bool cameraAllowed() {
    bool cameraAllowed = permissions != null &&
        permissions[PermissionGroup.camera] == PermissionStatus.granted;
    print('cameraAllowed: ${cameraAllowed.toString()}');
    return cameraAllowed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
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
                ])));
  }

  final NavigationService _navigationService = locator<NavigationService>();

  void goToNextPage() {
    print('goToNextPage');
    _navigationService.push(MaterialPageRoute(
        builder: (context) => CaptureImage(title: widget.title)));
  }
}
