class EventLogModel {
  String eventlogid;
  String machineid;
  String userfirstlastname;
  String actionDate;
  String actionType;
  String comment;
  String imageUrl;
  String machineCode;
  String machineName;
  String maintenanceDate;
  String causeDetail;
  String causeImageUrl;
  String fixedDetail;
  String fixedImageUrl;
  String issueDetail;
  String issueImageUrl;
  String solveListDetail;
  String solveListImageUrl;

  EventLogModel(
      {this.eventlogid,
      this.machineid,
      this.userfirstlastname,
      this.actionDate,
      this.actionType,
      this.comment,
      this.imageUrl,
      this.machineCode,
      this.machineName,
      this.maintenanceDate,
      this.causeDetail,
      this.causeImageUrl,
      this.fixedDetail,
      this.fixedImageUrl,
      this.issueDetail,
      this.issueImageUrl,
      this.solveListDetail,
      this.solveListImageUrl});

  EventLogModel.fromJson(Map<String, dynamic> json) {
    eventlogid = json['EventLogID'];
    machineid = json['MachineID'];
    userfirstlastname = json['UserFirstLasrName'];
    actionDate = json['ActionDate'];
    actionType = json['ActionType'];
    comment = json['Comment'];
    imageUrl = json['ImageUrl'];
    machineCode = json['MachineCode'];
    machineName = json['MachineName'];
    maintenanceDate = json['MaintenanceDate'];
    causeDetail = json['CauseDetail'];
    causeImageUrl = json['CauseImageUrl'];
    fixedDetail = json['FixedDetail'];
    fixedImageUrl = json['FixedImageUrl'];
    issueDetail = json['IssueDetail'];
    issueImageUrl = json['IssueImageUrl'];
    solveListDetail = json['SolveListDetail'];
    solveListImageUrl = json['SolveListImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventlogid'] = this.eventlogid;
    data['machineid'] = this.machineid;
    data['userfirstlastname'] = this.userfirstlastname;
    data['actionDate'] = this.actionDate;
    data['actionType'] = this.actionType;
    data['comment'] = this.comment;
    data['imageUrl'] = this.imageUrl;
    data['machineCode'] = this.machineCode;
    data['machineName'] = this.machineName;
    data['maintenanceDate'] = this.maintenanceDate;
    data['causeDetail'] = this.causeDetail;
    data['causeImageUrl'] = this.causeImageUrl;
    data['fixedDetail'] = this.fixedDetail;
    data['fixedImageUrl'] = this.fixedImageUrl;
    data['issueDetail'] = this.issueDetail;
    data['issueImageUrl'] = this.issueImageUrl;
    data['solveListDetail'] = this.solveListDetail;
    data['solveListImageUrl'] = this.solveListImageUrl;

    return data;
  }
}
