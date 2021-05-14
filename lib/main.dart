import 'dart:io';
import 'package:camera_and_push/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

void main() async {
  await ImageDBProvider.open();
  runApp(ChangeNotifierProvider(
    create: (context) => ImageDBProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera and push demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  ListPage({Key? key}) : super(key: key);
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  var _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Images"),
      ),
      body: Consumer<ImageDBProvider>(
        builder: (context, imageDB, child) {
          return FutureBuilder(
              future: imageDB.count(),
              builder: (context, AsyncSnapshot<int> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      //return Image.file(File(_imageRecords[index].file.path));
                      return FutureBuilder(
                        future: imageDB.get(index),
                        builder: ,
                      );
                    },
                    itemCount: snapshot.data,
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }
              /*
                  return ListView.builder(
                  itemBuilder: (context, index) {
                    //return Image.file(File(_imageRecords[index].file.path));
                    final record = _imageRecords[index];
                    return ListTile(
                      leading: Image.file(File(record.file.path)),
                      title: Text(record.timestamp.toString()),
                    );
                  },
                  itemCount: ,
          ),

               */
              );
        },
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
