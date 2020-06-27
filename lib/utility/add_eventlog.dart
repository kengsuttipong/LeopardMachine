import 'package:dio/dio.dart';
import 'package:leopardmachine/utility/my_constant.dart';

class AddEventLog {
  Future<Null> addEventLog(
      machineID,
      userIDLogin,
      actionDate,
      actionType,
      comment,
      imageUrl,
      machineCode,
      machineName,
      appointmentDate,
      causeDetail,
      imageCauseUrl,
      fixedDetail,
      imageFixedUrl,
      issueDetail,
      imageIssueUrl,
      solveListDetail,
      imageSolveListUrl) async {
    String url =
        '${MyConstant().domain}/LeopardMachine/addEventLog.php?isAdd=true&MachineID=$machineID&UserID=$userIDLogin&ActionDate=$actionDate&ActionType=$actionType&Comment=$comment&ImageUrl=$imageUrl&MachineCode=$machineCode&MachineName=$machineName&AppointmentDate=$appointmentDate&CauseDetail=$causeDetail&CauseImageUrl=$imageCauseUrl&FixedDetail=$fixedDetail&FixedImageUrl=$imageFixedUrl&IssueDetail=$issueDetail&IssueImageUrl=$imageIssueUrl&solveListDetail=$solveListDetail&solveListImageUrl=$imageSolveListUrl';

    try {
      print(url);
      Response response = await Dio().get(url);

      if (response.toString() == 'true') {
        print('Added event log success');
      }
    } catch (e) {}
  }
}
