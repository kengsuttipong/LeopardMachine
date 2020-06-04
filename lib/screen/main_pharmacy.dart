import 'package:flutter/material.dart';
import 'package:leopardmachine/utility/my_style.dart';
import 'package:leopardmachine/utility/signout_process.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leopardmachine/widget/list_user.dart';
import 'package:leopardmachine/widget/list_machine.dart';
import 'package:leopardmachine/widget/list_solution.dart';

class MainPharmacy extends StatefulWidget {
  @override
  _MainPharmacyState createState() => _MainPharmacyState();
}

class _MainPharmacyState extends State<MainPharmacy> {
  String firstName, lastName;
  Widget currentWidget = ListSolution();

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeadDrawer(),
            mainMenu(),
            userMenu(),
            machineMenu(),
            signOutMenu(),
          ],
        ),
      );

  ListTile mainMenu() => ListTile(
        leading: Icon(Icons.home),
        title: Text('หน้าแรก'),
        onTap: () {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (value) => MainPharmacy(),
          );
          Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
        },
      );

  ListTile userMenu() => ListTile(
        leading: Icon(Icons.supervised_user_circle),
        title: Text('ดูรายชื่อพนักงาน'),
        onTap: () {
          setState(() {
            currentWidget = UserList();
          });
          Navigator.pop(context);
        },
      );

  ListTile machineMenu() => ListTile(
        leading: Icon(Icons.build),
        title: Text('ดูรายชื่อเครื่องจักร'),
        onTap: () {
          setState(() {
            currentWidget = MachineList();
          });
          Navigator.pop(context);
        },
      );

  ListTile signOutMenu() => ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('ออกจากระบบ'),
        onTap: () => signOutProcess(context),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: showDrawer(),
      appBar: AppBar(
        title: Text(firstName == null
            ? 'สำหรับเภสัชกร'
            : '$firstName $lastName กำลังใช้งาน'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => signOutProcess(context))
        ],
      ),
      body: currentWidget,
    );
  }

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
        //decoration: MyStyle().myBoxDecoration('pharmacy.jpg'),
        accountName: Text(
          '$firstName $lastName',
          style: TextStyle(color: MyStyle().red400),
        ),
        accountEmail: Text(
          'กำลังใช้งาน',
          style: TextStyle(color: MyStyle().red400),
        ));
  }

  @override
  void initState() {
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      firstName = preferences.getString('FirstName');
      lastName = preferences.getString('LastName');
    });
  }
}
