import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nav_router/nav_router.dart';
import 'package:yunda/testBank/index.dart';
import 'package:yunda/login.dart';
import 'package:yunda/utils/utils.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);

    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Utils.clearData();
            Utils.getData("isLogin").then((val) {
              if (val != null && val) {
                routePush(IndexPage(), RouterType.fade);
              } else {
                routePush(LoginPage(), RouterType.fade);
              }
            });
          },
          color: Colors.cyan,
          child: Container(
            child: Text(
              "登录",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
