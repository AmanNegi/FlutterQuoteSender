import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quote_sender/LayoutBuilder/ListBuilder.dart';
import 'package:quote_sender/SimpleAuth/User.dart';
import 'package:quote_sender/SimpleAuth/UserRepo.dart';
import 'package:quote_sender/SimpleAuth/UserTile.dart';
import 'package:quote_sender/SimpleAuth/UserUtils.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  UserRepo userRepo;
  String currentUserId;

  @override
  void initState() {
    userRepo = UserRepo();
    UserUtils.getFromSharedPrefs("id").then((value) {
      setState(() {
        currentUserId = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext contxt) => ListBuilder()));
          },
        ),
        automaticallyImplyLeading: false,
        title: Text(" Registered users "),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userRepo.getStream(),
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

  _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    if (snapshot != null && snapshot.length > 0) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return UserTile(
            documentSnapshot: snapshot[index],
            currentUserId: currentUserId,
          );
        },
        itemCount: snapshot.length,
      );
    } else {
      return Container();
    }
  }

  _errorBuilder() {
    //TODO: golbalize errror builder
    return Container(
      child: Center(
        child: Text("Some internet issue"),
      ),
    );
  }
}
