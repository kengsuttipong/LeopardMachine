import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leopardmachine/model/eventlog_model.dart';
import 'package:leopardmachine/model/machine_model.dart';
import 'package:leopardmachine/screen/machine_eventlog_detail.dart';
import 'package:leopardmachine/utility/my_constant.dart';
import 'package:leopardmachine/utility/my_style.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class MachineEventLogView extends StatefulWidget {
  final MachineModel machinesForDisplay;
  MachineEventLogView({Key key, this.machinesForDisplay}) : super(key: key);

  @override
  _MachineEventLogViewState createState() => _MachineEventLogViewState();
}

class _MachineEventLogViewState extends State<MachineEventLogView> {
  EventLogModel eventLogModel;
  MachineModel machinesForDisplay;
  List<EventLogModel> _eventLog = List<EventLogModel>();
  List<EventLogModel> _eventLogForDisplay = List<EventLogModel>();
  String machineID, machineCode, generatedPdfFilePath;

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
        title: Text(
          'ประวัติเครื่องจักร $machineCode',
          style: MyStyle().kanit,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () async {
              //generatePdf();
              _printDocument();
            },
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: bodyTable(),
        scrollDirection: Axis.vertical,
      ),
    );
  }

  void _printDocument() {
    Printing.layoutPdf(
      onLayout: (pageFormat) {
        final doc = pw.Document();

        doc.addPage(
          pw.Page(
            build: (pw.Context context) => pw.Center(
              child: pw.Text('วันที่'),
            ),
          ),
        );

        return doc.save();
      },
    );
  }

  Future<void> generatePdf() async {
    var htmlContent = """
    <!DOCTYPE html>
    <html>
      <head>
        <style>
        table, th, td {
          border: 1px solid black;
          border-collapse: collapse;
        }
        th, td, p {
          padding: 5px;
          text-align: left;
        }
        </style>
      </head>
      <body>
        <h2>PDF Generated with flutter_html_to_pdf plugin</h2>
        
        <table style="width:100%">
          <caption>Sample HTML Table</caption>
          <tr>
            <th>วันที่และเวลา</th>
            <th>ผู้กระทำ</th>
            <th>หมายเหตุ</th>
          </tr>
          <tr>
            <td>January</td>
            <td>100</td>
            <td>100</td>
          </tr>
          <tr>
            <td>February</td>
            <td>50</td>
            <td>100</td>
          </tr>
        </table>
        
        <p>Image loaded from web</p>
        <img src="https://i.imgur.com/wxaJsXF.png" alt="web-img">
      </body>
    </html>
    """;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    var targetPath = appDocDir.path;
    var targetFileName = "example-pdf";

    var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        htmlContent, targetPath, targetFileName);
    generatedPdfFilePath = generatedPdfFile.path;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScaffold(
            appBar: AppBar(
              title: Text(
                "รายงานประวัติเครื่องจักร",
                style: MyStyle().kanit,
              ),
              backgroundColor: Colors.red,
            ),
            path: generatedPdfFilePath),
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
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Text(
                          eventLog.actionDate,
                          style: GoogleFonts.kanit(
                            textStyle: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                      onTap: () => navigateToLogDetail(
                          eventLog.eventlogid, eventLog.actionType),
                    ),
                    DataCell(
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Text(
                          eventLog.userfirstlastname,
                          style: GoogleFonts.kanit(
                            textStyle: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                      onTap: () => navigateToLogDetail(
                          eventLog.eventlogid, eventLog.actionType),
                    ),
                    DataCell(
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          eventLog.comment,
                          style: GoogleFonts.kanit(
                            textStyle: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                      onTap: () => navigateToLogDetail(
                          eventLog.eventlogid, eventLog.actionType),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Future<Null> navigateToLogDetail(eventlogid, actionType) async {
    if (actionType != '_holdingMaintenance' &&
        actionType != '_rollbackFixMachine' &&
        actionType != '_rollbackMaintenanceMachine') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MachineEventLogDetail(eventlogid: eventlogid),
        ),
      );
    }
  }
}
