import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:leopardmachine/model/machine_model.dart';
import 'package:leopardmachine/screen/machine_maintenance_inform.dart';
import 'package:leopardmachine/utility/my_constant.dart';
import 'package:leopardmachine/utility/my_style.dart';
import 'package:leopardmachine/utility/normal_dialog.dart';
import 'package:leopardmachine/utility/signout_process.dart';
import 'package:leopardmachine/widget/list_machine.dart';
import 'package:leopardmachine/widget/list_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leopardmachine/screen/machine_fix_detail.dart';

class MachineFixedInform extends StatefulWidget {
  @override
  _MachineFixedInformState createState() => _MachineFixedInformState();
}

class _MachineFixedInformState extends State<MachineFixedInform> {
  List<MachineModel> _machines = List<MachineModel>();
  List<MachineModel> _machinesForDisplay = List<MachineModel>();
  Widget currentWidget = MachineFixedInform();
  String tabType, firstName, lastName, userlogin;
  bool isrefresh = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'พร้อมใช้งาน'),
    Tab(text: 'รอซ่อม'),
    Tab(text: 'ซ่อมเสร็จแล้ว'),
  ];

  @override
  void initState() {
    super.initState();
    findUser();
    readDataMachineListView(tabType).then((value) {
      setState(() {
        _machines.addAll(value);
        _machinesForDisplay = _machines;
      });
    });
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      firstName = preferences.getString('FirstName');
      lastName = preferences.getString('LastName');
    });
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeadDrawer(),
            mainMenu(),
            yearlyMaintenanceMenu(),
            machineMenu(),
            userMenu(),
            signOutMenu(),
          ],
        ),
      );

  ListTile mainMenu() => ListTile(
        leading: Icon(Icons.home),
        title: Text(
          'หน้าแรก',
          style: MyStyle().kanit,
        ),
        onTap: () {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (value) => MachineFixedInform(),
          );
          Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
        },
      );

  ListTile yearlyMaintenanceMenu() => ListTile(
        leading: Icon(Icons.build),
        title: Text(
          'บำรุงรักษาเครื่องจักร',
          style: MyStyle().kanit,
        ),
        onTap: () {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (value) => MaintenanceInform(),
          );
          Navigator.of(context).push(route);
        },
      );

  ListTile machineMenu() => ListTile(
        leading: Icon(Icons.dvr),
        title: Text(
          'ดูรายชื่อเครื่องจักร',
          style: MyStyle().kanit,
        ),
        onTap: () {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (value) => MachineList(),
          );
          Navigator.of(context).push(route);
        },
      );

  ListTile userMenu() => ListTile(
        leading: Icon(Icons.supervised_user_circle),
        title: Text(
          'ดูรายชื่อพนักงาน',
          style: MyStyle().kanit,
        ),
        onTap: () {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (value) => UserList(),
          );
          Navigator.of(context).push(route);
        },
      );

  ListTile signOutMenu() => ListTile(
      leading: Icon(Icons.exit_to_app),
      title: Text(
        'ออกจากระบบ',
        style: MyStyle().kanit,
      ),
      onTap: () {
        showDialogYesNoQuestionForLogout(
            'ท่านต้องการออกจากระบบใช่หรือไม่?', context);
      });

  showDialogYesNoQuestionForLogout(message, context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          message,
          style: MyStyle().kanit,
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ยกเลิก',
                    style: GoogleFonts.kanit(
                      textStyle: TextStyle(color: MyStyle().red400),
                    ),
                  )),
              FlatButton(
                onPressed: () {
                  signOutProcess(context);
                },
                child: Text(
                  'ใช่',
                  style: GoogleFonts.kanit(
                    textStyle: TextStyle(color: MyStyle().red400),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
        decoration: MyStyle().myBoxDecoration('maintenance.png'),
        accountName: Text(
          '$firstName $lastName',
          style: GoogleFonts.kanit(
              textStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          )),
        ),
        accountEmail: Text(
          'กำลังใช้งาน',
          style: GoogleFonts.kanit(
            textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }

  Future<List<MachineModel>> readDataMachineListView(
      machineMaintenanceStatus) async {
    print('read me');

    if (machineMaintenanceStatus == null) {
      machineMaintenanceStatus = 'availableMachine';
    }

    String url =
        '${MyConstant().domain}/LeopardMachine/getMaintenanceListView.php?isAdd=true&machineMaintenanceStatus=$machineMaintenanceStatus';
    print('url = $url');
    var response = await http.get(url);
    var machines = new List<MachineModel>();
    var machineList = json.decode(response.body);
    machines.clear();
    if (machineList != null) {
      for (var machinesJson in machineList) {
        machines.add(MachineModel.fromJson(machinesJson));
      }
    }

    return machines;
  }

  Future<Null> _refresh(tabType) {
    return readDataMachineListView(tabType).then((_user) {
      setState(() {
        _machinesForDisplay = _user;
        _machines = _user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: showDrawer(),
        appBar: AppBar(
          title: Text(
            'แจ้งซ่อมเครื่องจักร',
            style: MyStyle().kanit,
          ),
          bottom: TabBar(
            indicatorColor: Colors.yellow,
            indicatorWeight: 7.0,
            labelStyle: MyStyle().kanit,
            tabs: myTabs,
            onTap: (index) {
              if (index == 0) {
                tabType = 'availableMachine';
              } else if (index == 1) {
                tabType = 'holdingMaintenance';
              } else if (index == 2) {
                tabType = 'maintenanceSuccessed';
              }
              setState(() {
                _refresh(tabType);
              });
            },
          ),
        ),
        body: TabBarView(physics: NeverScrollableScrollPhysics(), children: [
          _availableMachine(),
          _holdingMaintenance(),
          _maintenanceSuccessed(),
        ]),
      ),
    );
  }

  _availableMachine() {
    return new RefreshIndicator(
      onRefresh: () async {
        await _refresh(tabType);
      },
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: _machinesForDisplay.length + 1,
        itemBuilder: (context, index) {
          print('1');
          return index == 0
              ? _searchBar()
              : _listMachineItems(
                  index == 0 ? 0 : index - 1, tabType, MyStyle().green400);
        },
      ),
    );
  }

  _holdingMaintenance() {
    return new RefreshIndicator(
      onRefresh: () async {
        await _refresh(tabType);
      },
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: _machinesForDisplay.length + 1,
        itemBuilder: (context, index) {
          print('2');
          return index == 0
              ? _searchBar()
              : _listMachineItems(
                  index == 0 ? 0 : index - 1, tabType, MyStyle().red400);
        },
      ),
    );
  }

  _maintenanceSuccessed() {
    return new RefreshIndicator(
      onRefresh: () async {
        await _refresh(tabType);
      },
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: _machinesForDisplay.length + 1,
        itemBuilder: (context, index) {
          print('3');
          return index == 0
              ? _searchBar()
              : _listMachineItems(
                  index == 0 ? 0 : index - 1, tabType, MyStyle().yellow800);
        },
      ),
    );
  }

  _listMachineItems(i, tabType, typeColor) {
    try {
      return Dismissible(
        key: UniqueKey(),
        confirmDismiss: (DismissDirection direction) async {
          if (_machinesForDisplay[i].machineMaintenanceStatus ==
              'availableMachine') {
            return null;
          } else {
            return showDialogDeleteQuestion(context, i);
          }
        },
        background: refreshBg(),
        child: Card(
          borderOnForeground: true,
          child: ListTile(
            leading: CircleAvatar(
              radius: 28.0,
              backgroundColor: MyStyle().red400,
              backgroundImage: NetworkImage(_machinesForDisplay[i].imageUrl ==
                      null
                  ? '${MyConstant().domain}' +
                      '/' +
                      _machinesForDisplay[i].imageUrl
                  : '${MyConstant().domain}' + _machinesForDisplay[i].imageUrl),
            ),
            title: Text(
              _machinesForDisplay[i].machineCode,
              style: GoogleFonts.kanit(
                textStyle: TextStyle(
                  color: typeColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'ชื่อเครื่อง : ' + _machinesForDisplay[i].machineName,
                  style: MyStyle().kanit,
                ),
                Text(
                  'วันซ่อมบำรุงครั้งต่อไป : ' +
                      _machinesForDisplay[i].appointmentDate,
                  style: MyStyle().kanit,
                ),
              ],
            ),
            onTap: () async {
              print(
                  '1 status = ${_machinesForDisplay[i].machineMaintenanceStatus}');
              if (_machinesForDisplay[i].machineMaintenanceStatus ==
                      'holdingMaintenance' ||
                  _machinesForDisplay[i].machineMaintenanceStatus ==
                      'maintenanceSuccessed') {
                String status = _machinesForDisplay[i].machineMaintenanceStatus;
                print(' 1 machineID = ${_machinesForDisplay[i].machineID}');

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MachineFixDetail(),
                      settings:
                          RouteSettings(arguments: _machinesForDisplay[i])),
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
                    _refresh(status);
                  });
                }
              }
            },
            onLongPress: () {
              if (_machinesForDisplay[i].machineMaintenanceStatus ==
                  'availableMachine') {
                showDialogYesNoQuestion(
                  'ต้องการแจ้งซ่อมเครื่องจักรเครื่องนี้ ใช่หรือไม่?',
                  context,
                  i,
                  'holdingMaintenance',
                );
              }
            },
          ),
        ),
      );
    } catch (e) {}
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

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          labelText: 'ค้นหาเครื่องจักร',
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
            _machinesForDisplay = _machines.where((machine) {
              var machineTitle = machine.machineName.toLowerCase() +
                  machine.machineCode.toLowerCase() +
                  machine.appointmentDate;
              return machineTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  Future<Null> insertInformFixMachine(
      MachineModel machineModel, maintenanceStatus) async {
    print('insertInformFixMachine');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userID = preferences.getString('userID');
    DateTime applyDate = DateTime.now();
    String machineID = machineModel.machineID;
    String message =
        'เครื่องจักร ${machineModel.machineCode} ได้ทำการแจ้งซ่อมเรียบร้อยแล้ว';

    String url =
        '${MyConstant().domain}/LeopardMachine/editMachineStatus.php?isAdd=true&UserID=$userID&MachineID=$machineID&MaintenanceStatus=$maintenanceStatus&ApplyDate=$applyDate';
    await Dio().get(url).then((value) {
      setState(() {
        _refresh('availableMachine');
      });
      showSnackBar(message);
      print('value = $value, url = $url');
    });
    Navigator.pop(context);
  }

  showDialogYesNoQuestion(message, context, i, maintenanceStatus) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          message,
          style: MyStyle().kanit,
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ยกเลิก',
                    style: GoogleFonts.kanit(
                      textStyle: TextStyle(color: MyStyle().red400),
                    ),
                  )),
              FlatButton(
                onPressed: () {
                  print('index = $i');
                  insertInformFixMachine(
                      _machinesForDisplay[i], maintenanceStatus);
                },
                child: Text(
                  'ใช่',
                  style: GoogleFonts.kanit(
                    textStyle: TextStyle(color: MyStyle().red400),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<bool> showDialogDeleteQuestion(context, index) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'คูณต้องการยกเลิกการแจ้งซ่อมเครื่องจักรนี้ใช่หรือไม่?',
          style: MyStyle().kanit,
        ),
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
                  style: GoogleFonts.kanit(
                    textStyle: TextStyle(
                      color: MyStyle().red400,
                    ),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  rollbackMachineListView(index);
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'ใช่',
                  style: GoogleFonts.kanit(
                    textStyle: TextStyle(
                      color: MyStyle().red400,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> rollbackMachineListView(index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userIDLogin = preferences.getString('userID');
    DateTime datenow = DateTime.now();
    String machineID = _machinesForDisplay[index].machineID;
    String rollbackStatus = '';

    if (_machinesForDisplay[index].machineMaintenanceStatus ==
        'maintenanceSuccessed') {
      rollbackStatus = 'holdingMaintenance';
    } else if (_machinesForDisplay[index].machineMaintenanceStatus ==
        'holdingMaintenance') {
      rollbackStatus = 'availableMachine';
    }

    String url =
        '${MyConstant().domain}/LeopardMachine/rollbackMachineStatus.php?isAdd=true&machineid=$machineID&rollbackStatus=$rollbackStatus&UpdateBy=$userIDLogin&UpdateDate=$datenow';

    print('url = $url');
    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        setState(() {
          _refresh(_machinesForDisplay[index].machineMaintenanceStatus);
        });
        String machineCodeSnack = _machinesForDisplay[index].machineCode;
        String message =
            'เครื่องจักร $machineCodeSnack ได้ยกเลิกการแจ้งซ่อมแล้ว';
        showSnackBar(message);
      } else {
        normalDialog(context, 'ไม่สามารถลบข้อมูลได้ กรุณาติดต่อเจ้าหน้าที่');
      }
    } catch (e) {}
  }

  showSnackBar(message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: GoogleFonts.kanit(
          textStyle: TextStyle(
            color: Colors.blue.shade300,
          ),
        ),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
