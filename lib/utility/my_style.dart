import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyStyle {
  Color red400 = Colors.red.shade400;
  Color yellow800 = Colors.yellow.shade800;
  Color green400 = Colors.green.shade400;
  var kanit = GoogleFonts.kanit();

  Widget showProgress(){
    return Center(child: CircularProgressIndicator(),);
  }

  SizedBox mySizeBox() => SizedBox(
        width: 8.0,
        height: 16.0,
      );

  Widget showLogo() {
    return Container(
      width: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Text showTitle(String title) => Text(
        title,
        style: GoogleFonts.kanit(
          textStyle: TextStyle(
            fontSize: 24.0,
            color: Colors.red.shade400,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  BoxDecoration myBoxDecoration(String namePic) {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/$namePic'), fit: BoxFit.cover));
  }

  Widget titleCenter(BuildContext context, String string) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Text(
          string,
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: MyStyle().red400),
        ),
      ),
    );
  }
}
