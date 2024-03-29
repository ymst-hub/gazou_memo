//https://qiita.com/apricotcomic/items/1ef423088c5f67dd0ae4

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gazou_memo/memo_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';

import 'dbhelper.dart';

class AddPage extends StatefulWidget {
  final XFile? image;
  final File? file;
  AddPage({this.image, this.file});

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
    return WillPopScope(
      onWillPop: () async {

        Memo memo = new Memo(path:_image!.name,
            tags:tagscontroller.text,
            sentense: sentensescontroller.text
        );
        await DbHelper.instance.insert(memo);
        Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('画像メモ'),
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
                        controller: sentensescontroller,
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
                    ],
                  ),
                ),
              ],
            ),
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
