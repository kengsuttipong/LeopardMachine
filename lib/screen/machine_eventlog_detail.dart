import 'package:flutter/material.dart';

class MachineEventLogDetail extends StatefulWidget {
  @override
  _MachineEventLogDetailState createState() => _MachineEventLogDetailState();
}

class _MachineEventLogDetailState extends State<MachineEventLogDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดประวัติเครื่องจักร'),
      ),
    );
  }
}