import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nav_router/nav_router.dart';
import 'package:yunda/constant.dart';
import 'package:yunda/testBank/unified_answer.dart';
import 'package:yunda/testBank/unified_result.dart';
import 'package:yunda/utils/color_util.dart';
import 'package:yunda/utils/http.dart';
import 'package:yunda/utils/not_data.dart';
import 'package:yunda/utils/time_utils.dart';
import 'package:yunda/utils/utils.dart';

import 'answer.dart';

class UnifiedExamPage extends StatefulWidget {
  @override
  _UnifiedExamPageState createState() => _UnifiedExamPageState();
}

class _UnifiedExamPageState extends State<UnifiedExamPage> {
  List<Map> unifiedExamList = [];
  bool noData = true;
  EasyRefreshController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = EasyRefreshController();
    Utils.showLoading();
    _getListData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
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
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(CupertinoIcons.back),
            ),
            title: Text("统一测试"),
            centerTitle: true,
          ),
        ),
        preferredSize: Size.fromHeight(44),
      ),
      body: EasyRefresh.custom(
        emptyWidget: NotData.notData(noData, text: "暂无测试"),
        enableControlFinishRefresh: false,
        enableControlFinishLoad: true,
        controller: _controller,
        header: DeliveryHeader(),
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= unifiedExamList.length) {
                  return Container(
                    height: ScreenUtil.bottomBarHeight + 30,
                  );
                }
                return GestureDetector(
                  onTap: () async {
                    Utils.showLoading();
                    await HttpUtils.httpPost(unifiedExamUrl, {
                      "unifiedId": unifiedExamList[index]["id"],
                    }, (res) {
                      if (res["code"].toString() == "1") {
                        routePush(
                          UnifiedAnswerPage(
                            unifiedId: unifiedExamList[index]["id"],
                            unifiedStr: jsonEncode(res),
                          ),
                          RouterType.cupertino,
                        );
                      } else if (res["code"].toString() == "2") {
                        print(res);
                        routePush(
                            UnifiedResultPage(
                              totalNum: res["unifiedPaper"]["totalNum"].toString(),
                              totalScore: res["unifiedPaper"]["totalScore"].toString(),
                              examScore: res["unifiedResult"]["examScore"].toString(),
                            ),
                            RouterType.fade);
                      }
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: index == 0 ? 10 : 0, bottom: 15, left: 15, right: 15),
                    height: ScreenUtil().setWidth(100),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: ColorsUtil.gradientRandom(),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 0.0), //阴影在X轴和Y轴上的偏移
                          color: ColorsUtil.hexColor("#696969"), //阴影颜色
                          blurRadius: 20.0, //阴影程度
                          spreadRadius: -9.0, //阴影扩散的程度 取值可以正数,也可以是负数
                        ),
                      ],
                    ),
                    child: Flex(
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Text(
                            unifiedExamList[index]["name"],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(32),
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            unifiedExamList[index]["examBeginTime"],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(22),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: unifiedExamList.length + 1,
            ),
          ),
        ],
        onRefresh: () async {
          await _getListData();
          _controller.resetLoadState();
        },
      ),
    );
  }

  _getListData() async {
    await HttpUtils.httpPost(classExamUrl, {}, (res) {
      if (res["code"].toString() == "1") {
        unifiedExamList.clear();
        res["unifiedList"].forEach((res) {
          unifiedExamList.add({
            "id": res["id"].toString(),
            "name": res["title"].toString(),
            "examBeginTime": TimeUtils.millisecond2DateTime(res["examBeginTime"].toString()),
          });
        });
      }
    });
    if (unifiedExamList.length <= 0) {
      noData = true;
    } else {
      noData = false;
    }
    setState(() {});
  }
}
