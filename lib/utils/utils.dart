import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yunda/constant.dart';

class Utils {
  // md5 加密
  static String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  // map转url参数
  static String mapToUrlString(Map params) {
    var paramsStr = "";
    var paramsList = params.keys.toList();
    paramsList.sort();
    var paramsMap = new Map();
    paramsList.forEach((v) {
      paramsMap[v] = params[v];
    });
    paramsMap.forEach((k, v) {
      paramsStr += k + "=" + v + "&";
    });
    paramsStr = paramsStr.substring(0, paramsStr.length - 1);
    return paramsStr;
  }

  // yl005加密
  static String getAuth(Map params, bool isExam) {
    var paramsStr = mapToUrlString(params);
    if (isExam) {
      return generateMd5(paramsStr + authBDQN);
    } else {
      return generateMd5(paramsStr + authKGC);
    }
  }

  // 存储数据
  static setData(key, val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (val is bool) {
      prefs.setBool(key, val);
    } else if (val is String) {
      prefs.setString(key, val);
    }
  }

  // 读取数据
  static Future getData(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  // 清除数据
  static clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static showLoading() {
    BotToast.showCustomLoading(
        toastBuilder: (CancelFunc cancelFunc) {
          return SpinKitChasingDots(
            color: Colors.white,
          );
        },
        duration: Duration(seconds: 15));
  }

  static formatNum(String num, int postion) {
    if (!num.contains(".") || num.split(".")[1].length <= postion) {
      return num;
    }
    if (postion <= 0) {
      return num.split(".")[0];
    }
    return num.substring(0, num.lastIndexOf(".") + postion + 1).toString();
  }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return version;
  }

  static Future<String> getAppBuild() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String build = packageInfo.buildNumber;
    return build;
  }

  static String numToAnswer(String num) {
    if (num == null || num == "") {
      return "";
    }
    String answer = "";
    answer = num.replaceAll("0", "A");
    answer = answer.replaceAll("1", "B");
    answer = answer.replaceAll("2", "C");
    answer = answer.replaceAll("3", "D");
    answer = answer.replaceAll("4", "E");
    return answer;
  }

  static String answerToNum(String answer) {
    if (answer == null || answer == "") {
      return "";
    }
    String num = "";
    num = answer.replaceAll("A", "0");
    num = num.replaceAll("B", "1");
    num = num.replaceAll("C", "2");
    num = num.replaceAll("D", "3");
    num = num.replaceAll("E", "4");
    return num;
  }
}
