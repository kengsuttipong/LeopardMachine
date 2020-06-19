import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leopardmachine/model/user_model.dart';
import 'package:leopardmachine/utility/my_constant.dart';
import 'package:leopardmachine/utility/my_style.dart';
import 'package:leopardmachine/screen/add_user.dart';
import 'package:leopardmachine/screen/edit_user.dart';
import 'package:leopardmachine/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  void initState() {
    super.initState();
    readDataUserListView().then((value) {
      setState(() {
        _users.addAll(value);
        _usersForDisplay = _users;
      });
    });
  }

  List<UserModel> _users = List<UserModel>();
  List<UserModel> _usersForDisplay = List<UserModel>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<UserModel>> readDataUserListView() async {
    String url =
        '${MyConstant().domain}/LeopardMachine/getAllUserListView.php?isAdd=true';
    var response = await Dio().get(url);

    var users = List<UserModel>();
    var usersList = json.decode(response.data);
    users.clear();
    for (var usersListJson in usersList) {
      users.add(UserModel.fromJson(usersListJson));
    }

    return users;
  }

  String convertUserType(String userType) {
    String userTypeString = '';
    if (userType == 'user_pharmacist') {
      userTypeString = 'เภสัชกร';
    } else if (userType == 'user_mechanic') {
      userTypeString = 'ช่าง';
    } else if (userType == 'user_staff') {
      userTypeString = 'พนักงาน';
    }

    return userTypeString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'รายชื่อพนักงานในระบบ',
          style: MyStyle().kanit,
        ),
      ),
      body: Stack(
        children: <Widget>[
          new RefreshIndicator(
            onRefresh: () async {
              await _refresh();
            },
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: _usersForDisplay.length + 1,
              itemBuilder: (context, index) {
                return index == 0 ? _searchUser() : _listUserItems(index - 1);
              },
            ),
          ),
          addButton(),
        ],
      ),
    );
  }

  Future<Null> _refresh() {
    return readDataUserListView().then((_user) {
      setState(() {
        _usersForDisplay = _user;
        _users = _user;
      });
    });
  }

  Row addButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 14.0, bottom: 14.0),
              child: FloatingActionButton(
                child: Icon(Icons.add_circle),
                onPressed: () {
                  routeToAddUser();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  _searchUser() {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          labelText: 'ค้นหารายชื่อพนักงาน',
          labelStyle: MyStyle().kanit,
          fillColor: MyStyle().red400,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().red400)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().red400)),
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            _usersForDisplay = _users.where((user) {
              var userTitle = user.firstName.toLowerCase() +
                  user.lastName.toLowerCase() +
                  convertUserType(user.userType.toLowerCase());
              return userTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listUserItems(index) {
    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (DismissDirection direction) async {
        return showDialogYesNoQuestion(context, index);
      },
      background: refreshBg(),
      child: Card(
        borderOnForeground: true,
        child: ListTile(
          leading: CircleAvatar(
            radius: 28.0,
            backgroundColor: MyStyle().red400,
          ),
          title: Text(
              _usersForDisplay[index].firstName.toString() +
                  ' ' +
                  _usersForDisplay[index].lastName.toString(),
              style: GoogleFonts.kanit(
                textStyle: TextStyle(
                  color: MyStyle().red400,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              )),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'ประเภทพนักงาน : ' +
                    convertUserType(
                        _usersForDisplay[index].userType.toString()),
                style: MyStyle().kanit,
              ),
            ],
          ),
          onTap: () {
            print('Tab');
            _navigateToEditPage(context, index);
          },
        ),
      ),
    );
  }

  showSnackBar(usernameSnack) {
    final snackBar = SnackBar(
      content: Text(
        'ผู้ใช้ $usernameSnack ได้ถูกลบแล้ว',
        style: GoogleFonts.kanit(
          textStyle: TextStyle(
            color: Colors.blue.shade300,
          ),
        ),
      ),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget refreshBg() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: MyStyle().red400,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  _navigateToEditPage(BuildContext context, index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUser(),
        settings: RouteSettings(arguments: _usersForDisplay[index]),
      ),
    );

    if (result != null) {
      final snackBar = SnackBar(
        content: Text(
          '$result',
          style: GoogleFonts.kanit(
            textStyle: TextStyle(
              color: Colors.blue.shade300,
            ),
          ),
        ),
      );

      _scaffoldKey.currentState.showSnackBar(snackBar);

      setState(() {
        _refresh();
      });
    }
  }

  Future<bool> showDialogYesNoQuestion(context, index) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คูณต้องการลบเครื่องจักรใช่หรือไม่?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(color: MyStyle().red400),
                ),
              ),
              FlatButton(
                onPressed: () {
                  deleteDataUserListView(index);
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'ใช่',
                  style: TextStyle(color: MyStyle().red400),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> deleteDataUserListView(index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userIDLogin = preferences.getString('userID');
    DateTime datenow = DateTime.now();
    String userID = _usersForDisplay[index].userid;

    String url =
        '${MyConstant().domain}/LeopardMachine/deleteUserByUserID.php?isAdd=true&userid=$userID&UpdateBy=$userIDLogin&UpdateDate=$datenow';

    print('url = $url');
    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        setState(() {
          _refresh();
        });
        String usernameSnack = _usersForDisplay[index].userName;
        showSnackBar(usernameSnack);
      } else {
        normalDialog(context, 'ไม่สามารถลบข้อมูลได้ กรุณาติดต่อเจ้าหน้าที่');
      }
    } catch (e) {}
  }

  routeToAddUser() async {
    print('routeToAddUser');
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddUser(),
      ),
    );

    if (result != null) {
      final snackBar = SnackBar(
        content: Text(
          '$result',
          style: GoogleFonts.kanit(
            textStyle: TextStyle(
              color: Colors.blue.shade300,
            ),
          ),
        ),
      );

      _scaffoldKey.currentState.showSnackBar(snackBar);
      setState(() {
        _refresh();
      });
    }
  }
}
