import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final String uploadEndPoint = 'http://10.0.2.2:3000/';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload(fileName);
  }

  upload(String fileName) {
    http.post(uploadEndPoint, body: {
      "image": base64Image,
      "name": fileName,
    }).then((result){
      setStatus(result.statusCode == 200 ? result.body : errMessage);
    }).catchError((error) {
      setStatus(error);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
        future: file,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              null != snapshot.data) {
            tmpFile = snapshot.data;
            base64Image = base64Encode(snapshot.data.readAsBytesSync());
            return Flexible(
              child: Image.file(snapshot.data, fit: BoxFit.fill),
            );
          } else if (null != snapshot.error) {
            return Center(child: Text('Error Picking Image'));
          } else {
            return Center(child: Text('No image Selected'));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          OutlineButton(
            onPressed: chooseImage,
            child: Text('Choose image'),
          ),
          SizedBox(height: 20.0),
          showImage(),
          SizedBox(height: 20.0),
          OutlineButton(
            onPressed: startUpload,
            child: Text('Upload Image'),
          ),
          SizedBox(height: 20.0),
          Text(
            status,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 20.0),
          ),
        ],
      ),
    );
  }
}
