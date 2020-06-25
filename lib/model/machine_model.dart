class MachineModel {
  String machineID;
  String machineName;
  String machineCode;
  String appointmentDate;
  String imageUrl;
  String machineMaintenanceStatus;
  String maintenanceStatus;
  String causeDetail;
  String causeImageUrl;
  String fixedDetail;
  String fixedImageUrl;
  String issueDetail;
  String issueImageUrl;
  String solveListDetail;
  String solveListImageUrl;

  MachineModel(
      {this.machineID,
      this.machineName,
      this.machineCode,
      this.appointmentDate,
      this.imageUrl,
      this.machineMaintenanceStatus,
      this.maintenanceStatus,
      this.causeDetail,
      this.causeImageUrl,
      this.fixedDetail,
      this.fixedImageUrl,
      this.issueDetail,
      this.issueImageUrl,
      this.solveListDetail,
      this.solveListImageUrl});

  MachineModel.fromJson(Map<String, dynamic> json) {
    machineID = json['MachineID'];
    machineName = json['MachineName'];
    machineCode = json['MachineCode'];
    appointmentDate = json['AppointmentDate'];
    imageUrl = json['ImageUrl'];
    machineMaintenanceStatus = json['machineMaintenanceStatus'];
    maintenanceStatus = json['MaintenanceStatus'];
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
    data['machineID'] = this.machineID;
    data['machineName'] = this.machineName;
    data['machineCode'] = this.machineCode;
    data['appointmentDate'] = this.appointmentDate;
    data['imageUrl'] = this.imageUrl;
    data['machineMaintenanceStatus'] = this.machineMaintenanceStatus;
    data['maintenanceStatus'] = this.maintenanceStatus;
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
