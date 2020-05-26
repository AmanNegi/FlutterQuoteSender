import 'dart:io';

class InternetCheck {
  static bool isInternetAvailable = false;

  static Future<bool> check() async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print(" connected ");
        print(result[0].toString());
        isInternetAvailable = true;
        isConnected = true;
      } else {
        print(" internet struck in between ");
        isConnected = false;
        isInternetAvailable = false;
      }
    } catch (e) {
      print('not connected ' + e.toString());
      isInternetAvailable = false;
      isConnected = false;
    }
    return isConnected;
  }
}
