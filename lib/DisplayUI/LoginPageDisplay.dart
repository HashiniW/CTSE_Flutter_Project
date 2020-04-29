/*
Author      : IT17136402 - W.M.H.B. Warnakulasooriya
Description : Creating the main screen to direct to the favorite fruit list
Reference 1 : //https://stackoverflow.com/questions/56253787/how-to-handle-textfield-validation-in-password-in-flutter
Reference 2 : https://github.com/JulianCurrie/CwC_Flutter
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finalproject/LearnAFruit_Api/Fruit_Api_Handler.dart';
import '../Crudmodel/UserCrudModel.dart';
import '../CrudControllers/authentication_Controller.dart';

enum AuthMode { Signup, Login }

class LoginPageDisplayUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageDisplayUIState();
  }
}

class _LoginPageDisplayUIState extends State<LoginPageDisplayUI> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  UserCrudModel _user = UserCrudModel();

  @override
  void initState() {
    AuthenticationController authNotifier = Provider.of<AuthenticationController>(context, listen: false);
    initializeCurrentUser(authNotifier);
    super.initState();
  }

  //submitting the user authentication forms
  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    AuthenticationController authNotifier = Provider.of<AuthenticationController>(context, listen: false);

    if (_authMode == AuthMode.Login) {
      login(_user, authNotifier);
    } else {
      signup(_user, authNotifier);
    }
  }

  //validating the display name filed
  Widget _buildDisplayNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Display Name",
        labelStyle: TextStyle(color: Colors.white54),
      ),
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 26, color: Colors.white),
      cursorColor: Colors.white,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Display Name is required';
        }

        return null;
      },
      onSaved: (String value) {
        _user.displayName = value;
      },
    );
  }

  //validating the email field
  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(color: Colors.white54),
      ),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 26, color: Colors.white),
      cursorColor: Colors.white,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is required';
        }
        //using a RegExp to recognize an email
        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email address';
        }

        return null;
      },
      onSaved: (String value) {
        _user.email = value;
      },
    );
  }
  //validating the password filed
  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(color: Colors.white54),
      ),
      style: TextStyle(fontSize: 26, color: Colors.white),
      cursorColor: Colors.white,
      obscureText: true,
      controller: _passwordController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is required';
        }
        //https://stackoverflow.com/questions/56253787/how-to-handle-textfield-validation-in-password-in-flutter
        /*I have created my own RegExp by analysing the above example. Here I'm checking a 8 character password with minimum one uppercase character,
        minimum one lowercase character and minimum one numeric value*/
        if (!RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
            .hasMatch(value)) {
          return 'Password must contain 8 characters with minimun one uppsercase letter, minimum one lowercase letter, minimum one numeric value';
        }

        return null;
      },
      onSaved: (String value) {
       _user.password = value;
      },
    );
  }

  //validating the password confirmation
  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Confirm Password",
        labelStyle: TextStyle(color: Colors.white54),
      ),
      style: TextStyle(fontSize: 26, color: Colors.white),
      cursorColor: Colors.white,
      obscureText: true,
      validator: (String value) {
        if (_passwordController.text != value) {
          return 'Passwords do not match';
        }

        return null;
      },
    );
  }

  //UI layout
  @override
  Widget build(BuildContext context) {
    print("Building login screen");

    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        decoration: BoxDecoration(color: Color(0xff34056D)),
        child: Form(
          autovalidate: true,
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(32, 96, 32, 0),
              child: Column(
                children: <Widget>[
                  Text(
                    
                    //checking the authmode to display the valid screen
                    _authMode == AuthMode.Login ? 'Please Login to Continue' : 'Signup for Learn a Fruit!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36, color: Colors.white),
                  ),
                  SizedBox(height: 32),
                  _authMode == AuthMode.Signup ? _buildDisplayNameField() : Container(),
                  _buildEmailField(),
                  _buildPasswordField(),
                  _authMode == AuthMode.Signup ? _buildConfirmPasswordField() : Container(),
                  SizedBox(height: 32),
                  ButtonTheme(
                    minWidth: 200,
                    child: RaisedButton(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      onPressed: () {
                        setState(() {
                          _authMode =
                              _authMode == AuthMode.Login ? AuthMode.Signup : AuthMode.Login;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  ButtonTheme(
                    minWidth: 200,
                    child: RaisedButton(
                      padding: EdgeInsets.all(10.0),
                      onPressed: () => _submitForm(),
                      child: Text(
                        _authMode == AuthMode.Login ? 'Login' : 'Signup',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}