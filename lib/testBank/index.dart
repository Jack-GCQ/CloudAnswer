import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nav_router/nav_router.dart';
import 'package:yunda/login.dart';
import 'package:yunda/testBank/my_info.dart';
import 'package:yunda/testBank/notice.dart';
import 'package:yunda/testBank/special_skills.dart';
import 'package:yunda/testBank/unified_exam.dart';
import 'package:yunda/utils/alert_dialog.dart';
import 'package:yunda/utils/color_util.dart';
import 'package:yunda/utils/utils.dart';

import 'answer.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with TickerProviderStateMixin {
  AnimationController _animationController1;
  AnimationController _animationController2;
  AnimationController _animationController3;
  AnimationController _animationController4;
  AnimationController _animationController5;
  AnimationController _animationController6;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController1 = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _animationController2 = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _animationController3 = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _animationController4 = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _animationController5 = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _animationController6 = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController1.dispose();
    _animationController2.dispose();
    _animationController3.dispose();
    _animationController4.dispose();
    _animationController5.dispose();
    _animationController6.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          decoration: BoxDecoration(
            gradient: ColorsUtil.left2right(),
          ),
          child: AppBar(
            leading: SizedBox(),
            title: Text("题库"),
            centerTitle: true,
          ),
        ),
        preferredSize: Size.fromHeight(44),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Container(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                routePush(SpecialSkillsPage(), RouterType.cupertino);
              },
              onPanDown: (details) {
                _animationController1.forward();
              },
              onPanEnd: (details) {
                _animationController1.reverse();
              },
              onPanCancel: () {
                _animationController1.reverse();
              },
              child: ScaleTransition(
                scale: Tween<double>(begin: 1, end: 0.98).animate(_animationController1),
                child: Container(
                  height: ScreenUtil().setWidth(200),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(colors: [
                      ColorsUtil.hexColor("#94C2FF"),
                      ColorsUtil.hexColor("#8F83FD"),
                    ]),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 0.0), //阴影在X轴和Y轴上的偏移
                        color: ColorsUtil.hexColor("#696969"), //阴影颜色
                        blurRadius: 20.0, //阴影程度
                        spreadRadius: -9.0, //阴影扩散的程度 取值可以正数,也可以是负数
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "专项技能型",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(35),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                await Utils.getData("outlineCode").then((val) {
                  if (val != null) {
                    routePush(
                      AnswerPage(
                        code: val,
                        examType: "moni",
                      ),
                      RouterType.cupertino,
                    );
                  }
                });
              },
              onPanDown: (details) {
                _animationController2.forward();
              },
              onPanEnd: (details) {
                _animationController2.reverse();
              },
              onPanCancel: () {
                _animationController2.reverse();
              },
              child: ScaleTransition(
                scale: Tween<double>(begin: 1, end: 0.98).animate(_animationController2),
                child: Container(
                  height: ScreenUtil().setWidth(200),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(colors: [
                      ColorsUtil.hexColor("#5B96FC"),
                      ColorsUtil.hexColor("#5BCAFF"),
                    ]),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 0.0), //阴影在X轴和Y轴上的偏移
                        color: ColorsUtil.hexColor("#696969"), //阴影颜色
                        blurRadius: 20.0, //阴影程度
                        spreadRadius: -9.0, //阴影扩散的程度 取值可以正数,也可以是负数
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "模拟真题型",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(35),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                routePush(UnifiedExamPage(), RouterType.cupertino);
              },
              onPanDown: (details) {
                _animationController3.forward();
              },
              onPanEnd: (details) {
                _animationController3.reverse();
              },
              onPanCancel: () {
                _animationController3.reverse();
              },
              child: ScaleTransition(
                scale: Tween<double>(begin: 1, end: 0.98).animate(_animationController3),
                child: Container(
                  height: ScreenUtil().setWidth(200),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(colors: [
                      ColorsUtil.hexColor("#43DAB4"),
                      ColorsUtil.hexColor("#47E4D8"),
                    ]),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 0.0), //阴影在X轴和Y轴上的偏移
                        color: ColorsUtil.hexColor("#696969"), //阴影颜色
                        blurRadius: 20.0, //阴影程度
                        spreadRadius: -9.0, //阴影扩散的程度 取值可以正数,也可以是负数
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "统一测试",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(35),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 20,
            ),
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      routePush(MyInfoPage(), RouterType.cupertino);
                    },
                    onPanDown: (details) {
                      _animationController4.forward();
                    },
                    onPanEnd: (details) {
                      _animationController4.reverse();
                    },
                    onPanCancel: () {
                      _animationController4.reverse();
                    },
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 1, end: 0.98).animate(_animationController4),
                      child: Container(
                        height: ScreenUtil().setWidth(200),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gradient: LinearGradient(colors: [
                            ColorsUtil.hexColor("#84FAB0"),
                            ColorsUtil.hexColor("#8FD3F4"),
                          ]),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 0.0), //阴影在X轴和Y轴上的偏移
                              color: ColorsUtil.hexColor("#696969"), //阴影颜色
                              blurRadius: 20.0, //阴影程度
                              spreadRadius: -9.0, //阴影扩散的程度 取值可以正数,也可以是负数
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "我的信息",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(35),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 20,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      routePush(NoticePage());
                    },
                    onPanDown: (details) {
                      _animationController5.forward();
                    },
                    onPanEnd: (details) {
                      _animationController5.reverse();
                    },
                    onPanCancel: () {
                      _animationController5.reverse();
                    },
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 1, end: 0.98).animate(_animationController5),
                      child: Container(
                        height: ScreenUtil().setWidth(200),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gradient: LinearGradient(colors: [
                            ColorsUtil.hexColor("#FDA3A4"),
                            ColorsUtil.hexColor("#FCC5C0"),
                          ]),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 0.0), //阴影在X轴和Y轴上的偏移
                              color: ColorsUtil.hexColor("#696969"), //阴影颜色
                              blurRadius: 20.0, //阴影程度
                              spreadRadius: -9.0, //阴影扩散的程度 取值可以正数,也可以是负数
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "通知",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(35),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                AlertDialogUtil.showAlertDialog(context, "是否确定退出？", [
                  "确定",
                  "取消"
                ], [
                  () async {
                    Navigator.pop(context);
                    String account = "";
                    await Utils.getData("account").then((val) {
                      if (val != null) {
                        account = val.toString();
                      }
                    });
                    await Utils.clearData();
                    await Utils.setData("account", account);
                    Navigator.of(context).pushAndRemoveUntil(
                      new MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => route == null,
                    );
                  },
                  () {
                    Navigator.pop(context);
                  },
                ]);
              },
              onPanDown: (details) {
                _animationController6.forward();
              },
              onPanEnd: (details) {
                _animationController6.reverse();
              },
              onPanCancel: () {
                _animationController6.reverse();
              },
              child: ScaleTransition(
                scale: Tween<double>(begin: 1, end: 0.98).animate(_animationController6),
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(colors: [
                      ColorsUtil.hexColor("#FF5E8A"),
                      ColorsUtil.hexColor("#FF70D1"),
                    ]),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 0.0), //阴影在X轴和Y轴上的偏移
                        color: ColorsUtil.hexColor("#696969"), //阴影颜色
                        blurRadius: 20.0, //阴影程度
                        spreadRadius: -9.0, //阴影扩散的程度 取值可以正数,也可以是负数
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "退出登录",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(35),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
