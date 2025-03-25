import 'dart:io';
import 'package:flutter/material.dart';
import 'package:voco/models/softpos_rates.dart';
import '../models/merchant.dart';
import '../models/payment_transaction.dart';
import '../models/terminal.dart';
import '../models/user.dart';

class Session {
  Session._privateConstructor();

  static final Session instance = Session._privateConstructor();

  Locale? locale;
  String? token;
  DateTime? tokenExpiration;
  User? loggedInUser;
  Merchant? merchant;
  double merchantTodayTotal = 0.0;
  Terminal? terminal;
  double terminalTodayTotal = 0.0;
  List<PaymentTransaction> transactions = [];
  File? selectedFile;
  String? changePhone;
  double latitude = 0.0;
  double longitude = 0.0;
  String? paymenSessionToken;
  SoftposRates? softposRates;

  bool checkInternet = true;
  bool isTestEnv = false;

  void clear() {
    locale = null;
    token = null;
    loggedInUser = null;
    token = null;
    changePhone = null;
    merchant = null;
    terminal = null;
    transactions = [];
    selectedFile = null;
    merchantTodayTotal = 0.0;
    terminalTodayTotal = 0.0;
  }

  void clearTempLoginInfo() {
    changePhone = null;
  }

  // Method to set softposRates
  void setSoftposRates(Map<String, dynamic> json) {
    softposRates = SoftposRates.fromJson(json['data']);
  }
}
