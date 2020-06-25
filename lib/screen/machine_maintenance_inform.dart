import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leopardmachine/model/machine_model.dart';
import 'package:leopardmachine/screen/machine_maintenance_detail.dart';
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
  String tabType;

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'รอบำรุงรักษา'),
    Tab(text: 'รอตรวจสอบ'),
    Tab(text: 'บำรุงรักษาเสร็จ'),
  ];

  @override
  void initState() {
    super.initState();
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
          bottom: TabBar(
            indicatorColor: Colors.yellow,
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
              print(
                  '1 status = ${_machinesForDisplay[i].maintenanceStatus}');
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
                  //insertInformFixMachine(
                  // _machinesForDisplay[i], maintenanceStatus);
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

    if (_machinesForDisplay[index].maintenanceStatus ==
        '_pendingVerify') {
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
