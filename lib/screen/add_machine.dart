import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:leopardmachine/utility/my_constant.dart';
import 'package:leopardmachine/utility/my_style.dart';
import 'package:intl/intl.dart';
import 'package:leopardmachine/utility/normal_dialog.dart';
import 'package:image_picker/image_picker.dart';

class AddMachine extends StatefulWidget {
  @override
  _AddMachineState createState() => _AddMachineState();
}

class _AddMachineState extends State<AddMachine> {
  String machineCode, machineName, _datetime, imageUrl;
  DateTime appointmentDate;
  File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มเครื่องมือ/เครื่องจักร'),
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
            saveButton()
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
            child: TextField(
              textCapitalization: TextCapitalization.characters,
              onChanged: (value) => machineCode = value.trim(),
              decoration: InputDecoration(
                labelStyle: TextStyle(color: MyStyle().red400),
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
            child: TextField(
              onChanged: (value) => machineName = value.trim(),
              decoration: InputDecoration(
                labelStyle: TextStyle(color: MyStyle().red400),
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
          child: file == null
              ? Image.asset('images/myimage.png')
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

  Widget dateForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Text(_datetime == null ? 'ยังไม่ได้เลือกวันที่' : _datetime),
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
                            ? DateTime.now()
                            : appointmentDate,
                        firstDate: DateTime(2001),
                        lastDate: DateTime(2200))
                    .then((date) {
                  setState(() {
                    appointmentDate = date;
                    _datetime = DateFormat('dd/MM/yyyy').format(date.toLocal());
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
            if (machineCode == null ||
                machineCode.isEmpty ||
                machineName == null ||
                machineName.isEmpty) {
              normalDialog(context, 'มีช่องว่าง กรุณากรอกข้อมูลให้ครบถ้วน');
            } else if (file == null) {
              normalDialog(context, 'กรุณาเพิ่มรูปเครื่องจักร');
            } else if (_datetime == null || _datetime.isEmpty) {
              normalDialog(context, 'กรุณาเพิ่มวันที่');
            } else {
              if (file != null) {
                uploadImage();
              }
              checkDuplicateMachine();
            }
          },
          child: Text(
            'เพิ่มเครื่องจักร',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  Future<Null> uploadImage() async {
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
    String url =
        '${MyConstant().domain}/LeopardMachine/getMachineWhereMachineCode.php?isAdd=true&MachineCode=$machineCode';

    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'null') {
        insertUpdateMachine();
      } else {
        normalDialog(
            context, 'ไม่สามารถบันทึกได้ เนื่องจากมีชื่อผู้ใช้งานนี้แล้ว');
      }
    } catch (e) {}
  }

  Future<Null> insertUpdateMachine() async {
    print('3 imageUrl = $imageUrl');
    String imageName = 'machine_$machineCode.jpg';
    imageUrl = '/LeopardMachine/MachineImages/$imageName';
    String url =
        '${MyConstant().domain}/LeopardMachine/addMachine.php?isAdd=true&MachineCode=$machineCode&MachineName=$machineName&ImageUrl=$imageUrl&AppointmentDate=$appointmentDate';

    try {
      print(url);
      Response response = await Dio().get(url);
      print('4 XXX');
      print('5 res = $response');

      if (response.toString() == 'true') {
        // MaterialPageRoute route = MaterialPageRoute(
        //   builder: (value) => MachineList(),
        // );
        Navigator.of(context).maybePop();
      } else {
        normalDialog(context, 'ไม่สามารถเพิ่มได้ กรุณาติดต่อเจ้าหน้าที่');
      }
    } catch (e) {}
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
}
