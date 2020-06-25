class EventLogModel {
  String eventlogid;
  String machineid;
  String userfirstlastname;
  String actionDate;
  String actionType;
  String comment;
  String imageUrl;

  EventLogModel(
      {this.eventlogid, this.machineid, this.userfirstlastname, this.actionDate, this.actionType, this.comment, this.imageUrl});

  EventLogModel.fromJson(Map<String, dynamic> json) {
    eventlogid = json['EventLogID'];
    machineid = json['MachineID'];
    userfirstlastname = json['UserFirstLasrName'];
    actionDate = json['ActionDate'];
    actionType = json['ActionType'];
    comment = json['Comment'];
    imageUrl = json['ImageUrl'];
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
    return data;
  }
}