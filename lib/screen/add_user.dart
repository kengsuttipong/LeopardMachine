import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leopardmachine/utility/my_constant.dart';
import 'package:leopardmachine/utility/my_style.dart';
import 'package:leopardmachine/utility/normal_dialog.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class Item {
  const Item(this.name, this.value);
  final String name;
  final String value;
}

class _AddUserState extends State<AddUser> {
  String firstName, lastName, username, password, userType;

  Item selectedUser;
  List<Item> users = <Item>[
    const Item('เภสัชกร', 'user_pharmacist'),
    const Item('ช่าง', 'user_mechanic'),
    const Item('พนักงาน', 'user_staff'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เพิ่มผู้ใช้งาน',
          style: MyStyle().kanit,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyStyle().mySizeBox(),
            firstNameForm(),
            MyStyle().mySizeBox(),
            lastNameForm(),
            MyStyle().mySizeBox(),
            userNameForm(),
            MyStyle().mySizeBox(),
            passwordForm(),
            MyStyle().mySizeBox(),
            userTypeForm(),
            MyStyle().mySizeBox(),
            saveButton()
          ],
        ),
      ),
    );
  }

  Widget userTypeForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 220.0,
            child: DropdownButton(
              hint: Text(
                'เลือกประเภทพนักงาน',
                style: MyStyle().kanit,
              ),
              value: selectedUser,
              onChanged: (Item value) {
                setState(() {
                  selectedUser = value;
                });
              },
              items: users.map((Item user) {
                return DropdownMenuItem<Item>(
                  value: user,
                  child: Row(
                    children: <Widget>[
                      Text(
                        user.name,
                        style: GoogleFonts.kanit(
                          textStyle: TextStyle(color: MyStyle().red400),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );

  Widget firstNameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => firstName = value.trim(),
              decoration: InputDecoration(
                labelStyle: GoogleFonts.kanit(
                  textStyle: TextStyle(
                    color: MyStyle().red400,
                  ),
                ),
                labelText: 'ชื่อจริง',
                prefixIcon: Icon(
                  Icons.account_box,
                  color: MyStyle().red400,
                ),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().red400)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().red400)),
              ),
            ),
          ),
        ],
      );

  Widget lastNameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => lastName = value.trim(),
              decoration: InputDecoration(
                labelStyle: GoogleFonts.kanit(
                  textStyle: TextStyle(
                    color: MyStyle().red400,
                  ),
                ),
                labelText: 'นามสกุล',
                prefixIcon: Icon(
                  Icons.account_box,
                  color: MyStyle().red400,
                ),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().red400)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().red400)),
              ),
            ),
          ),
        ],
      );

  Widget userNameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => username = value.trim(),
              decoration: InputDecoration(
                labelStyle: GoogleFonts.kanit(
                  textStyle: TextStyle(
                    color: MyStyle().red400,
                  ),
                ),
                labelText: 'ชื่อผู้ใช้งาน',
                prefixIcon: Icon(
                  Icons.account_box,
                  color: MyStyle().red400,
                ),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().red400)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyStyle().red400)),
              ),
            ),
          ),
        ],
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
              textStyle: TextStyle(
                color: MyStyle().red400,
              ),
            ),
            labelText: 'รหัสผ่าน',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().red400)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().red400)),
          ),
        ),
      );

  Widget saveButton() => Container(
        width: 250.0,
        child: RaisedButton(
          color: MyStyle().red400,
          onPressed: () {
            if (firstName == null ||
                firstName.isEmpty ||
                lastName == null ||
                lastName.isEmpty ||
                username == null ||
                username.isEmpty ||
                password == null ||
                password.isEmpty) {
              normalDialog(context, 'มีช่องว่าง กรุณากรอกข้อมูลให้ครบถ้วน');
            } else if (selectedUser == null) {
              normalDialog(context, 'กรุณาเลือกประเภทพนักงาน');
            } else {
              checkDuplicateUser();
            }
          },
          child: Text(
            'เพิ่มผู้ใช้งาน',
            style: GoogleFonts.kanit(
              textStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

  Future<Null> checkDuplicateUser() async {
    String url =
        '${MyConstant().domain}/LeopardMachine/getUserWhereUserMaster.php?isAdd=true&UserName=$username';

    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'null') {
        insertUpdateUser();
      } else {
        normalDialog(
            context, 'ไม่สามารถบันทึกได้ เนื่องจากมีชื่อผู้ใช้งานนี้แล้ว');
      }
    } catch (e) {}
  }

  Future<Null> insertUpdateUser() async {
    userType = selectedUser.value;
    String url =
        '${MyConstant().domain}/LeopardMachine/addUser.php?isAdd=true&FirstName=$firstName&LastName=$lastName&UserName=$username&Password=$password&UserType=$userType';

    try {
      Response response = await Dio().get(url);
      print('XXX');
      print('res = $response');

      if (response.toString() == 'true') {
        Navigator.of(context).pop('ผู้ใช้ ' + username + ' ได้ทำการบันทึกแล้ว');
      } else {
        normalDialog(context, 'ไม่สามารถเพิ่มข้อมูลได้ กรุณาติดต่อเจ้าหน้าที่');
      }
    } catch (e) {}
  }
}
