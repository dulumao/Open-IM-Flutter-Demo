class LoginResult {
  LoginUser? data;
  int? errCode;
  String? errMsg;

  LoginResult({this.data, this.errCode, this.errMsg});

  LoginResult.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new LoginUser.fromJson(json['data']) : null;
    errCode = json['errCode'];
    errMsg = json['errMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['errCode'] = this.errCode;
    data['errMsg'] = this.errMsg;
    return data;
  }
}

class LoginUser {
  String? birth;
  String? email;
  String? ex;
  int? gender;
  String? icon;
  String? mobile;
  String? name;
  OpenImToken? openImToken;
  Token? token;
  String? uid;

  LoginUser(
      {this.birth,
      this.email,
      this.ex,
      this.gender,
      this.icon,
      this.mobile,
      this.name,
      this.openImToken,
      this.token,
      this.uid});

  LoginUser.fromJson(Map<String, dynamic> json) {
    birth = json['birth'];
    email = json['email'];
    ex = json['ex'];
    gender = json['gender'];
    icon = json['icon'];
    mobile = json['mobile'];
    name = json['name'];
    openImToken = json['openImToken'] != null
        ? new OpenImToken.fromJson(json['openImToken'])
        : null;
    token = json['token'] != null ? new Token.fromJson(json['token']) : null;
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['birth'] = this.birth;
    data['email'] = this.email;
    data['ex'] = this.ex;
    data['gender'] = this.gender;
    data['icon'] = this.icon;
    data['mobile'] = this.mobile;
    data['name'] = this.name;
    if (this.openImToken != null) {
      data['openImToken'] = this.openImToken?.toJson();
    }
    if (this.token != null) {
      data['token'] = this.token?.toJson();
    }
    data['uid'] = this.uid;
    return data;
  }
}

class OpenImToken {
  int? expiredTime;
  String? token;
  String? uid;

  OpenImToken({this.expiredTime, this.token, this.uid});

  OpenImToken.fromJson(Map<String, dynamic> json) {
    expiredTime = json['expiredTime'];
    token = json['token'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expiredTime'] = this.expiredTime;
    data['token'] = this.token;
    data['uid'] = this.uid;
    return data;
  }
}

class Token {
  String? accessToken;
  int? expiredTime;

  Token({this.accessToken, this.expiredTime});

  Token.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    expiredTime = json['expiredTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['expiredTime'] = this.expiredTime;
    return data;
  }
}
