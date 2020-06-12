import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leopardmachine/utility/my_style.dart';

class MachineFixDetail extends StatefulWidget {
  @override
  _MachineFixDetailState createState() => _MachineFixDetailState();
}

class _MachineFixDetailState extends State<MachineFixDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'test',
          style: MyStyle().kanit,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          MyStyle().mySizeBox(),
          causeForm(),
          MyStyle().mySizeBox(),
          solutionForm(),
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
            child: TextField(
              maxLines: 8,
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

  Widget solutionForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 320.0,
            child: TextField(
              maxLines: 10,
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
        width: 200.0,
        child: RaisedButton(
          color: MyStyle().red400,
          onPressed: () {
           
          },
          child: Text(
            'บันทึก',
            style: GoogleFonts.kanit(
              textStyle: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
}
