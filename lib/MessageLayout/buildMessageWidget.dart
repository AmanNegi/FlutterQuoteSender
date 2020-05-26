import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quote_sender/MessageLayout/Message.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BuildMessageWidget extends StatelessWidget {
  final String currentUserId;
  final DocumentSnapshot documentSnapshot;

  BuildMessageWidget(this.documentSnapshot, this.currentUserId);

  var width;
  String idTo;
  Message message;
  String date;

  @override
  Widget build(BuildContext context) {
    message = Message.fromSnapshot(documentSnapshot);
    date = DateFormat.jm().format(message.date.toLocal());
    idTo = message.idTo;
    width = MediaQuery.of(context).size.width;

    return _getWidget();
  }

  _getWidget() {
    if (idTo != currentUserId) {
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0, top: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: Container(
              constraints: BoxConstraints(maxWidth: width * 0.7),
              padding: EdgeInsets.only(
                top: 15.0,
                left: 15.0,
                right: 10.0,
                bottom: 5.0,
              ),
              color: Colors.deepPurple[300],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  buildTextWithLinks(message.text),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(date,
                      style: GoogleFonts.aBeeZee(
                          color: Colors.white54, fontSize: 10)),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: Container(
              constraints: BoxConstraints(maxWidth: width * 0.7),
              padding: EdgeInsets.only(
                top: 15.0,
                left: 10.0,
                right: 15.0,
                bottom: 5.0,
              ),
              color: Colors.white30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildTextWithLinks(message.text),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(date,
                      style: GoogleFonts.aBeeZee(
                          color: Colors.white54, fontSize: 10))
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

Text buildTextWithLinks(String textToLink) => Text.rich(TextSpan(
    children: linkify(textToLink), style: GoogleFonts.aBeeZee(fontSize: 16.0)));

Future<void> openUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

const String urlPattern = r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+';
const String emailPattern = r'\S+@\S+';
const String phonePattern = r'[\d-]{9,}';
const String emojiPattern =
    r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])';

final RegExp linkRegExp = RegExp(
    '($urlPattern)|($emailPattern)|($phonePattern)|($emojiPattern)',
    caseSensitive: false);

WidgetSpan buildEmoteComponent(String text) {
  return WidgetSpan(
      child: Text(
    text,
    style: TextStyle(fontSize: 30),
  ));
}

WidgetSpan buildLinkComponent(String text, String linkToOpen) => WidgetSpan(
        child: InkWell(
      child: Text(text,
          style: GoogleFonts.abel(
              fontSize: 16.0,
              decoration: TextDecoration.underline,
              color: Colors.yellow)),
      onTap: () => openUrl(linkToOpen),
    ));

List<InlineSpan> linkify(String text) {
  final List<InlineSpan> list = <InlineSpan>[];
  final RegExpMatch match = linkRegExp.firstMatch(text);
  if (match == null) {
    list.add(TextSpan(text: text));
    return list;
  }

  if (match.start > 0) {
    list.add(TextSpan(text: text.substring(0, match.start)));
  }

  final String linkText = match.group(0);
  if (linkText.contains(RegExp(urlPattern, caseSensitive: false))) {
    list.add(buildLinkComponent(linkText, linkText));
  } else if (linkText.contains(RegExp(emailPattern, caseSensitive: false))) {
    list.add(buildLinkComponent(linkText, 'mailto:$linkText'));
  } else if (linkText.contains(RegExp(phonePattern, caseSensitive: false))) {
    list.add(buildLinkComponent(linkText, 'tel:$linkText'));
  } else if (linkText.contains(RegExp(emojiPattern, caseSensitive: false))) {
    list.add(buildEmoteComponent(linkText));
  } else {
    throw 'Unexpected match: $linkText';
  }

  list.addAll(linkify(text.substring(match.start + linkText.length)));

  return list;
}
