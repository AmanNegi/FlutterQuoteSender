import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:quote_sender/Helpers/InternetCheck.dart';
import 'package:quote_sender/LayoutBuilder/ErrorScreen.dart';
import 'package:quote_sender/SimpleAuth/UserPage.dart';
import 'package:quote_sender/SimpleAuth/UserRepo.dart';
import 'package:quote_sender/SimpleAuth/UserUtils.dart';
import '../imported/EnsureVisibleWhenFocused.dart';
import '../MessageLayout/TextFormBuilder.dart';
import 'User.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _formKey = GlobalKey<FormState>();
  FocusNode focusNode = new FocusNode();
  String userName;
  var height;
  String gender = "Female";
  bool isInternet = true;
  List<String> genders = ["Female", "Male"];

  @override
  void initState() {
    checkInternetState();
    super.initState();
  }

  checkInternetState() async {
    InternetCheck.check().then((bool isInternet) {
      setState(() {
        this.isInternet = isInternet;
      });
      print(" value received in initatate " + isInternet.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Sign in"),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: EnsureVisibleWhenFocused(
              focusNode: focusNode, child: _getMainWidgetOnBasisOfInternet()),
        ));
  }

  _getMainWidgetOnBasisOfInternet() {
    if (isInternet) {
      return Material(
        child: _buildForm(),
      );
    } else {
      return ErrorScreen();
    }
  }

  _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: (10 / 100) * height,
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10.0)),
              height: (65 / 100) * height,
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: height * 0.3,
                        child: SvgPicture.asset("assets/login.svg"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 8.0,
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: TextFormBuilder(
                        hintText: "Username",
                        onSaved: (value) {
                          setState(() {
                            userName = value;
                          });
                        },
                        validator: (String value) {
                          if (value.length == 0)
                            return "Enter a valid username";
                          return null;
                        },
                        icon: Icon(
                          Icons.text_fields,
                          color: Colors.white,
                        ),
                        keybordType: TextInputType.visiblePassword,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: DropdownButtonFormField(
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                        decoration: InputDecoration(),
                        hint: Text("Select your gender"),
                        value: gender,
                        onSaved: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Enter a valid gender";
                          }
                          return null;
                        },
                        items: genders.map((String value) {
                          return new DropdownMenuItem<String>(
                            child: Text(value.toString()),
                            value: value,
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10.0,
                        left: 10.0,
                        right: 10.0,
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: RaisedButton(
                          child: Text("Sign in"),
                          onPressed: _onPressed,
                          color: Colors.deepPurple[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onPressed() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      UserRepo userRepo = UserRepo();
      DocumentReference dref =
          await userRepo.addUser(User(name: userName, gender: gender));

      User newUser = User(gender: gender, id: dref.documentID, name: userName);
      userRepo.updateUser(newUser);

      await UserUtils.saveToSharedPrefs("id", dref.documentID);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => UserPage(),
        ),
      );
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
}
