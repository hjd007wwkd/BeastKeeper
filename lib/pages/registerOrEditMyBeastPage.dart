import "dart:convert";
import "dart:io";
import "dart:async";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:provider/provider.dart";
import "../utilities/stringUtilities.dart";
import "../dbActions/myBeastWriter.dart";
import "../stateModel/myBeastsStateModel.dart";
import "../models/myBeastDetailInfoModel.dart";
import "../models/myBeastSimpleInfoModel.dart";

class RegisterOrEditMyBeastPage extends StatefulWidget {

  final MyBeastDetailInfoModel myBeastDetailInfo;
  final void Function(MyBeastDetailInfoModel myBeast) onInfoChange;

  RegisterOrEditMyBeastPage({this.myBeastDetailInfo, this.onInfoChange});

  @override
  _RegisterOrEditMyBeastPageState createState() => _RegisterOrEditMyBeastPageState();
}

class _RegisterOrEditMyBeastPageState extends State<RegisterOrEditMyBeastPage> {
  File image;
  String name;
  String age;
  String description;

  Image initialImageForEdit;

  String imageValidationErrorMessage;
  String nameValidationErrorMessage;
  String ageValidationErrorMessage;
  String descriptionValidationErrorMessage;

  MyBeastDetailInfoModel myBeast;

  String title = "Register";
  
  @override
  void initState() {
    super.initState();
    setState((){
      myBeast = widget.myBeastDetailInfo;
      if(widget.myBeastDetailInfo != null){
        name = widget.myBeastDetailInfo.name;
        age = widget.myBeastDetailInfo.age.toString();
        description = widget.myBeastDetailInfo.description;
        initialImageForEdit = Image.memory(base64Decode(widget.myBeastDetailInfo.image));
        title = "Edit";
      }
    });
  }

  Future getImage(ImageSource imageSource) async {
    var pickedImage = await ImagePicker.pickImage(source: imageSource);

    setState(() {
      image = pickedImage;
    });
  }

  Widget inputField(String inputName, String validationMessage, String initialValue){
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        textDirection: TextDirection.ltr,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Container(
              width: 90.0,
              child: Text("$inputName:", textDirection: TextDirection.ltr,)
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[ 
                TextFormField(
                  keyboardType: inputName == "Age" ? TextInputType.number : TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: inputName
                  ),
                  initialValue: initialValue,
                  onChanged: (input){
                    setState(() {
                      if(inputName == "Name"){
                        name = input;
                      } else if(inputName == "Age"){
                        age = input;
                      } else if(inputName == "Description"){
                        description = input;
                      }
                    });
                  },
                ),
                Text(validationMessage == null ? "" : validationMessage, style: TextStyle(color: Colors.red))
              ]
            ),
          ),
        ],
      ),
    );
  }

  Widget iconButtonForPhoto(IconData icon, String action){
    return Container(
      margin: EdgeInsets.all(10.0),
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 0.5),
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.blue
      ),
      child: Center(
        child: IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: () async {
            ImageSource imageSource = action == "openGallery" ? ImageSource.gallery : ImageSource.camera;
            await getImage(imageSource);
          },
        )
      )
    );
  }

  Widget imageWidget(){
    Widget widget;
    if(myBeast == null && image == null){
      widget = Column(
        children: <Widget>[
          Container(
            width: 100.0,
            height: 200.0,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey, width: 0.5)
            ),
            child: Center(child: Text("No Image"),)
          ),
          Text(imageValidationErrorMessage == null ? "" : imageValidationErrorMessage, style: TextStyle(color: Colors.red),)
        ]
      );
    } else {
      widget = Container(height:400.0, child: image != null ? Image.file(image) : initialImageForEdit);
    }

    return widget;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyBeastsStateModel>(context);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("$title My Beast"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0, right: 15.0, left: 15.0),
          child: ListView(
            children: <Widget>[
              imageWidget(),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    iconButtonForPhoto(Icons.add_a_photo, "openCamera"),
                    iconButtonForPhoto(Icons.insert_photo, "openGallery"),
                  ],
                ),
              ),
              inputField("Name", nameValidationErrorMessage, myBeast != null ? myBeast.name : ""),
              inputField("Age", ageValidationErrorMessage, myBeast != null ? myBeast.age.toString() : ""),
              inputField("Description", descriptionValidationErrorMessage, myBeast != null ? myBeast.description : ""),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: FlatButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 50.0, left: 50.0),
                    splashColor: Colors.blueAccent,
                    child: Text(title),
                    onPressed: () async {                                            
                      if((image == null && myBeast == null) || name.isNullOrEmpty() || age.isNullOrEmpty() || int.tryParse(age) == null || description.isNullOrEmpty()){
                        setState(() {
                          imageValidationErrorMessage = null;
                          nameValidationErrorMessage = null;
                          ageValidationErrorMessage = null;
                          descriptionValidationErrorMessage = null;
                          if(image == null){
                            imageValidationErrorMessage = "Please select one image.";
                          }
                          if(name.isNullOrEmpty()){
                            nameValidationErrorMessage = "Name field is required.";
                          }
                          if(age.isNullOrEmpty()){
                            ageValidationErrorMessage = "Age field is required.";
                          } else if(int.tryParse(age) == null){
                            ageValidationErrorMessage = "Age has to be integer.";
                          }
                          if(description.isNullOrEmpty()){
                            descriptionValidationErrorMessage = "Description field is required.";
                          }
                        });
                      } else {
                        String imageStr;
                        if(image == null && myBeast != null){
                          imageStr = myBeast.image;
                        } else {
                          imageStr = base64Encode(image.readAsBytesSync());
                        }

                        MyBeastDetailInfoModel myBeastDetailInfo = MyBeastDetailInfoModel(
                          id: title == "Register" ? null : myBeast.id,
                          image: imageStr, 
                          name: name,
                          age: int.parse(age), 
                          description: description
                        );
                        
                        int id;
                        if(title == "Register"){
                          id = await MyBeastWriter.insertMyBeast(myBeastDetailInfo);
                        } else {
                          await MyBeastWriter.updateMyBeast(myBeastDetailInfo);
                          id = myBeastDetailInfo.id;
                          
                        }                          
                
                        MyBeastSimpleInfoModel myBeastSimpleInfo = MyBeastSimpleInfoModel(
                          id: id, 
                          image: imageStr, 
                          name: name,
                          description: description
                        );

                        if(title == "Register"){
                          provider.addMyBeastSimpleInfo(myBeastSimpleInfo);
                        } else {
                          provider.updateMyBeastSimpleInfo(myBeastSimpleInfo);
                          widget.onInfoChange(myBeastDetailInfo);
                        }
                          
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                )
              )
            ],
          ),
        ),
      )
    ); 
  }
}