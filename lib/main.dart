import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListPage(title: 'Camera Test'),
    );
  }
}

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ListPageState createState() => _ListPageState();
}

class ImageRecord {
  PickedFile file;
  DateTime timestamp;

  ImageRecord(this.file) {
    timestamp = DateTime.now();
  }
}

class _ListPageState extends State<ListPage> {
  var _imagePicker = ImagePicker();
  List<ImageRecord> _imageRecords = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          //return Image.file(File(_imageRecords[index].file.path));
          final record = _imageRecords[index];
          return ListTile (
            leading: Image.file(File(record.file.path)),
            title: Text(record.timestamp.toString()),
          );
        },
        itemCount: _imageRecords.length,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Take a image',
        child: Icon(Icons.add),
        onPressed: takeImage,
      ),
    );
  }

  void takeImage() async {
    var pickedImage = await _imagePicker.getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _imageRecords.add(ImageRecord(pickedImage));
      });
    }
  }
}
