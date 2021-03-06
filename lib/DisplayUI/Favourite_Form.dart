/*
Author      : IT17136402 - W.M.H.B. Warnakulasooriya
Description : Creating the input screen for fruit crud
Reference-1 : https://github.com/JulianCurrie/CwC_Flutter
Reference-2 : https://www.youtube.com/watch?v=bjMw89L61FI
Reference-3 : https://github.com/TechieBlossom/sidebar_animation_flutter
Reference-4 : https://apkpure.com/flutter-mobile-restaurantui-kit/com.jideguru.restaurant_ui_kit
 */

import 'dart:io';

import 'package:finalproject/LearnAFruit_Api/Fruit_Api_Handler.dart';
import 'package:finalproject/Crudmodel/FruitCrudModel.dart';
import 'package:finalproject/CrudControllers/Fruit_Controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

//creating the class to input favorite fruit details for adding the details of the favorite fruit
class FavouriteForm extends StatefulWidget {
  
  //checking whether needs to update or not
  final bool isUpdating;

  //loading the details to the constructor
  FavouriteForm({@required this.isUpdating});
  
  //handle the fruit form state
  @override
  _FavouriteFormState createState() => _FavouriteFormState();
}

//creating the class to input favorite fruit details for adding the details of the favorite fruit
class _FavouriteFormState extends State<FavouriteForm> {
  
  //declaring the global form key to maintain form state
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  //declaring the global scaffold key to maintain scaffold state
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //creating the list handler to store countries
  List _countries = [];

  //creating the current favorite fruit details object
  FruitCrudModel _currentFruit;

  //creating the image url for the favorite fruit
  String _imageUrl;
  
  //creating the image file to store in cloud store bucket
  File _imageFile;
  
  //creating the text field controller to country adder
  TextEditingController countriesController = new TextEditingController();

  //maintaining the state of the favorite fruit controller
  @override
  void initState() {
    super.initState();
    
    FruitController fruitNotifier = Provider.of<FruitController>(context, listen: false);
    
    //checking if current favorite fruit object is null then load the current details
    if (fruitNotifier.currentFruit != null) {
      _currentFruit = fruitNotifier.currentFruit;
    } else {
      _currentFruit = FruitCrudModel();
    }

    _countries.addAll(_currentFruit.countries);
    _imageUrl = _currentFruit.image;
  }

  //check if the the file and image url is null then show in the placeholder as image placeholder otherwise print in console as showing image from local file
  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Text(" ");
    } else if (_imageFile != null) {
      print('showing image from local file');

      //designing the ui level
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    } else if (_imageUrl != null) {
      print('showing image from url');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
            height: 200,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }
  }

  //getting the image file from image gallery to load image in the placeholder
  _getLocalImage() async {
    File imageFile =
    await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 100, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  //handle the name field with validation using text form controller
  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Fruit Name'),
      initialValue: _currentFruit.name,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }

        return null;
      },
      onSaved: (String value) {
        _currentFruit.name = value;
      },
    );
  }

//validating fruit family field
  Widget _buildCategoryField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Fruit Family'),
      initialValue: _currentFruit.category,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Fruit Family is required';
        }

        return null;
      },
      onSaved: (String value) {
        _currentFruit.category = value;
      },
    );
  }

  //handle the available country field with validation using text form controller
  _buildCountryField() {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: countriesController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(labelText: 'Available Countries'),
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  //sending the uploaded favorite fruit details to add to the cloud store
  _onFruitUploaded(FruitCrudModel fruit) {
    FruitController fruitNotifier = Provider.of<FruitController>(context, listen: false);
    fruitNotifier.addFruit(fruit);
    Navigator.pop(context);
  }

  //controlling the text form state whether empty or add the text if it is not empty
  _addCountry(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _countries.add(text);
      });
      countriesController.clear();
    }
  }

   //save the current state of the form text forms
  _saveFavouriteFruit() {
    print('saveFruit Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');

    _currentFruit.countries = _countries;

    uploadFavouriteFruitAndImage(_currentFruit, widget.isUpdating, _imageFile, _onFruitUploaded);

    print("name: ${_currentFruit.name}");
    print("category: ${_currentFruit.category}");
    print("Countries: ${_currentFruit.countries.toString()}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  //UI Layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Favourite Fruit Form')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(children: <Widget>[
            _showImage(),
            SizedBox(height: 16),
            Text(
              widget.isUpdating ? "Add Favourite Fruit" : "Create Fruit",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 16),
            _imageFile == null && _imageUrl == null
                ? ButtonTheme(
              child: RaisedButton(
                onPressed: () => _getLocalImage(),
                child: Text(
                  'Add Image',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
                : SizedBox(height: 0),
            _buildNameField(),
            _buildCategoryField(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildCountryField(),
                ButtonTheme(
                  child: RaisedButton(
                    child: Text('Add', style: TextStyle(color: Colors.white)),
                    onPressed: () => _addCountry(countriesController.text),
                  ),
                )
              ],
            ),
            SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(8),
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              children: _countries
                  .map(
                    (ingredient) => Card(
                  color: Colors.black54,
                  child: Center(
                    child: Text(
                      ingredient,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              )
                  .toList(),
            )
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveFavouriteFruit();
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
    );
  }
}
