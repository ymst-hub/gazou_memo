import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';

class AddPage extends StatefulWidget {
  String _imagePath = '';
  final XFile? image;
  final File? file;
  AddPage({this.image,this.file});
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late final XFile? _image = widget.image;
  late final File? _file = widget.file;
  final tagscontroller = TextEditingController();
  final sentensescontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('画像メモ'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => {
                Navigator.of(context).pop(_file)
              },
            ),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => {
                Navigator.of(context).pop()
                },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(child: _displaySelectionImageOrGrayImage()),
                      SizedBox(
                        width: 1.0,
                        height: 30.0,
                      ),
                      /*
                      TextField(
                        controller: tagscontroller,
                        maxLength: 15,
                        decoration: InputDecoration(
                          hintText: 'タグを入力してください',
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.blueAccent),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 1.0,
                        height: 30.0,
                      ),
                      TextField(
                        controller: tagscontroller,
                        maxLength: 120,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: '本文',
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.blueAccent),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      ),
                       */
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  Widget _displaySelectionImageOrGrayImage() {
    if (_image == null) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xffdfdfdf),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(),
        child: ClipRRect(
          child: Image.file(
            _file!,
            fit: BoxFit.fill,
          ),
        ),
      );
    }
  }
}