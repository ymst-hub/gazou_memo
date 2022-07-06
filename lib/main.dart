import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

import 'add_page.dart';
import 'dbhelper.dart';
import 'edit_page.dart';
import 'memo_model.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '画像リスト',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'リスト'),
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
  List<Memo> MemoList = [];
  String _imagePath = '';
  bool isLoading = false;

  _setImagePath() async {
    _imagePath = (await getApplicationDocumentsDirectory()).path;
  }

  Future<String> _savePhoto(XFile photo) async {
    _setImagePath();
    final Uint8List buffer = await photo.readAsBytes();
    final String savePath = '$_imagePath/${photo.name}';
    final File saveFile = File(savePath);
    saveFile.writeAsBytesSync(buffer, flush: true, mode: FileMode.write);
    return saveFile.path;
  }

  @override
  void initState() {
    super.initState();
    Future(() async {
      getMemoList();
    });
  }

  // initStateで動かす処理。
  // MEMOテーブルに登録されている全データを取ってくる
  Future getMemoList() async {
    setState(() => isLoading = true);
    MemoList = await DbHelper.instance.selectAllMemo(); //Memoテーブルを全件読み込む
    _setImagePath();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final ImagePicker _picker = ImagePicker();
    File? _file;
    Future getTagData(String tags) async {
      setState(() => isLoading = true);
      MemoList = await DbHelper.instance.selectTagsMemo(tags); //Memoテーブルを全件読み込む
      _setImagePath();
      setState(() => isLoading = false);
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: TextField(
          onChanged: (text) {
            getTagData(text);
          },
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: '　検索',
            contentPadding: EdgeInsets.all(5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //カラム数
        ),
        itemCount: MemoList.length, //要素数
        itemBuilder: (context, index) {
          //要素を戻り値で返す
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: GestureDetector(
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute<Null>(
                          settings: const RouteSettings(),
                          builder: (BuildContext context) {
                            return EditPage(memo: MemoList[index]);
                          }));
                  setState(() {
                    getMemoList();
                  });
                },
                child: Image.file(File('$_imagePath/${MemoList[index].path}'), fit: BoxFit.cover)
            ),
          );
        },
        shrinkWrap: true,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final String path = (await getApplicationDocumentsDirectory()).path;
            final XFile? _image =
                await _picker.pickImage(source: ImageSource.gallery);
            _file = File(_image!.path);
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                // 遷移先の画面としてリスト追加画面を指定
                return AddPage(image: _image, file: _file);
              }),
            );
            await _savePhoto(_image);
            setState(() {
              getMemoList();
            });
          },
          child: Icon(Icons
              .add)), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
