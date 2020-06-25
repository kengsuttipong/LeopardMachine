import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leopardmachine/model/eventlog_model.dart';
import 'package:leopardmachine/model/machine_model.dart';
import 'package:leopardmachine/screen/machine_eventlog_detail.dart';
import 'package:leopardmachine/utility/my_constant.dart';

class MachineEventLogView extends StatefulWidget {
  final MachineModel machinesForDisplay;
  MachineEventLogView({Key key, this.machinesForDisplay}) : super(key: key);

  @override
  _MachineEventLogViewState createState() => _MachineEventLogViewState();
}

class _MachineEventLogViewState extends State<MachineEventLogView> {
  EventLogModel eventLog;
  MachineModel machinesForDisplay;
  List<EventLogModel> _eventLog = List<EventLogModel>();
  List<EventLogModel> _eventLogForDisplay = List<EventLogModel>();
  String machineID, machineCode;

  @override
  void initState() {
    super.initState();
    machinesForDisplay = widget.machinesForDisplay;
    machineID = machinesForDisplay.machineID;
    machineCode = machinesForDisplay.machineCode;

    _eventLogForDisplay = [];
    readDataEventLog().then((value) {
      setState(() {
        _eventLog.addAll(value);
        _eventLogForDisplay = _eventLog;
      });
    });
  }

  Future<List<EventLogModel>> readDataEventLog() async {
    try {
      String url =
          '${MyConstant().domain}/LeopardMachine/getEventLog.php?isAdd=true&MachineID=$machineID';
      print('url = $url');
      var response = await Dio().get(url);

      var events = List<EventLogModel>();
      var eventList = json.decode(response.data);
      events.clear();
      for (var eventLogJson in eventList) {
        events.add(EventLogModel.fromJson(eventLogJson));
      }
      return events;
    } catch (e) {
      return List<EventLogModel>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติเครื่องจักร $machineCode'),
      ),
      body: SingleChildScrollView(
        child: bodyTable(),
        scrollDirection: Axis.vertical,
      ),
    );
  }

  Widget bodyTable() {
    return SingleChildScrollView(
      child: Container(
        child: DataTable(
          columnSpacing: 15.0,
          sortColumnIndex: 0,
          sortAscending: true,
          columns: <DataColumn>[
            DataColumn(
              label: Text(
                'วันและเวลา',
                style: GoogleFonts.kanit(),
              ),
            ),
            DataColumn(
              label: Text(
                'ผู้กระทำ',
                style: GoogleFonts.kanit(),
              ),
            ),
            DataColumn(
              label: Text(
                'หมายเหตุ',
                style: GoogleFonts.kanit(),
              ),
            ),
          ],
          rows: _eventLogForDisplay
              .map(
                (eventLog) => DataRow(
                  cells: [
                    DataCell(
                      Container(
                        width: 70.0,
                        child: Text(
                          eventLog.actionDate,
                          style: GoogleFonts.kanit(
                            textStyle: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                      onTap: () => navigateToLogDetail(),
                    ),
                    DataCell(
                        Container(
                          width: 70.0,
                          child: Text(
                            eventLog.userfirstlastname,
                            style: GoogleFonts.kanit(
                              textStyle: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                        onTap: () => navigateToLogDetail()),
                    DataCell(
                        Text(
                          eventLog.comment,
                          style: GoogleFonts.kanit(
                            textStyle: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                        onTap: () => navigateToLogDetail()),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Future<Null> navigateToLogDetail() async {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => MachineEventLogDetail(),
    );
    Navigator.push(context, route);
  }
}
