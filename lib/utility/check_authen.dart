
import 'package:flutter/material.dart';
import 'package:leopardmachine/screen/home.dart';
import 'package:leopardmachine/screen/machine_fix_inform.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckAuthen extends StatefulWidget {
  @override
  _CheckAuthenState createState() => _CheckAuthenState();
}

class _CheckAuthenState extends State<CheckAuthen> {
  String _userID;

  @override
  void initState() {
    super.initState();
    checkAuthen();
  }

  Future<Null> checkAuthen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _userID = preferences.getString('userID');

    if (_userID != null && _userID != '') {
      routeToService(MachineFixedInform());
    } else {
      routeToService(Home());
    }
  }

  Future<Null> routeToService(Widget myWidget) async {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
