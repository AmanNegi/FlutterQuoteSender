import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:quote_sender/MessageLayout/MessageRepo.dart';
import 'package:quote_sender/MessageLayout/buildMessageWidget.dart';
import 'package:quote_sender/SimpleAuth/User.dart';
import 'package:quote_sender/SimpleAuth/UserUtils.dart';
import 'Message.dart';

class MainMessageScreen extends StatefulWidget {
  final User userSelected;

  MainMessageScreen({this.userSelected});
  @override
  _MainMessageScreenState createState() => _MainMessageScreenState();
}

class _MainMessageScreenState extends State<MainMessageScreen> {
  MessageRepo messageRepo;
  TextEditingController controller;
  final _formKey = GlobalKey<FormState>();
  String messageEntered;
  String idFrom;
  String idTo;
  double bottom;
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    messageRepo = MessageRepo();
    UserUtils.getFromSharedPrefs("id").then((value) {
      setState(() {
        idTo = widget.userSelected.id;
        idFrom = value;
      });
      controller = TextEditingController();
      String groupId = idFrom + "-" + idTo;
      if (idFrom.hashCode <= idTo.hashCode) {
        groupId = '$idFrom-$idTo';
      } else {
        groupId = '$idTo-$idFrom';
      }
      print(groupId + " the Group id ");
      messageRepo.setReference(groupId);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.userSelected.name}"),
        ),
        body: Stack(
          children: <Widget>[
            _listBuilder(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  color: Colors.white12,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: _formKey,
                            child: Theme(
                              data: ThemeData(
                                primaryColor: Colors.purpleAccent,
                                primaryColorDark: Colors.purpleAccent,
                              ),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty || value.length < 0) {
                                    return "Enter something..";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  setState(() {
                                    messageEntered = value;
                                  });
                                },
                                controller: controller,
                                style: GoogleFonts.aBeeZee(color: Colors.white),
                                cursorRadius: Radius.circular(20.0),
                                decoration: InputDecoration(
                                  hintStyle: GoogleFonts.aBeeZee(
                                      color: Colors.white30),
                                  contentPadding: EdgeInsets.all(10.0),
                                  hintText: "Type your message.",
                                  border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        width: 5.0, style: BorderStyle.solid),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            _formKey.currentState.reset();
                            messageRepo.addMessage(Message(
                                date: DateTime.now(),
                                text: messageEntered,
                                idFrom: idFrom,
                                idTo: idTo));
                          }
                        },
                      )
                    ],
                  )),
            ),
          ],
        ));
  }

  _errorBuilder() {
    return Container(
      child: Column(
        children: <Widget>[
          Spacer(),
          SvgPicture.asset("assets/error.svg"),
          Spacer(),
          Center(child: Text("Check your internet connection")),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  _listBuilder() {
    return Padding(
      padding: EdgeInsets.only(bottom: 80),
      child: StreamBuilder<QuerySnapshot>(
        stream: messageRepo.getStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildList(context, snapshot.data.documents);
          } else if (snapshot.hasError) {
            return _errorBuilder();
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  _buildList(BuildContext context, List<DocumentSnapshot> document) {
    print("in _buildList : " + document.length.toString());
    if (document.length > 0) {
      return ListView.builder(
        reverse: true,
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          return BuildMessageWidget(document[index], idFrom);
        },
        itemCount: document.length,
      );
    } else
      return Container();
  }
}
