import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platform_action_sheet/platform_action_sheet.dart';
import 'package:skinmed/homePage.dart';
import 'package:tflite/tflite.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File image;
  List _outputs;
  File _image;
  bool _loading = false;
  void openSheet() {
    PlatformActionSheet().displaySheet(context: context, actions: [
      ActionSheetAction(
        text: "Take Picture",
        onPressed: () => getImage(ImageSource.camera, context),
      ),
      ActionSheetAction(
        text: "Choose picture from gallery",
        onPressed: () => getImage(ImageSource.gallery, context),
      ),
    ]);
  }

  Future getImage(ImageSource source, BuildContext context) async {
    final result = await ImagePicker.platform.pickImage(source: source);
    Navigator.pop(context);
    if (result != null) {
      print("file picked");
      File file = File(result.path);

      setState(() {
        image = file;
      });
      classifyImage(image);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      _outputs = output;
      print("prediciton is " + output.toString());
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: HomeScreen());
  }
}
