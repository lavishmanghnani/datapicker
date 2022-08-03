import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? image;
  List<File> images = [];

  late DateTime selectedDateTime ;
  bool pressed = false;

  Future imagePickerFromGallery() async {
    try {
      final image1 =
          await ImagePicker.platform.pickImage(source: ImageSource.gallery);
      if (image1 == null) return;
      final imageTemporary = File(image1.path);
      setState(() => image = imageTemporary);
      image = imageTemporary;
      images.add( image!);
      setState((){});
      print(image.toString());
    } on PlatformException catch (e) {
      print('Failed to pick image : $e');
    }
  }

  Future imagePickerFromCamera() async {
    try {
      final image1 =
          await ImagePicker.platform.pickImage(source: ImageSource.camera);
      if (image1 == null) return;
      final imageTemporary = File(image1.path);
      setState(() => this.image = imageTemporary);
      this.image = imageTemporary;
      print(image.toString());
    } on PlatformException catch (e) {
      print('Failed to pick image : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[


              ElevatedButton(
                  onPressed: () {
                    imagePickerFromGallery();
                  },
                  child: const Text("Imagepicker form gallery")),
              ElevatedButton(
                  onPressed: () {
                    imagePickerFromCamera();
                    // if (image != null) {
                    //   Image.file(
                    //     image!,
                    //     fit: BoxFit.cover,
                    //     height: 100,
                    //     width: 100,
                    //   );
                    // } else {
                    //   AlertDialog();
                    // }
                  },
                  child: const Text("Imagepicker form camera")),
              image != null
                  ? Image.file(
                image!,
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              )
                  :SizedBox(),
              Column(
                children: List.generate(
                    images.length, (index) {
                  return Image.file(
                    images[index],
                    fit: BoxFit.cover,
                    height: 100,
                    width: 100,
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
