import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:leopardmachine/model/machine_model.dart';
import 'package:leopardmachine/utility/my_constant.dart';
import 'package:leopardmachine/utility/my_style.dart';
import 'package:leopardmachine/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditMachine extends StatefulWidget {
  @override
  _EditMachineState createState() => _EditMachineState();
}

class _EditMachineState extends State<EditMachine> {
  MachineModel _machinesForDisplay;
  String machineID, machineCode, machineName, _datetime, imageUrl;
  DateTime appointmentDate;
  File file;

  @override
  Widget build(BuildContext context) {
    _machinesForDisplay = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แก้ไขเครื่องจักร',
          style: MyStyle().kanit,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyStyle().mySizeBox(),
            machineIDForm(),
            MyStyle().mySizeBox(),
            machineNameForm(),
            MyStyle().mySizeBox(),
            groupImage(),
            MyStyle().mySizeBox(),
            dateForm(),
            MyStyle().mySizeBox(),
            saveButton(),
          ],
        ),
      ),
    );
  }

  Widget machineIDForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextFormField(
              textCapitalization: TextCapitalization.characters,
              onChanged: (value) {
                machineCode = value;
              },
              initialValue: _machinesForDisplay.machineCode,
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
              onChanged: (value) {
                machineName = value;
              },
              initialValue: _machinesForDisplay.machineName,
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.add_a_photo,
              size: 36.0,
            ),
            onPressed: () {
              chooseImage(ImageSource.camera);
            }),
        Container(
          width: 200.0,
          child: _machinesForDisplay.imageUrl == null
              ? Image.asset('images/myimage.png')
              : file == null
                  ? Image.network(
                      '${MyConstant().domain}' + _machinesForDisplay.imageUrl)
                  : Image.file(file),
        ),
        IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              size: 36.0,
            ),
            onPressed: () {
              chooseImage(ImageSource.gallery);
            }),
      ],
    );
  }

  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      final object = await ImagePicker().getImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );

      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget dateForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Text(_datetime == null
                ? _machinesForDisplay.appointmentDate
                : _datetime),
          ),
          IconButton(
              icon: Icon(
                Icons.calendar_today,
                color: MyStyle().red400,
              ),
              onPressed: () {
                showDatePicker(
                        context: context,
                        initialDate: appointmentDate == null
                            ? DateTime.parse(
                                _machinesForDisplay.appointmentDate)
                            : appointmentDate,
                        firstDate: DateTime(2001),
                        lastDate: DateTime(2200))
                    .then((date) {
                  setState(() {
                    appointmentDate = date;
                    _datetime = DateFormat('dd/MM/yyyy')
                        .format(date.toLocal())
                        .toString();
                  });
                });
              })
        ],
      );

  Widget saveButton() => Container(
        width: 250.0,
        child: RaisedButton(
          color: MyStyle().red400,
          onPressed: () {
            if (machineCode == null &&
                machineName == null &&
                _datetime == null &&
                file == null) {
              normalDialog(context, 'ไม่มีการเปลี่ยนแปลงข้อมูล');
            } else if (file == null && _machinesForDisplay.imageUrl == null) {
              normalDialog(context, 'กรุณาเพิ่มรูปเครื่องจักร');
            } else {
              if (file != null) {
                uploadImage();
              }
              checkDuplicateMachine();
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

  Future<Null> uploadImage() async {
    machineCode =
        machineCode == null ? _machinesForDisplay.machineCode : machineCode;
    String imageName = 'machine_$machineCode.jpg';

    String url = '${MyConstant().domain}/LeopardMachine/saveMachineImage.php';

    Map<String, dynamic> map = Map();

    map['file'] = await MultipartFile.fromFile(file.path, filename: imageName);

    FormData formData = FormData.fromMap(map);
    await Dio().post(url, data: formData).then((value) {
      print('1 Response : $value');
      imageUrl = '/LeopardMachine/MachineImages/$imageName';
      print('2 Image Url = $imageUrl');
    });
  }

  Future<Null> checkDuplicateMachine() async {
    print('machine code = ${_machinesForDisplay.machineCode}');
    machineCode =
        machineCode == null ? _machinesForDisplay.machineCode : machineCode;
    String url =
        '${MyConstant().domain}/LeopardMachine/getMachineWhereMachineCode.php?isAdd=true&MachineCode=$machineCode';

    print('url = $url');
    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'null' ||
          _machinesForDisplay.machineCode == machineCode) {
        updateMachine();
      } else {
        normalDialog(
            context, 'ไม่สามารถบันทึกได้ เนื่องจากมีชื่อผู้ใช้งานนี้แล้ว');
      }
    } catch (e) {}
  }

  Future<Null> updateMachine() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userIDLogin = preferences.getString('userID');
    DateTime datenow = DateTime.now();

    machineID = _machinesForDisplay.machineID;
    machineCode =
        machineCode == null ? _machinesForDisplay.machineCode : machineCode;
    machineName =
        machineName == null ? _machinesForDisplay.machineName : machineName;
    appointmentDate = appointmentDate == null
        ? DateTime.parse(_machinesForDisplay.appointmentDate)
        : appointmentDate;

    print('3 imageUrl = $imageUrl');
    String imageName = 'machine_$machineCode.jpg';
    imageUrl = '/LeopardMachine/MachineImages/$imageName';
    String url =
        '${MyConstant().domain}/LeopardMachine/updateMachineByMachineID.php?isAdd=true&MachineID=$machineID&MachineCode=$machineCode&MachineName=$machineName&AppointmentDate=$appointmentDate&ImageUrl=$imageUrl&UpdateBy=$userIDLogin&UpdateDate=$datenow';

    try {
      print(url);
      Response response = await Dio().get(url);
      print('4 XXX');
      print('5 res = $response');

      if (response.toString() == 'true') {       
        Navigator.of(context).pop('เครืองจักร ' + machineCode + ' ได้ทำการแก้ไขแล้ว');
      } else {
        normalDialog(context, 'ไม่สามารถเพิ่มได้ กรุณาติดต่อเจ้าหน้าที่');
      }
    } catch (e) {}
  }
}
