import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leopardmachine/model/user_model.dart';
import 'package:leopardmachine/screen/add_user.dart';
import 'package:leopardmachine/utility/my_constant.dart';
import 'package:leopardmachine/utility/my_style.dart';
import 'package:leopardmachine/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditUser extends StatefulWidget {
  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  String firstName, lastName, username, password, userType, userID;
  UserModel _usersForDisplay;

  Item selectedUser;
  List<Item> users = <Item>[
    const Item('เภสัชกร', 'user_pharmacist'),
    const Item('ช่าง', 'user_mechanic'),
    const Item('พนักงาน', 'user_staff'),
  ];

  @override
  Widget build(BuildContext context) {
    _usersForDisplay = ModalRoute.of(context).settings.arguments;
    userID = _usersForDisplay.userid;
    userType = _usersForDisplay.userType;

    print('userid = ${_usersForDisplay.userid}');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แก้ไขผู้ใช้งาน',
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
            saveButton(),
          ],
        ),
      ),
    );
  }

  Widget firstNameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextFormField(
              onChanged: (value) {
                firstName = value;
              },
              initialValue: _usersForDisplay.firstName,
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
            child: TextFormField(
              onChanged: (value) {
                lastName = value;
              },
              initialValue: _usersForDisplay.lastName,
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
            child: TextFormField(
              onChanged: (value) {
                username = value;
              },
              initialValue: _usersForDisplay.userName,
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
        child: TextFormField(
          onChanged: (value) {
            password = value;
          },
          initialValue: _usersForDisplay.password,
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

  Widget userTypeForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 220.0,
            child: DropdownButtonFormField(
              hint: Text(
                'เลือกประเภทพนักงาน',
                style: MyStyle().kanit,
              ),
              value: users.elementAt(users
                  .indexWhere((element) => element.value.startsWith(userType))),
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

  Widget saveButton() => Container(
        width: 250.0,
        child: RaisedButton(
          color: MyStyle().red400,
          onPressed: () {
            if (firstName == null &&
                lastName == null &&
                username == null &&
                password == null &&
                selectedUser == null) {
              normalDialog(context, 'ไม่มีการเปลี่ยนแปลงข้อมูล');
            } else {
              checkDuplicateUser();
            }
          },
          child: Text(
            'บันทึก',
            style: GoogleFonts.kanit(
              textStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

  Future<Null> checkDuplicateUser() async {
    print('username = $username');
    username = username == null ? _usersForDisplay.userName : username;
    String url =
        '${MyConstant().domain}/LeopardMachine/getUserWhereUserMaster.php?isAdd=true&UserName=$username';

    print('url = $url');
    try {
      Response response = await Dio().get(url);

      if (response.toString() == 'null' ||
          _usersForDisplay.userName == username) {
        updateUser();
      } else {
        normalDialog(
            context, 'ไม่สามารถบันทึกได้ เนื่องจากมีชื่อผู้ใช้งานนี้แล้ว');
      }
    } catch (e) {}
  }

  Future<Null> updateUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userIDLogin = preferences.getString('userID');
    DateTime datenow = DateTime.now();

    userType =
        selectedUser == null ? _usersForDisplay.userType : selectedUser.value;
    firstName = firstName == null ? _usersForDisplay.firstName : firstName;
    lastName = lastName == null ? _usersForDisplay.lastName : lastName;
    username = username == null ? _usersForDisplay.userName : username;
    password = password == null ? _usersForDisplay.password : password;

    String url =
        '${MyConstant().domain}/LeopardMachine/updateUserByUserID.php?isAdd=true&userid=$userID&UserType=$userType&FirstName=$firstName&LastName=$lastName&UserName=$username&Password=$password&UpdateBy=$userIDLogin&UpdateDate=$datenow';

    print('url = $url');
    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        Navigator.of(context).pop('ผู้ใช้ ' + username + ' ได้ทำการแก้ไขแล้ว');
      } else {
        normalDialog(context, 'ไม่สามารถบันทึกได้ กรุณาติดต่อเจ้าหน้าที่');
      }
    } catch (e) {}
  }
}
