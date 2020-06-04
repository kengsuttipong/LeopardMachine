class UserModel {
  String userid;
  String userType;
  String prefixid;
  String firstName;
  String lastName;
  String userName;
  String password;

  UserModel(
      {this.userid, this.userType, this.prefixid, this.firstName, this.lastName, this.userName, this.password});

  UserModel.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    userType = json['UserType'];
    prefixid = json['PrefixID'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    userName = json['UserName'];
    password = json['Password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['userType'] = this.userType;
    data['prefixid'] = this.prefixid;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['UserName'] = this.userName;
    data['Password'] = this.password;
    return data;
  }
}