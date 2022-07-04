import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'add_page.dart';

void main() async{
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
  List<File> _imageList = [];

  @override
  Widget build(BuildContext context) {
    final ImagePicker _picker = ImagePicker();
    File? _file;


    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, //カラム数
          ),
          itemCount: _imageList.length, //要素数
          itemBuilder: (context, index) {
            //要素を戻り値で返す
            return Image.file(
                _imageList[index], fit: BoxFit.cover
            );
          },
          shrinkWrap: true,
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final XFile? _image = await _picker.pickImage(source: ImageSource.gallery);
            _file = File(_image!.path);
            try {
              final newimage = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  // 遷移先の画面としてリスト追加画面を指定
                  return AddPage(image:_image,file:_file);
                }),
              );
              setState(() {
                // リスト追加
                _imageList.add(newimage);
              });
            }catch(e){
              print("null");
            }
          },
          child: Icon(Icons.add)
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

