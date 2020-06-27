import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leopardmachine/model/eventlog_model.dart';
import 'package:leopardmachine/utility/my_constant.dart';
import 'package:leopardmachine/utility/my_style.dart';

class MachineEventLogDetail extends StatefulWidget {
  final eventlogid;
  MachineEventLogDetail({Key key, this.eventlogid}) : super(key: key);

  @override
  _MachineEventLogDetailState createState() => _MachineEventLogDetailState();
}

class _MachineEventLogDetailState extends State<MachineEventLogDetail> {
  String eventlogid;
  String machineCode,
      machineName,
      imageUrl,
      maintenanceDate,
      userfirstlastname,
      actiondate,
      userAction,
      actionType,
      causeDetail,
      causeImageUrl,
      fixedDetail,
      fixedImageUrl,
      issueDetail,
      issueImageUrl,
      solveListDetail,
      solveListImageUrl;
  EventLogModel eventLogModel = new EventLogModel();

  @override
  void initState() {
    super.initState();
    eventlogid = widget.eventlogid;

    readDataEventLogDetail().then((eventLogModel) {
      setState(() {
        machineCode = eventLogModel.machineCode;
        machineName = eventLogModel.machineName;
        imageUrl = eventLogModel.imageUrl;
        maintenanceDate = eventLogModel.maintenanceDate;
        userfirstlastname = eventLogModel.userfirstlastname;
        actiondate = eventLogModel.actionDate;
        actionType = eventLogModel.actionType;
        causeDetail = eventLogModel.causeDetail;
        causeImageUrl = eventLogModel.causeImageUrl;
        fixedDetail = eventLogModel.fixedDetail;
        fixedImageUrl = eventLogModel.fixedImageUrl;
        issueDetail = eventLogModel.issueDetail;
        issueImageUrl = eventLogModel.issueImageUrl;
        solveListDetail = eventLogModel.solveListDetail;
        solveListImageUrl = eventLogModel.solveListImageUrl;

        if (eventLogModel.actionType == '_addMachine') {
          userAction = 'ผู้สร้าง';
        } else if (eventLogModel.actionType == '_editMachine') {
          userAction = 'ผู้แก้ไข';
        } else if (eventLogModel.actionType == '_maintenanceSuccessed' || eventLogModel.actionType == '_pendingVerify') {
          userAction = 'ผู้ซ่อม';
        } else if (eventLogModel.actionType == '_availableMachine' || eventLogModel.actionType == '_perfectMachine') {
          userAction = 'ผู้ตรวจสอบ';
        }
      });
    });
  }

  Future<EventLogModel> readDataEventLogDetail() async {
    String url =
        '${MyConstant().domain}/LeopardMachine/getEventLogDetail.php?isAdd=true&EventLogID=$eventlogid';

    try {
      print('url = $url');
      var response = await Dio().get(url);

      var eventList = json.decode(response.data);
      for (var eventLogJson in eventList) {
        eventLogModel = EventLogModel.fromJson(eventLogJson);
      }
      return eventLogModel;
    } catch (e) {
      return eventLogModel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายละเอียดประวัติเครื่องจักร',
          style: MyStyle().kanit,
        ),
      ),
      body: eventLogDetail(),
    );
  }

  Widget eventLogDetail() {
    if (actionType == '_addMachine' || actionType == '_editMachine') {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyStyle().mySizeBox(),
            machineCodeForm(),
            MyStyle().mySizeBox(),
            machineNameForm(),
            MyStyle().mySizeBox(),
            groupImage(),
            MyStyle().mySizeBox(),
            dateForm(),
            MyStyle().mySizeBox(),
            MyStyle().mySizeBox(),
            MyStyle().mySizeBox(),
            detail(),
          ],
        ),
      );
    } else if (actionType == '_maintenanceSuccessed' ||
        actionType == '_availableMachine') {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyStyle().mySizeBox(),
            causeForm(),
            MyStyle().mySizeBox(),
            groupCauseImage(),
            MyStyle().mySizeBox(),
            const Divider(
              color: Colors.red,
              height: 20,
              thickness: 5,
              indent: 40,
              endIndent: 40,
            ),
            MyStyle().mySizeBox(),
            solutionForm(),
            MyStyle().mySizeBox(),
            groupFixedImage(),
            MyStyle().mySizeBox(),
            MyStyle().mySizeBox(),
            MyStyle().mySizeBox(),
            detail(),
          ],
        ),
      );
    } else if (actionType == '_pendingVerify' || actionType == '_perfectMachine') {
      return SingleChildScrollView(
        child: Column(children: <Widget>[
          MyStyle().mySizeBox(),
          issueForm(),
          MyStyle().mySizeBox(),
          groupIssueImage(),
          MyStyle().mySizeBox(),
          const Divider(
            color: Colors.black87,
            height: 20,
            thickness: 5,
            indent: 25,
            endIndent: 25,
          ),
          MyStyle().mySizeBox(),
          solveListForm(),
          MyStyle().mySizeBox(),
          groupSolveListImage(),
          MyStyle().mySizeBox(),
          MyStyle().mySizeBox(),
          MyStyle().mySizeBox(),
          detail(),
        ]),
      );
    } else {
      return null;
    }
  }

  Widget issueForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 320.0,
            child: TextFormField(
              enabled: false,
              maxLines: 8,
              initialValue: issueDetail,
              decoration: InputDecoration(
                labelStyle: GoogleFonts.kanit(
                  textStyle: TextStyle(color: MyStyle().red400),
                ),
                labelText: 'ปัญหาที่พบ',
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

  Row groupIssueImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200.0,
          child: Image.network('${MyConstant().domain}' + issueImageUrl),
        ),
      ],
    );
  }

  Widget solveListForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 320.0,
            child: TextFormField(
              enabled: false,
              maxLines: 10,
              initialValue: solveListDetail,
              decoration: InputDecoration(
                labelStyle: GoogleFonts.kanit(
                  textStyle: TextStyle(color: MyStyle().red400),
                ),
                labelText: 'รายการบำรุงรักษา',
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

  Row groupSolveListImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200.0,
          child: Image.network('${MyConstant().domain}' + solveListImageUrl),
        ),
      ],
    );
  }

  Widget causeForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 320.0,
            child: TextFormField(
              enabled: false,
              maxLines: 8,
              initialValue: causeDetail,
              decoration: InputDecoration(
                labelStyle: GoogleFonts.kanit(
                  textStyle: TextStyle(color: MyStyle().red400),
                ),
                labelText: 'สาเหตุ',
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

  Row groupCauseImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200.0,
          child: causeImageUrl == null
              ? Image.asset('images/myimage.png')
              : Image.network('${MyConstant().domain}' + causeImageUrl),
        ),
      ],
    );
  }

  Widget solutionForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 320.0,
            child: TextFormField(
              enabled: false,
              maxLines: 10,
              initialValue: fixedDetail,
              decoration: InputDecoration(
                labelStyle: GoogleFonts.kanit(
                  textStyle: TextStyle(color: MyStyle().red400),
                ),
                labelText: 'วิธีแก้ไข',
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

  Row groupFixedImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200.0,
          child: fixedImageUrl == null
              ? Image.asset('images/myimage.png')
              : Image.network('${MyConstant().domain}' + fixedImageUrl),
        ),
      ],
    );
  }

  Widget machineCodeForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextFormField(
              enabled: false,
              textCapitalization: TextCapitalization.characters,
              initialValue: machineCode,
              decoration: InputDecoration(
                labelStyle: GoogleFonts.kanit(
                  textStyle: TextStyle(color: MyStyle().red400),
                ),
                labelText: 'รหัสเครื่องจักร',
                prefixIcon: Icon(
                  Icons.account_box,
                  color: MyStyle().red400,
                ),
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

  Widget machineNameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextFormField(
              enabled: false,
              initialValue: machineName,
              decoration: InputDecoration(
                labelStyle: GoogleFonts.kanit(
                  textStyle: TextStyle(color: MyStyle().red400),
                ),
                labelText: 'ชื่อเครื่องจักร',
                prefixIcon: Icon(
                  Icons.account_box,
                  color: MyStyle().red400,
                ),
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

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200.0,
          child: imageUrl == null
              ? Image.asset('images/myimage.png')
              : Image.network('${MyConstant().domain}' + imageUrl),
        ),
      ],
    );
  }

  Widget dateForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Text(
              'วันที่บำรุงรักษา : ' + maintenanceDate,
              style: MyStyle().kanit,
            ),
          ),
          Icon(
            Icons.calendar_today,
            color: MyStyle().red400,
          ),
        ],
      );

  Widget detail() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                '$userAction : ' + userfirstlastname,
                style: MyStyle().kanit,
              ),
              Text(
                'วันที่ : ' + actiondate,
                style: MyStyle().kanit,
              ),
            ],
          ),
        ],
      );
}
