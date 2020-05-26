import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quote_sender/MessageLayout/mainMessageScreen.dart';
import 'package:quote_sender/SimpleAuth/UserPage.dart';
import 'package:quote_sender/SimpleAuth/UserUtils.dart';
import 'package:quote_sender/SimpleAuth/login.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerBuilder extends StatelessWidget {
  @override
  Drawer build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Container(),
            decoration: BoxDecoration(
              color: Theme.of(context).bottomAppBarColor,
            ),
          ),
          ListTile(
            onTap: () {
              UserUtils.checkIfExists("id").then((value) {
                if (value) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => UserPage(),
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => Login(),
                    ),
                  );
                }
              });
            },
            leading: Icon(
              Icons.supervised_user_circle,
              size: 30,
            ),
            title: Text("Talk to other users"),
            subtitle: Text("Find your friends"),
          ),
          ListTile(
            onTap: () {
              _launchURL("asterJoules@gmail.com", "A New Quote",
                  "Enter your Quote here enter your name also.");
            },
            leading: Icon(
              Icons.assignment,
              size: 30,
            ),
            title: Text("Want your Quote next ?"),
            subtitle: Text("Become a contributor"),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.feedback,
              size: 30,
            ),
            dense: true,
            onTap: () {
              _launchURL(
                  "asterJoules@gmail.com", "Feedback", "Enter your error here");
            },
            title: Text("Give Feedback"),
            subtitle: Text("Report any issues"),
          ),
          Divider(),
          Spacer(),
          Divider(
            color: Colors.grey,
          ),
          Text("@AsterJoules", style: GoogleFonts.oswald()),
          SizedBox(
            height: 10.0,
          )
        ],
      ),
    );
  }

  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
