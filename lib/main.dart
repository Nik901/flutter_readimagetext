import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


void main() =>runApp(MyApp());

class MyApp extends StatelessWidget{

  Widget build(BuildContext context){

    return MaterialApp(
      title: "",
      home: Scaffold(
        appBar: AppBar(title: Text("") ),
        body: MyStateful(),
      ),

    );                            //only return has ;
  }
}

class MyStateful extends StatefulWidget{

  _MyStateful createState() => _MyStateful();

}
class  _MyStateful extends State<MyStateful>{
  final _formKey = GlobalKey<FormState>();
  File pickedImage;
  bool isimgload= false;
  final FlutterTts ft=FlutterTts();


  Future picImage() async{
    var temp =await ImagePicker.pickImage(source: ImageSource.gallery);// can we use .camera

    setState(() {
      pickedImage=temp ;

      isimgload=true;
    });
  }

Future readtext() async{
    String s="";   //not declare it as String s i;e s!=null;

    FirebaseVisionImage myimg=FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeimg=FirebaseVision.instance.textRecognizer();// text recognized here
    VisionText readit=await recognizeimg.processImage(myimg);


    for(TextBlock block in readit.blocks){
      for(TextLine line in block.lines){
        for(TextElement w in line.elements){
          s +=w.text;
        }
      }
    }


    await ft.setLanguage("en-US");
    //await ft.setSpeechRate(0.7);
    //await ft.setPitch(1);
    print(ft.getVoices);
await ft.speak(s);
s="";
}

  Widget build(BuildContext context){

    return Scaffold(

      body: Column(
        children: <Widget>[
          SizedBox(height: 25.0),
         isimgload ? Center(    // check imgload or not
            child: Container(
              height: 250.0,
              width: 250.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(pickedImage),fit: BoxFit.cover)
                        // this actually show selected image but if button has any image then ..otherwise show error i;e File!=NULL
                )
              ),
            ):Container(),  //Container() :this if not imageloaded ;Filq==NULL (during app loaded 1st time)
         // ),
          SizedBox(height: 50.0),// space

          RaisedButton(
              child:Text('pic image'),
              onPressed: picImage,
            color: Colors.blue,
            textColor: Colors.white,
          ),

          SizedBox(height: 10.0),// space
          RaisedButton(
            child:Text('Read It'),
            onPressed: readtext,
            color: Colors.blue,
            textColor: Colors.white,
          ),

        ],
      ),
    );
  }
}