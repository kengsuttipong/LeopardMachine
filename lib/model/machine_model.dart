class MachineModel {
  String machineName;
  String machineCode;
  String appointmentDate;
  String imageUrl;

  MachineModel(
      {this.machineName, this.machineCode, this.appointmentDate, this.imageUrl});

  MachineModel.fromJson(Map<String, dynamic> json) {
    machineName = json['MachineName'];
    machineCode = json['MachineCode'];
    appointmentDate = json['AppointmentDate'];
    imageUrl = json['ImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['machineName'] = this.machineName;
    data['machineCode'] = this.machineCode;
    data['appointmentDate'] = this.appointmentDate;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}