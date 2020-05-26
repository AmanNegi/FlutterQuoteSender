import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quote_sender/clippers/CurveClipper.dart';
import 'package:quote_sender/painters/CurvePainter.dart';
import '../painters/SmallCurvePainter.dart';
import '../Quote.dart';

class SpecialListItembuilder extends StatelessWidget {
  final DocumentSnapshot snapshot;

  SpecialListItembuilder({this.snapshot});

  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    Quote quote = Quote.fromSnapshot(snapshot);

    return CustomPaint(
      foregroundPainter: SmallCurvePainter(),
      child: ClipPath(
          clipper: CurveClipper(),
          child: Container(
            height: height * 0.53,
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topCenter,
                fit: BoxFit.cover,
                //"https://image.freepik.com/free-vector/colorful-abstract-background-with-memphis-elements_23-2148468895.jpg"
                image: NetworkImage(quote.imageUrl),
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: 0.07 * height,
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 60, left: 10.0, right: 10.0),
                          child: Text(
                            "‘‘" + quote.quote + "’’",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade,
                            style: GoogleFonts.juliusSansOne(
                                fontSize: 40, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              quote.author,
                              style: GoogleFonts.rockSalt(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
