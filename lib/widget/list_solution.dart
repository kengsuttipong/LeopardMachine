import 'package:flutter/material.dart';
import 'package:leopardmachine/screen/machine_fix_inform.dart';
import 'package:leopardmachine/utility/my_style.dart';

class ListSolution extends StatefulWidget {
  @override
  _ListSolutionState createState() => _ListSolutionState();
}

class _ListSolutionState extends State<ListSolution> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                machineFixInform(),
                MyStyle().mySizeBox(),
                machineMaintenanceInform(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget machineFixInform() => Container(
      width: 250.0,
      child: RaisedButton(
        color: MyStyle().red400,
        onPressed: () {
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (value) => MachineFixedInform());

          Navigator.of(context).push(materialPageRoute);
        },
        child: Text(
          'แจ้งซ่อมเครื่องจักร',
          style: TextStyle(color: Colors.white),
        ),
      ));

  Widget machineMaintenanceInform() => Container(
      width: 250.0,
      child: RaisedButton(
        color: MyStyle().red400,
        onPressed: () {},
        child: Text(
          'บำรุงเครื่องจักร',
          style: TextStyle(color: Colors.white),
        ),
      ));
}
