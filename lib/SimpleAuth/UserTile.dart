import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quote_sender/MessageLayout/mainMessageScreen.dart';
import 'package:quote_sender/SimpleAuth/User.dart';

class UserTile extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  final String currentUserId;
  UserTile({this.documentSnapshot, this.currentUserId});
  @override
  Widget build(BuildContext context) {
    User user = User.fromSnapshot(documentSnapshot);
    String imagePath =
        user.gender == "Male" ? "assets/man.png" : "assets/woman.png";
    if (currentUserId == user.id) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => MainMessageScreen(
                userSelected: user,
              ),
            ),
          );
        },
        child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)),
              color: Colors.white12,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      imagePath,
                      height: 40,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      user.name,
                      style: GoogleFonts.aBeeZee(fontSize: 18),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
