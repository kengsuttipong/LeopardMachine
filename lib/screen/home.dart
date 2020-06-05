import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leopardmachine/screen/machine_fix_inform.dart';
import 'package:leopardmachine/utility/my_style.dart';
import 'package:leopardmachine/utility/normal_dialog.dart';
import 'package:leopardmachine/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leopardmachine/utility/my_constant.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String username, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เข้าสู่ระบบ',
          style: MyStyle().kanit,
        ),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                MyStyle().showLogo(),
                MyStyle().mySizeBox(),
                MyStyle().showTitle('Leopard Machine'),
                MyStyle().mySizeBox(),
                userForm(),
                MyStyle().mySizeBox(),
                passwordForm(),
                MyStyle().mySizeBox(),
                loginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => username = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: MyStyle().red400,
            ),
            labelStyle: GoogleFonts.kanit(
              textStyle: TextStyle(color: MyStyle().red400),
            ),
            labelText: 'ชื่อผู้ใช้งาน',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().red400)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().red400)),
          ),
        ),
      );

  Widget passwordForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: MyStyle().red400,
            ),
            labelStyle: GoogleFonts.kanit(
              textStyle: TextStyle(color: MyStyle().red400),
            ),
            labelText: 'รหัสผ่าน',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().red400)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().red400)),
          ),
        ),
      );

  Widget loginButton() => Container(
        width: 250.0,
        child: RaisedButton(
          color: MyStyle().red400,
          onPressed: () {
            if (username == null ||
                username.isEmpty ||
                password == null ||
                password.isEmpty) {
              normalDialog(context, 'มีช่องว่าง');
            } else {
              checkAuthen();
            }
          },
          child: Text(
            'เข้าสู่ระบบ',
            style: GoogleFonts.kanit(
              textStyle: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );

  Future<Null> checkAuthen() async {
    String url =
        '${MyConstant().domain}/LeopardMachine/getUserWhereUserMaster.php?isAdd=true&UserName=$username';

    try {
      Response response = await Dio().get(url);
      print('res = $response');
      var result = json.decode(response.data);
      print('result = $result');

      for (var map in result) {
        UserModel usermodel = UserModel.fromJson(map);
        if (password == usermodel.password) {
          String userType = usermodel.userType;
          print('userType = $userType');
          if (userType == 'user_pharmacist') {
            routeToService(MachineFixedInform(), usermodel);
          } else if (userType == 'rdo_shop') {
            //routeToService(MainShop(), usermodel);
          } else if (userType == 'rdo_rider') {
            //routeToService(MainRider(), usermodel);
          } else {
            normalDialog(context, 'กรุณาลองใหม่อีกครั้ง');
          }
        } else {
          normalDialog(context, 'ไม่สำเร็จ! ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง');
        }
      }
    } catch (e) {}
  }

  Future<Null> routeToService(Widget myWidget, UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('userid', userModel.userid);
    preferences.setString('UserType', userModel.userType);
    preferences.setString('FirstName', userModel.firstName);
    preferences.setString('LastName', userModel.lastName);

    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }
}
