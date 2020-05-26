import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Quote.dart';

class CommonListItemBuilder extends StatelessWidget {
  final DocumentSnapshot snapshot;

  CommonListItemBuilder({this.snapshot});

  Widget build(BuildContext context) {
    Quote quote = Quote.fromSnapshot(snapshot);
//alata
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20.0,
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
            child: Stack(
              children: <Widget>[
                Container(
                  child: FadeInImage.assetNetwork(
                    fadeInCurve: Curves.easeIn,
                    placeholder: "assets/loadung.gif",
                    image: quote.imageUrl,
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            quote.quote,
                            overflow: TextOverflow.fade,
                            maxLines: 5,
                            style: GoogleFonts.sarala(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, right: 10.0),
                      child: Text(
                        quote.author,
                        style: GoogleFonts.kaushanScript(),
                      ),
                    ),
                    alignment: Alignment.bottomRight,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
