
import 'package:azlistview/azlistview.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';


class ContactInfo extends ISuspensionBean {
  String? tagIndex;
  String? namePinyin;
  String? iconAssetPath;

  ///////////////
  String uid;
  String? name;
  String? icon;
  int? gender; // 0 未知，1 男，2 女
  String? mobile;
  String? birth;
  String? email;
  String? ex;
  String? comment;
  int? isInBlackList; // 0 不在黑名单，1 在黑名单
  String? reqMessage;
  String? applyTime;
  int? flag;
  bool? isChecked;

  ContactInfo({
    this.tagIndex,
    this.iconAssetPath,
    required this.uid,
    this.name,
    this.icon,
    this.gender,
    this.mobile,
    this.birth,
    this.email,
    this.ex,
    this.comment,
    this.isInBlackList,
    this.reqMessage,
    this.applyTime,
    this.flag,
    this.isChecked,
  });

  ContactInfo.fromJson(Map<String, dynamic> json) : uid = json['uid'] {
    tagIndex = json['tagIndex'];
    namePinyin = json['namePinyin'];
    isShowSuspension = json['isShowSuspension'];
    iconAssetPath = json['iconAssetPath'];
    /////////
    name = json['name'] ?? json[uid];
    icon = json['icon'];
    gender = json['gender'];
    mobile = json['mobile'];
    birth = json['birth'];
    email = json['email'];
    ex = json['ex'];
    comment = json['comment'];
    isInBlackList = json['isInBlackList'];
    reqMessage = json['reqMessage'];
    applyTime = json['applyTime'];
    flag = json['flag'];
    isChecked = json['isChecked'];
  }

  ContactInfo.fromUserInfo(UserInfo info) : uid = info.uid {
    name = info.name ?? info.uid;
    icon = info.icon;
    gender = info.gender;
    mobile = info.mobile;
    birth = info.birth;
    email = info.email;
    ex = info.ex;
    if (info.comment == "") {
      comment = null;
    } else {
      comment = info.comment;
    }
    isInBlackList = info.isInBlackList;
    reqMessage = info.reqMessage;
    applyTime = info.applyTime;
    flag = info.flag;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['tagIndex'] = this.tagIndex;
    map['namePinyin'] = this.namePinyin;
    map['iconAssetPath'] = this.iconAssetPath;
    map['isShowSuspension'] = this.isShowSuspension;

    //////
    map['uid'] = this.uid;
    map['name'] = this.name;
    map['icon'] = this.icon;
    map['gender'] = this.gender;
    map['mobile'] = this.mobile;
    map['birth'] = this.birth;
    map['email'] = this.email;
    map['ex'] = this.ex;
    map['comment'] = this.comment;
    map['isInBlackList'] = this.isInBlackList;
    map['reqMessage'] = this.reqMessage;
    map['applyTime'] = this.applyTime;
    map['flag'] = this.flag;
    map['isChecked'] = this.isChecked;
    return map;
  }

  @override
  String getSuspensionTag() => tagIndex!;

// @override
// String toString() => json.encode(this);

  String get nickname => _getNickname();

  String _getNickname() {
    if (null != comment && "" != comment!.trim()) {
      return comment!;
    } else if (null != name && "" != name!.trim()) {
      return name!;
    } else {
      return uid;
    }
  }
}
