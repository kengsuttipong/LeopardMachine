import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:leopardmachine/model/machine_model.dart';
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
  String tabType, firstName, lastName;
  bool isrefresh = false;

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
            userMenu(),
            machineMenu(),
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

  ListTile machineMenu() => ListTile(
        leading: Icon(Icons.build),
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
        accountName: Text(
          '$firstName $lastName',
          style: TextStyle(color: MyStyle().red400),
        ),
        accountEmail: Text(
          'กำลังใช้งาน',
          style: TextStyle(color: MyStyle().red400),
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

              MyStyle().showProgress();
              _refresh(tabType);
            },
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
          _availableMachine(),
          _holdingMaintenance(),
          _maintenanceSuccessed(),
        ]),
      ),
    );
  }

  _availableMachine() {
    return RefreshIndicator(
      onRefresh: () async {
        await _refresh(tabType);
      },
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: _machinesForDisplay.length == 0
            ? 0
            : _machinesForDisplay.length + 1,
        itemBuilder: (context, index) {
          print('1');
          if (_machinesForDisplay.length != 0) {
            return index == 0
                ? _searchBar()
                : _listMachineItems(
                    context, index - 1, tabType, MyStyle().green400);
          } else {
            return null;
          }
        },
      ),
    );
  }

  _holdingMaintenance() {
    return RefreshIndicator(
      onRefresh: () async {
        await _refresh(tabType);
      },
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: _machinesForDisplay.length == 0
            ? 0
            : _machinesForDisplay.length + 1,
        itemBuilder: (context, index) {
          print('2');
          if (_machinesForDisplay.length != 0) {
            return index == 0
                ? _searchBar()
                : _listMachineItems(
                    context, index - 1, tabType, MyStyle().red400);
          } else {
            return null;
          }
        },
      ),
    );
  }

  _maintenanceSuccessed() {
    return RefreshIndicator(
      onRefresh: () async {
        await _refresh(tabType);
      },
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: _machinesForDisplay.length == 0
            ? 0
            : _machinesForDisplay.length + 1,
        itemBuilder: (context, index) {
          print('3');
          if (_machinesForDisplay.length != 0) {
          return index == 0
              ? _searchBar()
              : _listMachineItems(
                  context, index - 1, tabType, MyStyle().yellow800);
          } else {
            return null;
          }
        },
      ),
    );
  }

  _listMachineItems(context, index, tabType, typeColor) {
    return Card(
      borderOnForeground: true,
      child: ListTile(
        leading: CircleAvatar(
          radius: 28.0,
          backgroundColor: MyStyle().red400,
          backgroundImage: NetworkImage(_machinesForDisplay[index].imageUrl ==
                  null
              ? '${MyConstant().domain}' +
                  '/' +
                  _machinesForDisplay[index].imageUrl
              : '${MyConstant().domain}' + _machinesForDisplay[index].imageUrl),
        ),
        title: Text(
          _machinesForDisplay[index].machineCode,
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
              'ชื่อเครื่อง : ' + _machinesForDisplay[index].machineName,
              style: MyStyle().kanit,
            ),
            Text(
              'วันซ่อมบำรุงครั้งต่อไป : ' +
                  _machinesForDisplay[index].appointmentDate,
              style: MyStyle().kanit,
            ),
          ],
        ),
        onTap: () {
          if (tabType == 'holdingMaintenance') {
            MaterialPageRoute route = MaterialPageRoute(
              builder: (value) => MachineFixDetail(),
            );
            Navigator.of(context).push(route);
          }
        },
        onLongPress: () {
          if (tabType == 'availableMachine') {
            showDialogYesNoQuestion(
              'ต้องการแจ้งซ่อมเครื่องจักรเครื่องนี้ ใช่หรือไม่?',
              context,
              index,
              'holdingMaintenance',
            );
          }
        },
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

  Future<Null> insertInformFixMachine(machineID, maintenanceStatus) async {
    print('insertInformFixMachine');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userID = preferences.getString('userID');
    DateTime applyDate = DateTime.now();
    var result;

    String url =
        '${MyConstant().domain}/LeopardMachine/insertInformFixMachine.php?isAdd=true&UserID=$userID&MachineID=$machineID&MaintenanceStatus=$maintenanceStatus&ApplyDate=$applyDate';
    await Dio().get(url).then((value) {
      print('value = $value');
      result = json.decode(value.data);
    });
    if (result) {
      url =
          '${MyConstant().domain}/LeopardMachine/editMachineStatus.php?isAdd=true&UserID=$userID&MachineID=$machineID&MaintenanceStatus=$maintenanceStatus&ApplyDate=$applyDate';
      await Dio().get(url).then((value) {
        print('value = $value, url = $url');
        //result = json.decode(value.data);
      });
      Navigator.pop(context);
    } else {
      normalDialog(context, 'ไม่สามารถแจ้งซ่อมได้ กรุณาแจ้งผู้ดูแลระบบ');
    }
  }

  showDialogYesNoQuestion(message, context, index, maintenanceStatus) {
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
                  print('index = $index');
                  insertInformFixMachine(
                      _machinesForDisplay[index].machineID, maintenanceStatus);
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
}
