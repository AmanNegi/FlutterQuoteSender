import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ErrorScreen extends StatefulWidget {
  final Function onRefresh;

  ErrorScreen({this.onRefresh});
  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  RefreshController controller = RefreshController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller,
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: widget.onRefresh,
      child: Container(
        child: Column(
          children: <Widget>[
            Spacer(),
            Container(height: 400, child: SvgPicture.asset("assets/error.svg")),
            Spacer(),
            Center(child: Text("Check your internet connection")),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
