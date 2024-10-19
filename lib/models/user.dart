import 'package:flutter/material.dart';

import '../utils/map_util.dart';
import '../utils/validators.dart';

class User {
  int userId = 0;
  String? userName;
  String? email;
  String? gsmNumber;
  String? firstName;
  String? lastName;
  int hostUserId = 0;
  int userType = 0;
  int userStatus = 0;
  int merchantId = 0;
  bool isActive = false;
  int? channel;
  int? contractVersion;
  int? kvkkVersion;
  int? districtId;
  int? cityId;
  int? passwordRetryCont;
  int userRole = 0;

  User();

  getUserInfo() {
    return '${firstName ?? '-'} ${lastName ?? '.'}';
  }

  getFullName() {
    String fullName = '';

    if (Validators.isNotEmptyOrNull(firstName)) {
      fullName = fullName + firstName!.characters.first.toUpperCase() + firstName!.substring(1, firstName!.length);
    }

    if (Validators.isNotEmptyOrNull(lastName)) {
      fullName = '$fullName ${lastName!.characters.first.toUpperCase()}${lastName!.substring(1, lastName!.length)}';
    }

    return fullName;
  }

  User.fromJson(Map<String, dynamic> json) {
    userId = MapUtil.getInt(json, 'userId');
    firstName = MapUtil.getString(json, 'firstName');
    lastName = MapUtil.getString(json, 'lastName');
    userName = MapUtil.getString(json, 'userName');
    email = MapUtil.getString(json, 'email');
    gsmNumber = MapUtil.getString(json, 'gsmNumber');
    userType = MapUtil.getInt(json, 'userType');
    userStatus = MapUtil.getInt(json, 'userStatus');
    merchantId = MapUtil.getInt(json, 'merchantId');
    isActive = MapUtil.getBool(json, 'isActive');
    channel = MapUtil.getInt(json, 'channel');
    contractVersion = MapUtil.getInt(json, 'contractVersion');
    kvkkVersion = MapUtil.getInt(json, 'kvkkVersion');
    districtId = MapUtil.getInt(json, 'districtId');
    cityId = MapUtil.getInt(json, 'cityId');
    passwordRetryCont = MapUtil.getInt(json, 'passwordRetryCont');
    hostUserId = MapUtil.getInt(json, 'hostUserId');
    userRole = MapUtil.getInt(json, 'userRole');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    return data;
  }
}

/*

{
  userId: 65, 
  firstName: bulent, 
  lastName: mutlu, 
  email: bulent.mutlu@gmail.com, 
  gsmNumber: 5327998979, 
  userName: bulentmutlu40696170, 
  hostUserId: null, 
  userType: 1, 
  userStatus: 1, 
  isActive: true, 
  createBy: 1, 
  createDate: 2023-03-27T15:49:29.007, 
  updateBy: 65, 
  updateDate: 2023-04-13T03:13:55.18, 
  merchantId: 7, 
  channel: 1, 
  contractVersion: 1, 
  kvkkVersion: 1, 
  districtId: 1, 
  cityId: null, 
  passwordRetryCont: 0,
  userRole: 1
}
*/
