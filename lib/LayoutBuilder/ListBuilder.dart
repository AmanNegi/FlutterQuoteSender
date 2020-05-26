import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quote_sender/Helpers/InternetCheck.dart';
import 'package:quote_sender/LayoutBuilder/ErrorScreen.dart';
import 'package:quote_sender/painters/CurvePainter.dart';
import 'package:quote_sender/DataRepo.dart';
import 'package:quote_sender/LayoutBuilder/CommonListItemBuilder.dart';
import 'package:quote_sender/Quote.dart';
import 'SpecialListItemBuilder.dart';
import './DrawerBuilder.dart';

class ListBuilder extends StatefulWidget {
  @override
  _ListBuilderState createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  DataRepo dataRepo = DataRepo();
  var height;
  Widget defaultWidget = Container();
  bool isInternet = true;

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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text(
          "Quotes",
          style: GoogleFonts.rockSalt(),
        ),
        centerTitle: true,
      ),
      //  floatingActionButton: FloatingActionButton(
      //    onPressed: _addQuote,
      //  ),
      drawer: DrawerBuilder(),
      body: CustomPaint(
          painter: CurvePainter(),
          child: StreamBuilder<QuerySnapshot>(
            stream: dataRepo.getStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (isInternet) {
                  return _buildList(context, snapshot.data.documents);
                } else {
                  return ErrorScreen(onRefresh: checkInternetState);
                }
              } else if (snapshot.hasError ||
                  snapshot == null ||
                  snapshot.connectionState == ConnectionState.none) {
                return ErrorScreen();
              } else
                return Center(child: CircularProgressIndicator());
            },
          )),
    );
  }

  void _addQuote() {
    dataRepo.addQuote(
      Quote(
          author: "aster",
          date: DateTime.now(),
          quote: "I'm selfish, impatient and a little insecure.",
          imageUrl:
              "https://image.freepik.com/free-vector/gradient-green-blue-abstract-geometric-background_23-2148362562.jpg"),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    if (snapshot.length == 0) {
      return Container(
        child: Center(
          child: Text(
            " No Items",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      return Column(children: <Widget>[
        SpecialListItembuilder(
          snapshot: snapshot[0],
        ),
        Spacer(),
        _getHorizontalList(snapshot),
      ]);
    }
  }

  _getHorizontalList(List<DocumentSnapshot> snapshot) {
    int length = snapshot.length - 1;
    print(snapshot.length.toString());
    if (length >= 1) {
      return Container(
        height: 36 / 100 * height,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                child: Text(
                  "Old Quotes",
                  style: GoogleFonts.rockSalt(
                      fontSize: 16.0,
                      letterSpacing: 1.5,
                      decoration: TextDecoration.overline),
                ),
              ),
            ),
            Container(
              height: 29 / 100 * height,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return CommonListItemBuilder(
                    snapshot: snapshot[index + 1],
                  );
                },
                itemCount: length,
              ),
            ),
          ],
        ),
      );
    } else
      return Container();
  }
}
