import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leopardmachine/model/machine_model.dart';
import 'package:leopardmachine/screen/machine_maintenance_detail.dart';
import 'package:leopardmachine/utility/add_eventlog.dart';
import 'package:leopardmachine/utility/my_constant.dart';
import 'package:leopardmachine/utility/my_style.dart';
import 'package:leopardmachine/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaintenanceInform extends StatefulWidget {
  @override
  _MaintenanceInformState createState() => _MaintenanceInformState();
}

class _MaintenanceInformState extends State<MaintenanceInform> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<MachineModel> _machines = List<MachineModel>();
  List<MachineModel> _machinesForDisplay = List<MachineModel>();
  String tabType, username, password;

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'รอบำรุงรักษา'),
    Tab(text: 'รอตรวจสอบ'),
    Tab(text: 'บำรุงรักษาเสร็จ'),
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

  Future<Null> _refresh(tabType) {
    return readDataMachineListView(tabType).then((value) {
      setState(() {
        _machinesForDisplay = value;
        _machines = value;
      });
    });
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('userName');
    });
  }

  Future<List<MachineModel>> readDataMachineListView(maintenanceStatus) async {
    print('read me');

    if (maintenanceStatus == null) {
      maintenanceStatus = '_pendingMaintenance';
    }

    String url =
        '${MyConstant().domain}/LeopardMachine/getMaintenanceYearlyListView.php?isAdd=true&MaintenanceStatus=$maintenanceStatus';
    print('url = $url');
    var response = await Dio().get(url);
    var machines = new List<MachineModel>();
    var machineList = json.decode(response.data);
    machines.clear();
    if (machineList != null) {
      for (var machinesJson in machineList) {
        machines.add(MachineModel.fromJson(machinesJson));
      }
    }

    return machines;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'บำรุงรักษาเครื่องจักร',
            style: MyStyle().kanit,
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (value) {
                try {
                  switch (value) {
                    case 'จากรหัส A -> Z':
                      print('จากรหัส A -> Z');
                      setState(() {
                        _machinesForDisplay.sort((a, b) {
                          return a.machineCode
                              .toString()
                              .toLowerCase()
                              .compareTo(
                                  b.machineCode.toString().toLowerCase());
                        });
                      });
                      break;
                    case 'จากรหัส Z -> A':
                      print('จากรหัส Z -> A');
                      setState(() {
                        _machinesForDisplay.sort((b, a) {
                          return a.machineCode
                              .toString()
                              .toLowerCase()
                              .compareTo(
                                  b.machineCode.toString().toLowerCase());
                        });
                      });
                      break;
                    case 'จากชื่อ ก -> ฮ':
                      print('จากชื่อ ก -> ฮ');
                      setState(() {
                        _machinesForDisplay.sort((a, b) {
                          return a.machineName
                              .toString()
                              .toLowerCase()
                              .compareTo(
                                  b.machineName.toString().toLowerCase());
                        });
                      });
                      break;
                    case 'จากชื่อ ฮ -> ก':
                      print('จากชื่อ ฮ -> ก');
                      setState(() {
                        _machinesForDisplay.sort((b, a) {
                          return a.machineName
                              .toString()
                              .toLowerCase()
                              .compareTo(
                                  b.machineName.toString().toLowerCase());
                        });
                      });
                      break;
                    case 'วันที่น้อยไปมาก':
                      print('วันที่น้อยไปมาก');
                      setState(() {
                        _machinesForDisplay.sort((a, b) {
                          return a.appointmentDate
                              .toString()
                              .toLowerCase()
                              .compareTo(
                                  b.appointmentDate.toString().toLowerCase());
                        });
                      });
                      break;
                    case 'วันที่มากไปน้อย':
                      print('วันที่มากไปน้อย');
                      setState(() {
                        _machinesForDisplay.sort((b, a) {
                          return a.appointmentDate
                              .toString()
                              .toLowerCase()
                              .compareTo(
                                  b.appointmentDate.toString().toLowerCase());
                        });
                      });
                      break;
                    case 'ตั้งค่าเริ่มต้นใหม่':
                      print('ตั้งค่าเริ่มต้นใหม่');
                      return showDialogYesNoConfirmResetToBegin(context);
                      break;
                  }
                } catch (e) {}
              },
              itemBuilder: (BuildContext context) {
                print('username = $username');
                return {
                  'จากรหัส A -> Z',
                  'จากรหัส Z -> A',
                  'จากชื่อ ก -> ฮ',
                  'จากชื่อ ฮ -> ก',
                  'วันที่น้อยไปมาก',
                  'วันที่มากไปน้อย',
                  if (username == 'admin') 'ตั้งค่าเริ่มต้นใหม่',
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(
                      choice,
                      style: MyStyle().kanit,
                    ),
                  );
                }).toList();
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 7.0,
            labelStyle: MyStyle().kanit,
            tabs: myTabs,
            onTap: (index) {
              if (index == 0) {
                tabType = '_pendingMaintenance';
              } else if (index == 1) {
                tabType = '_pendingVerify';
              } else if (index == 2) {
                tabType = '_perfectMachine';
              }
              setState(() {
                _refresh(tabType);
              });
            },
          ),
        ),
        body: TabBarView(physics: NeverScrollableScrollPhysics(), children: [
          _pendingMaintenance(),
          _pendingVerify(),
          _perfectMachine(),
        ]),
      ),
    );
  }

  void showDialogYesNoConfirmResetToBegin(context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'คุณต้องการที่จะตั้งค่าเริ่มต้นใหม่ ใช่หรือไม่?',
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
                  Navigator.pop(context);
                  resetTobeginForAdminOnly(context);
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

  void resetTobeginForAdminOnly(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            'กรุณากรอกรหัสผ่านผู้ดูแลระบบ เพื่อยืนยันการตั้งค่าเริ่มต้นใหม่',
            style: MyStyle().kanit,
          ),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                passwordForm(),
              ],
            ),
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
                  onPressed: () => verifyToResetMachine(),
                  child: Text(
                    'ยืนยัน',
                    style: GoogleFonts.kanit(
                      textStyle: TextStyle(color: MyStyle().red400),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future<Null> verifyToResetMachine() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String loginPassword = preferences.getString('password');
    if (loginPassword == password && username == 'admin') {
      String url =
          '${MyConstant().domain}/LeopardMachine/resetMachineToDefault.php?isAdd=true';
      Response response = await Dio().get(url);

      if (response.toString() == 'true') {
        Navigator.pop(context);
        showSnackBar(
            'เครื่องจักรที่บำรุงรักษา ได้ทำการตั้งค่าเริ่มต้นใหม่เรียบร้อยแล้ว');
      }
    } else {
      normalDialog(context, 'รหัสผ่านที่ท่านกรอกไม่ถูกต้อง');
    }
  }

  Widget passwordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextFormField(
              onChanged: (value) {
                password = value;
              },
              obscureText: true,
              decoration: InputDecoration(
                labelStyle: GoogleFonts.kanit(
                  textStyle: TextStyle(color: MyStyle().red400),
                ),
                labelText: 'รหัสผ่าน',
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

  _pendingMaintenance() {
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
                  index == 0 ? 0 : index - 1, tabType, MyStyle().red400);
        },
      ),
    );
  }

  _pendingVerify() {
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
                  index == 0 ? 0 : index - 1, tabType, MyStyle().yellow800);
        },
      ),
    );
  }

  _perfectMachine() {
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

  _listMachineItems(i, tabType, typeColor) {
    try {
      return Dismissible(
        key: UniqueKey(),
        confirmDismiss: (DismissDirection direction) async {
          if (_machinesForDisplay[i].maintenanceStatus ==
              '_pendingMaintenance') {
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
              print('1 status = ${_machinesForDisplay[i].maintenanceStatus}');
              if (_machinesForDisplay[i].maintenanceStatus ==
                      '_pendingVerify' ||
                  _machinesForDisplay[i].maintenanceStatus ==
                      '_pendingMaintenance') {
                String status = _machinesForDisplay[i].maintenanceStatus;
                print('1 machineID = ${_machinesForDisplay[i].machineID}');

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MaintenanceDetail(),
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
          ),
        ),
      );
    } catch (e) {}
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

  Future<bool> showDialogDeleteQuestion(context, index) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'คุณต้องการยกเลิกการบำรุงรักษาเครื่องจักรนี้ใช่หรือไม่?',
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

    if (_machinesForDisplay[index].maintenanceStatus == '_pendingVerify') {
      rollbackStatus = '_pendingMaintenance';
    } else if (_machinesForDisplay[index].maintenanceStatus ==
        '_perfectMachine') {
      rollbackStatus = '_pendingVerify';
    }

    String url =
        '${MyConstant().domain}/LeopardMachine/rollbackYearlyMaintenanceStatus.php?isAdd=true&machineid=$machineID&rollbackStatus=$rollbackStatus&UpdateBy=$userIDLogin&UpdateDate=$datenow';

    print('url = $url');
    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        setState(() {
          _refresh(_machinesForDisplay[index].maintenanceStatus);
        });

        AddEventLog().addEventLog(
            machineID,
            userIDLogin,
            datenow,
            '_rollbackMaintenanceMachine',
            'ยกเลิกการบำรุงเครื่องจักร',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '');
        String machineCodeSnack = _machinesForDisplay[index].machineCode;
        String message =
            'เครื่องจักร $machineCodeSnack ได้ยกเลิกการบำรุงรักษาแล้ว';
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
