import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leopardmachine/model/machine_model.dart';
import 'package:leopardmachine/utility/my_constant.dart';
import 'package:leopardmachine/utility/my_style.dart';
import 'package:leopardmachine/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MachineFixDetail extends StatefulWidget {
  //final MachineModel machinesForDisplay;
  //MachineFixDetail({Key key, this.machinesForDisplay}) : super(key: key);

  @override
  _MachineFixDetailState createState() => _MachineFixDetailState();
}

class _MachineFixDetailState extends State<MachineFixDetail> {
  File causeFile, fixedFile;
  String causeDetail,
      fixedDetail,
      imageCauseName,
      imageFixedName,
      imageCauseUrl,
      imageFixedUrl,
      machineID;

  MachineModel machinesForDisplay;

  // @override
  // void initState() {
  //   super.initState();
  //   machinesForDisplay = widget.machinesForDisplay;
  //   causeDetail = machinesForDisplay.causeDetail.toString();
  //   imageCauseUrl = maintenanceModel.causeImageUrl.toString();
  //   fixedDetail = maintenanceModel.fixedDetail.toString();
  //   imageFixedUrl = maintenanceModel.fixedImageUrl.toString();
  //   print('CauseDetail = $causeDetail');
  // }

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
          MyStyle().showTitle('สาเหตุ'),
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
          MyStyle().showTitle('วีธีแก้ไข'),
          MyStyle().mySizeBox(),
          solutionForm(),
          MyStyle().mySizeBox(),
          groupFixedImage(),
          MyStyle().mySizeBox(),
          saveButton(),
        ]),
      ),
    );
  }

  Widget causeForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 320.0,
            child: TextFormField(
              onChanged: (value) {
                causeDetail = value;
              },
              maxLines: 8,
              initialValue: machinesForDisplay.causeDetail,
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.add_a_photo,
              size: 36.0,
            ),
            onPressed: () {
              chooseImage(ImageSource.camera, 'causeFile');
            }),
        Container(
          width: 200.0,
          child: machinesForDisplay.causeImageUrl == null
              ? Image.asset('images/myimage.png')
              : causeFile == null
                  ? Image.network('${MyConstant().domain}' +
                      machinesForDisplay.causeImageUrl)
                  : Image.file(causeFile),
        ),
        IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              size: 36.0,
            ),
            onPressed: () {
              chooseImage(ImageSource.gallery, 'causeFile');
            }),
      ],
    );
  }

  Row groupFixedImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.add_a_photo,
              size: 36.0,
            ),
            onPressed: () {
              chooseImage(ImageSource.camera, 'fixedFile');
            }),
        Container(
          width: 200.0,
          child: machinesForDisplay.fixedImageUrl == null
              ? Image.asset('images/myimage.png')
              : fixedFile == null
                  ? Image.network('${MyConstant().domain}' +
                      machinesForDisplay.fixedImageUrl)
                  : Image.file(fixedFile),
        ),
        IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              size: 36.0,
            ),
            onPressed: () {
              chooseImage(ImageSource.gallery, 'fixedFile');
            }),
      ],
    );
  }

  Future<Null> chooseImage(ImageSource imageSource, String type) async {
    try {
      final object = await ImagePicker().getImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );

      setState(() {
        if (type == 'causeFile') {
          causeFile = File(object.path);
        } else if (type == 'fixedFile') {
          fixedFile = File(object.path);
        }
      });
    } catch (e) {}
  }

  Widget solutionForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 320.0,
            child: TextFormField(
              onChanged: (value) => fixedDetail = value.trim(),
              maxLines: 10,
              initialValue: machinesForDisplay.fixedDetail,
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

  Widget saveButton() => Container(
        width: 300.0,
        child: RaisedButton(
          color: MyStyle().red400,
          onPressed: () {
            print('causeDetail = $causeDetail , fixedDetail = $fixedDetail');
            if (causeDetail == null && fixedDetail == null) {
              if (machinesForDisplay.fixedDetail != null &&
                  machinesForDisplay.causeDetail != null) {
                normalDialog(context, 'ข้อมูลไม่มีการเปลี่ยนแปลง');
              } else {
                normalDialog(context, 'กรุณาเพิ่มข้อมูลให้ครบถ้วน');
              }
              // } else if (causeFile == null) {
              //   normalDialog(context, 'กรุณาเพิ่มรูปภาพในส่วนสาเหตุ');
              // } else if (fixedFile == null) {
              //   normalDialog(context, 'กรุณาเพิ่มรูปภาพในส่วนวิธีแก้ไข');
            } else {
              if (causeFile != null && fixedFile != null) {
                uploadCauseImage();
                uploadFixedImage();
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

  Future<Null> uploadCauseImage() async {
    Random random = Random();
    int i = random.nextInt(1000000);

    imageCauseName = 'maintenance_cause_$i.jpg';
    imageCauseUrl = '/LeopardMachine/MachineImages/$imageCauseName';

    String url = '${MyConstant().domain}/LeopardMachine/saveMachineImage.php';

    Map<String, dynamic> map = Map();
    map['file'] =
        await MultipartFile.fromFile(causeFile.path, filename: imageCauseName);

    FormData formData = FormData.fromMap(map);
    await Dio().post(url, data: formData).then((value) {
      print('1 Response : $value');
      print('2 Image Url = $imageCauseName');
    });
  }

  Future<Null> uploadFixedImage() async {
    Random random = Random();
    int i = random.nextInt(1000000);

    imageFixedName = 'maintenance_fixed_$i.jpg';
    imageFixedUrl = '/LeopardMachine/MachineImages/$imageFixedName';

    String url = '${MyConstant().domain}/LeopardMachine/saveMachineImage.php';

    Map<String, dynamic> map = Map();
    map['file'] =
        await MultipartFile.fromFile(fixedFile.path, filename: imageFixedName);

    FormData formData = FormData.fromMap(map);
    await Dio().post(url, data: formData).then((value) {
      print('1 Response : $value');
      print('2 Image Url = $imageFixedUrl');
    });
  }

  Future<Null> updateMaintenanceDetail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userIDLogin = preferences.getString('userID');
    DateTime datenow = DateTime.now();
    String machineID = machinesForDisplay.machineID;
    String nextStatus;

    causeDetail =
        causeDetail == null ? machinesForDisplay.causeDetail : causeDetail;
    fixedDetail =
        fixedDetail == null ? machinesForDisplay.fixedDetail : fixedDetail;
    imageCauseUrl = imageCauseUrl == null
        ? machinesForDisplay.causeImageUrl
        : imageCauseUrl;
    imageFixedUrl = imageFixedUrl == null
        ? machinesForDisplay.fixedImageUrl
        : imageFixedUrl;

    if (machinesForDisplay.machineMaintenanceStatus == 'holdingMaintenance') {
      nextStatus = 'maintenanceSuccessed';
    } else if (machinesForDisplay.machineMaintenanceStatus == 'maintenanceSuccessed') {
      nextStatus = 'availableMachine';
    }

    String url =
        '${MyConstant().domain}/LeopardMachine/updateMaintenanceDetailByMachineID.php?isAdd=true&UserID=$userIDLogin&MachineID=$machineID&ApplyDate=$datenow&CauseDetail=$causeDetail&CauseImageUrl=$imageCauseUrl&FixedDetail=$fixedDetail&FixedImageUrl=$imageFixedUrl&NextStatus=$nextStatus';

    try {
      print(url);
      Response response = await Dio().get(url);
      print('4 XXX');
      print('5 res = $response');

      if (response.toString() == 'true') {
        Navigator.of(context).pop('เครื่องจักร ' +
            machinesForDisplay.machineCode +
            ' ได้ทำการบันทึกแล้ว');
      } else {
        normalDialog(context, 'ไม่สามารถเพิ่มได้ กรุณาติดต่อเจ้าหน้าที่');
      }
    } catch (e) {}
  }
}
