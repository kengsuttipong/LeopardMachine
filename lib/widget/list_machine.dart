import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leopardmachine/model/machine_model.dart';
import 'package:leopardmachine/utility/my_constant.dart';
import 'package:leopardmachine/utility/my_style.dart';
import 'package:leopardmachine/screen/add_machine.dart';

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
    return Stack(
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
          _machinesForDisplay[index].machineName,
          style: TextStyle(
            color: MyStyle().red400,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('รหัสเครื่อง : ' + _machinesForDisplay[index].machineCode),
            Text('วันซ่อมบำรุงครั้งต่อไป : ' +
                _machinesForDisplay[index].appointmentDate),
          ],
        ),
        onTap: () {
          print('Tab');
        },
        onLongPress: () {
          showDialogYesNoQuestion(context, index);
        },
      ),
    );
  }

  showDialogYesNoQuestion(context, index) {
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
                          Navigator.pop(context);
                        },
                        child: Text(
                          'ยกเลิก',
                          style: TextStyle(color: MyStyle().red400),
                        )),
                    FlatButton(
                        onPressed: () {
                          deleteDataMachineListView();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'ใช่',
                          style: TextStyle(color: MyStyle().red400),
                        )),
                  ],
                )
              ],
            ));
  }

  Future<Null> deleteDataMachineListView() async {
    // String url =
    //     '${MyConstant().domain}/LeopardMachine/getMachineListView.php?isAdd=true';
    // var response = await http.get(url);
    // var machineList = json.decode(response.body);
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

  void routeToAddMachine() {
    print('routeToAddMachine');
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => AddMachine(),
    );
    Navigator.push(context, materialPageRoute);
  }
}
