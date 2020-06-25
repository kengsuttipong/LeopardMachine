import 'package:dio/dio.dart';
import 'package:leopardmachine/utility/my_constant.dart';

class AddEventLog {
  Future<Null> addEventLog() async {
    //imageUrl = '/LeopardMachine/MachineImages/$imageName';
    String url =
        '${MyConstant().domain}/LeopardMachine/addMachine.php?isAdd=true';

    try {
      print(url);
      Response response = await Dio().get(url);

      if (response.toString() == 'true') {
        print('Added event log success');
      }
    } catch (e) {}
  }
}
