import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leopardmachine/model/machine_model.dart';
import 'package:leopardmachine/utility/my_constant.dart';
import 'package:leopardmachine/utility/my_style.dart';
import 'package:leopardmachine/screen/add_machine.dart';
import 'package:leopardmachine/screen/edit_machine.dart';
import 'package:leopardmachine/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MachineList extends StatefulWidget {
  @override
  _MachineListState createState() => _MachineListState();
}

class _MachineListState extends State<MachineList> {
  @override
  void initState() {
    super.initState();
    readDataMachineListView().then((value) {
      setState(() {
        _machines.addAll(value);
        _machinesForDisplay = _machines;
      });
    });
  }

  List<MachineModel> _machines = List<MachineModel>();
  List<MachineModel> _machinesForDisplay = List<MachineModel>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<MachineModel>> readDataMachineListView() async {
    String url =
        '${MyConstant().domain}/LeopardMachine/getMachineListView.php?isAdd=true';
    var response = await Dio().get(url);

    var machines = List<MachineModel>();
    var machineList = json.decode(response.data);
    machines.clear();
    for (var machinesJson in machineList) {
      machines.add(MachineModel.fromJson(machinesJson));
    }

    return machines;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'เพิ่มข้อมูลเครื่องจักร',
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
              itemCount: _machinesForDisplay.length + 1,
              itemBuilder: (context, index) {
                return index == 0 ? _searchBar() : _listMachineItems(index - 1);
              },
            ),
          ),
          addButton(),
        ],
      ),
    );
  }

  Future<Null> _refresh() {
    return readDataMachineListView().then((_user) {
      setState(() {
        _machinesForDisplay = _user;
        _machines = _user;
      });
    });
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

  _listMachineItems(index) {
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
            backgroundImage: NetworkImage(
                _machinesForDisplay[index].imageUrl == null
                    ? '${MyConstant().domain}' +
                        '/' +
                        _machinesForDisplay[index].imageUrl
                    : '${MyConstant().domain}' +
                        _machinesForDisplay[index].imageUrl),
          ),
          title: Text(
            _machinesForDisplay[index].machineName,
            style: GoogleFonts.kanit(
              textStyle: TextStyle(
                color: MyStyle().red400,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'รหัสเครื่อง : ' + _machinesForDisplay[index].machineCode,
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
            print('Tab');
            _navigateToEditPage(context, index);
          },       
        ),
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

  _navigateToEditPage(BuildContext context, index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMachine(),
        settings: RouteSettings(arguments: _machinesForDisplay[index]),
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
        title: Text(
          'คูณต้องการลบเครื่องจักรใช่หรือไม่?',
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
                  deleteDataMachineListView(index);
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

  Future<Null> deleteDataMachineListView(index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userIDLogin = preferences.getString('userID');
    DateTime datenow = DateTime.now();
    String machineID = _machinesForDisplay[index].machineID;

    String url =
        '${MyConstant().domain}/LeopardMachine/deleteMachineByMachineID.php?isAdd=true&machineid=$machineID&UpdateBy=$userIDLogin&UpdateDate=$datenow';

    print('url = $url');
    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        setState(() {
          _refresh();
        });
        String machineCodeSnack = _machinesForDisplay[index].machineCode;
        showSnackBar(machineCodeSnack);
      } else {
        normalDialog(context, 'ไม่สามารถลบข้อมูลได้ กรุณาติดต่อเจ้าหน้าที่');
      }
    } catch (e) {}
  }

  showSnackBar(machineCodeSnack) {
    final snackBar = SnackBar(
      content: Text(
        'เครื่องจักร $machineCodeSnack ได้ถูกลบแล้ว',
        style: GoogleFonts.kanit(
          textStyle: TextStyle(
            color: Colors.blue.shade300,
          ),
        ),
      ),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
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
                  routeToAddMachine();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  routeToAddMachine() async {
    print('routeToAddUser');
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMachine(),
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
