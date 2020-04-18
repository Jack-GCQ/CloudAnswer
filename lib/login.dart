import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nav_router/nav_router.dart';
import 'package:yunda/constant.dart';
import 'package:yunda/testBank/index.dart';
import 'package:yunda/utils/http.dart';
import 'package:yunda/utils/utils.dart';

import 'utils/color_util.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _userNameController;
  TextEditingController _passwordController;
  String version = "";
  String buildNumber = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
//    Utils.clearData();
    Utils.getData("account").then((val) {
      if (val != null) {
        _userNameController.text = val.toString();
      }
    });
    Utils.getAppVersion().then((val) {
      setState(() {
        version = val.toString();
      });
    });
    Utils.getAppBuild().then((val) {
      setState(() {
        buildNumber = val.toString();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
        ),
        body: Container(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: SingleChildScrollView(
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 50, 0, 50),
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 100,
                  ),
                ),
                Container(
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: TextField(
                          controller: _userNameController,
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "账号",
                            hintStyle: TextStyle(color: ColorsUtil.hexColor("#868E96")),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black38,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorsUtil.hexColor("#EAEAEA")),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorsUtil.hexColor("#EAEAEA")),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: TextField(
                          controller: _passwordController,
                          style: TextStyle(color: Colors.black),
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "密码",
                            hintStyle: TextStyle(color: ColorsUtil.hexColor("#868E96")),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black38,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorsUtil.hexColor("#EAEAEA")),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: ColorsUtil.hexColor("#EAEAEA")),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: CupertinoButton(
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              String username = _userNameController.text;
                              String password = _passwordController.text;
                              if (username == "") {
                                BotToast.showText(text: "账号不能为空");
                                return;
                              } else if (password == "") {
                                BotToast.showText(text: "密码不能为空");
                                return;
                              }
                              Utils.showLoading();
                              String productId = "";
                              String userName = "";
                              String outlineId = "";
                              HttpUtils.httpPostLogin({
                                "clientType": "008",
                                "passport": username,
                                "password": Utils.generateMd5(password),
                              }, (res) {
                                if (res["code"].toString() == "1") {
                                  res["productList"].forEach((res) {
                                    if (res["isLastLoginProduct"].toString() == "true") {
                                      productId = res["productId"].toString();
                                    }
                                  });
                                  userName = res["userName"].toString();
                                  var params = {"passport": username, "password": Utils.generateMd5(password)};
                                  HttpUtils.httpPost(loginUrl, params, (res) async {
                                    if (res["code"].toString() == "1") {
                                      await Utils.setData("token", res["token"].toString());
                                      await Utils.setData("userId", res["userId"].toString());
                                      HttpUtils.httpPost(indexUrl, {
                                        "productId": productId,
                                      }, (res) async {
                                        if (res["code"].toString() == "1") {
                                          outlineId = res["outline"]["id"].toString();
                                          await Utils.setData("isLogin", true);
                                          await Utils.setData("productId", productId);
                                          await Utils.setData("account", username);
                                          await Utils.setData("userName", userName);
                                          await Utils.setData("outlineId", outlineId);
                                          await Utils.setData("outlineCode", res["outline"]["code"].toString());
                                          routePush(IndexPage(), RouterType.fade);
                                        }
                                      });
                                    }
                                  }, isCloseLoading: false);
                                }
                              });
                            },
                            color: Colors.blue,
                            pressedOpacity: 0.8,
                            child: Container(
                              child: Text(
                                "登录",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Center(
                          child: Text(
                            "Version: $version ($buildNumber)",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
