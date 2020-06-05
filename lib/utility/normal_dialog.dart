import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leopardmachine/utility/my_style.dart';

Future<void> normalDialog(BuildContext context, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(
        message,
        style: MyStyle().kanit,
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ตกลง',
                    style: GoogleFonts.kanit(
                      textStyle: TextStyle(
                        color: Colors.red,
                      ),
                    ))),
          ],
        )
      ],
    ),
  );
}
