class MachineModel {
  String machineID;
  String machineName;
  String machineCode;
  String appointmentDate;
  String imageUrl;
  String machineMaintenanceStatus;
  String causeDetail;
  String causeImageUrl;
  String fixedDetail;
  String fixedImageUrl;

  MachineModel(
      {this.machineID,
      this.machineName,
      this.machineCode,
      this.appointmentDate,
      this.imageUrl,
      this.machineMaintenanceStatus,
      this.causeDetail,
      this.causeImageUrl,
      this.fixedDetail,
      this.fixedImageUrl});

  MachineModel.fromJson(Map<String, dynamic> json) {
    machineID = json['MachineID'];
    machineName = json['MachineName'];
    machineCode = json['MachineCode'];
    appointmentDate = json['AppointmentDate'];
    imageUrl = json['ImageUrl'];
    machineMaintenanceStatus = json['machineMaintenanceStatus'];
    causeDetail = json['CauseDetail'];
    causeImageUrl = json['CauseImageUrl'];
    fixedDetail = json['FixedDetail'];
    fixedImageUrl = json['FixedImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['machineID'] = this.machineID;
    data['machineName'] = this.machineName;
    data['machineCode'] = this.machineCode;
    data['appointmentDate'] = this.appointmentDate;
    data['imageUrl'] = this.imageUrl;
    data['machineMaintenanceStatus'] = this.machineMaintenanceStatus;
    data['causeDetail'] = this.causeDetail;
    data['causeImageUrl'] = this.causeImageUrl;
    data['fixedDetail'] = this.fixedDetail;
    data['fixedImageUrl'] = this.fixedImageUrl;
    return data;
  }
}
