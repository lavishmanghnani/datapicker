import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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

  bool pressed = false;

  Future imagePickerFromGallery() async {
    try {
      final image1 =
          await ImagePicker.platform.pickImage(source: ImageSource.gallery);
      if (image1 == null) return;
      final imageTemporary = File(image1.path);
      setState(() => image = imageTemporary);
      image = imageTemporary;
      images.add(image!);
      setState(() {});
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
  

  TimeOfDay selectedTime = TimeOfDay.now();

  TextEditingController dateInput = TextEditingController();
  var date;

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
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
                    _selectTime(context);
                  },
                  child: const Text("Time picker")),
              ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate:date ?? DateTime.now(),
                        firstDate: DateTime(1950),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2100));

                    if (pickedDate != null) {
                      print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                      date = pickedDate;
                      print(formattedDate);
                      //formatted date output using intl package =>  2021-03-16
                      setState(() {
                        dateInput.text = formattedDate;
                        //set output date to TextField value.
                      });
                    } else {}
                  },
                  child: const Text("Date picker")),
              ElevatedButton(
                  onPressed: () {
                    imagePickerFromGallery();
                  },
                  child: const Text("Imagepicker form gallery")),
              ElevatedButton(
                  onPressed: () {
                    imagePickerFromCamera();
                  },
                  child: const Text("Imagepicker form camera")),
              SizedBox(
                height: 25,
              ),
              Text(
                  "Time and date  is : ${selectedTime.hour}:${selectedTime.minute}"),
              SizedBox(
                height: 25,
              ),
              Text("${dateInput.text}"),
              Column(
                children: List.generate(images.length, (index) {
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

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }
}
