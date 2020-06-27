import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leopardmachine/model/machine_model.dart';
import 'package:leopardmachine/utility/add_eventlog.dart';
import 'package:leopardmachine/utility/my_constant.dart';
import 'package:leopardmachine/utility/my_style.dart';
import 'package:leopardmachine/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaintenanceDetail extends StatefulWidget {
  @override
  _MaintenanceDetailState createState() => _MaintenanceDetailState();
}

class _MaintenanceDetailState extends State<MaintenanceDetail> {
  String issueDetail,
      solveListDetail,
      imageIssueName,
      imageIssueUrl,
      imageSolveListName,
      imageSolveListUrl,
      userType;
  File issueFile, solveListFile;
  MachineModel machinesForDisplay;

  @override
  void initState() {
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userType = preferences.getString('UserType');
    });
  }

  @override
  Widget build(BuildContext context) {
    machinesForDisplay = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายละเอียดการซ่อมบำรุง',
          style: MyStyle().kanit,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          MyStyle().mySizeBox(),
          MyStyle().showTitle('ปัญหาที่พบ'),
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
          MyStyle().showTitle('รายการบำรุงรักษา'),
          MyStyle().mySizeBox(),
          solveListForm(),
          MyStyle().mySizeBox(),
          groupSolveListImage(),
          MyStyle().mySizeBox(),
          saveButton(),
        ]),
      ),
    );
  }

  Widget issueForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 320.0,
            child: TextFormField(
              onChanged: (value) {
                issueDetail = value;
              },
              maxLines: 8,
              initialValue: machinesForDisplay.issueDetail,
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.add_a_photo,
              size: 36.0,
            ),
            onPressed: () {
              chooseImage(ImageSource.camera, 'issueFile');
            }),
        Container(
          width: 200.0,
          child: (machinesForDisplay.issueImageUrl != null &&
                  machinesForDisplay.issueImageUrl.isNotEmpty)
              ? Image.network(
                  '${MyConstant().domain}' + machinesForDisplay.issueImageUrl)
              : issueFile == null
                  ? Image.asset('images/myimage.png')
                  : Image.file(issueFile),
        ),
        IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              size: 36.0,
            ),
            onPressed: () {
              chooseImage(ImageSource.gallery, 'issueFile');
            }),
      ],
    );
  }

  Widget solveListForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 320.0,
            child: TextFormField(
              onChanged: (value) => solveListDetail = value.trim(),
              maxLines: 10,
              initialValue: machinesForDisplay.solveListDetail,
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.add_a_photo,
              size: 36.0,
            ),
            onPressed: () {
              chooseImage(ImageSource.camera, 'solveListFile');
            }),
        Container(
          width: 200.0,
          child: (machinesForDisplay.solveListImageUrl != null &&
                  machinesForDisplay.solveListImageUrl.isNotEmpty)
              ? Image.network('${MyConstant().domain}' +
                  machinesForDisplay.solveListImageUrl)
              : solveListFile == null
                  ? Image.asset('images/myimage.png')
                  : Image.file(solveListFile),
        ),
        IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              size: 36.0,
            ),
            onPressed: () {
              chooseImage(ImageSource.gallery, 'solveListFile');
            }),
      ],
    );
  }

  Widget saveButton() => Container(
        width: 300.0,
        child: RaisedButton(
          color: MyStyle().red400,
          onPressed: () {
            print(
                'issueDetail = $issueDetail , solveListDetail = $solveListDetail');

            if ((solveListDetail == null || solveListDetail.isEmpty) &&
                (machinesForDisplay.solveListDetail == null ||
                    machinesForDisplay.solveListDetail.isEmpty)) {
              normalDialog(context, 'กรูณากรอกรายการบำรุงรักษา');
            } else {
              if (issueFile != null) {
                uploadIssueImage();
              }
              if (solveListFile != null) {
                uploadSolveListImage();
              }
              updateMaintenanceDetail();
            }
          },
          child: Text(
            'บันทึก',
            style: GoogleFonts.kanit(
              textStyle: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );

  Future<Null> uploadIssueImage() async {
    Random random = Random();
    int i = random.nextInt(1000000);

    imageIssueName = 'maintenance_issue_$i.jpg';
    imageIssueUrl = '/LeopardMachine/MachineImages/$imageIssueName';

    String url = '${MyConstant().domain}/LeopardMachine/saveMachineImage.php';

    Map<String, dynamic> map = Map();
    map['file'] =
        await MultipartFile.fromFile(issueFile.path, filename: imageIssueName);

    FormData formData = FormData.fromMap(map);
    await Dio().post(url, data: formData).then((value) {
      print('1 Response : $value');
      print('2 Image Url = $imageIssueName');
    });
  }

  Future<Null> uploadSolveListImage() async {
    Random random = Random();
    int i = random.nextInt(1000000);

    imageSolveListName = 'maintenance_solve_$i.jpg';
    imageSolveListUrl = '/LeopardMachine/MachineImages/$imageSolveListName';

    String url = '${MyConstant().domain}/LeopardMachine/saveMachineImage.php';

    Map<String, dynamic> map = Map();
    map['file'] = await MultipartFile.fromFile(solveListFile.path,
        filename: imageSolveListName);

    FormData formData = FormData.fromMap(map);
    await Dio().post(url, data: formData).then((value) {
      print('1 Response : $value');
      print('2 Image Url = $imageSolveListName');
    });
  }

  Future<Null> updateMaintenanceDetail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userIDLogin = preferences.getString('userID');
    DateTime datenow = DateTime.now();
    String machineID = machinesForDisplay.machineID;
    String nextStatus, eventLogStatus, eventLogComment;

    issueDetail =
        issueDetail == null ? machinesForDisplay.issueDetail : issueDetail;
    solveListDetail = solveListDetail == null
        ? machinesForDisplay.solveListDetail
        : solveListDetail;
    imageIssueUrl = imageIssueUrl == null
        ? machinesForDisplay.issueImageUrl
        : imageIssueUrl;
    imageSolveListUrl = imageSolveListUrl == null
        ? machinesForDisplay.solveListImageUrl
        : imageSolveListUrl;

    if (machinesForDisplay.maintenanceStatus == '_pendingMaintenance') {
      nextStatus = '_pendingVerify';
      eventLogStatus = '_pendingVerify';
      eventLogComment = 'ทำการบำรุงรักษาเครื่องจักร';
    } else if (machinesForDisplay.maintenanceStatus == '_pendingVerify') {
      nextStatus = '_perfectMachine';
      eventLogStatus = '_perfectMachine';
      eventLogComment = 'ตรวจสอบการบำรุงรักษาเครื่องจักร';
    }

    String url =
        '${MyConstant().domain}/LeopardMachine/updateYearlyMaintenanceDetailByMachineID.php?isAdd=true&UserID=$userIDLogin&MachineID=$machineID&ApplyDate=$datenow&IssueDetail=$issueDetail&IssueImageUrl=$imageIssueUrl&solveListDetail=$solveListDetail&solveListImageUrl=$imageSolveListUrl&NextStatus=$nextStatus';

    try {
      print(url);
      Response response = await Dio().get(url);
      print('4 XXX');
      print('5 res = $response');

      if (response.toString() == 'true') {
        AddEventLog().addEventLog(
            machineID,
            userIDLogin,
            datenow,
            eventLogStatus,
            eventLogComment,
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            '',
            issueDetail,
            imageIssueUrl,
            solveListDetail,
            imageSolveListUrl);

        Navigator.of(context).pop('เครื่องจักร ' +
            machinesForDisplay.machineCode +
            ' ได้ทำการบันทึกแล้ว');
      } else {
        normalDialog(context, 'ไม่สามารถเพิ่มได้ กรุณาติดต่อเจ้าหน้าที่');
      }
    } catch (e) {}
  }

  Future<Null> chooseImage(ImageSource imageSource, String type) async {
    try {
      final object = await ImagePicker().getImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );

      setState(() {
        if (type == 'issueFile') {
          issueFile = File(object.path);
        } else if (type == 'solveListFile') {
          solveListFile = File(object.path);
        }
      });
    } catch (e) {}
  }
}
