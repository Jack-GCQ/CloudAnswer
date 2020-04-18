import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:yunda/utils/color_util.dart';
import 'package:yunda/utils/http.dart';
import 'package:yunda/utils/not_data.dart';
import 'package:yunda/utils/time_utils.dart';
import 'package:yunda/utils/utils.dart';

import '../constant.dart';

class MyInfoPage extends StatefulWidget {
  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  String userName = "";
  EasyRefreshController _controller;
  bool noData = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = EasyRefreshController();
    Utils.getData("userName").then((val) {
      if (val != null) {
        userName = val;
        setState(() {});
      }
    });
    Utils.showLoading();
    _getResult();
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
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: ScreenUtil().setWidth(300),
                  child: Image.asset(
                    "assets/images/user_background.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil.statusBarHeight + 50, left: 15, right: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 0.0), //阴影在X轴和Y轴上的偏移
                        color: ColorsUtil.hexColor("#696969"), //阴影颜色
                        blurRadius: 20.0, //阴影程度
                        spreadRadius: -9.0, //阴影扩散的程度 取值可以正数,也可以是负数
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Container(
                        child: Text(
                          userName,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.lightGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Flex(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  resultData["dayAllCount"],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  resultData["dayActualCount"],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  resultData["correctRate"] + "%",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Flex(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "今日累计答题",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "今日实际答题",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "今日正确率",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                PreferredSize(
                  child: Container(
                    child: AppBar(
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(CupertinoIcons.back),
                      ),
                      title: Text("我的信息"),
                      centerTitle: true,
                    ),
                  ),
                  preferredSize: Size.fromHeight(44),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 20),
              child: EasyRefresh.custom(
                emptyWidget: NotData.notData(noData),
                enableControlFinishRefresh: false,
                enableControlFinishLoad: true,
                controller: _controller,
                header: ClassicalHeader(
                  refreshText: "下拉刷新",
                  refreshReadyText: "释放刷新",
                  refreshingText: "正在加载...",
                  refreshedText: "刷新完成",
                  refreshFailedText: "刷新失败",
                  infoText: "更新于 %T",
                ),
                footer: ClassicalFooter(
                  loadText: "上拉加载",
                  loadReadyText: "释放加载",
                  loadingText: "正在加载...",
                  loadedText: "加载完成",
                  loadFailedText: "加载失败",
                  noMoreText: "到底了～",
                  infoText: "更新于 %T",
                ),
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= _listData.length) {
                          return Container(
                            height: ScreenUtil.bottomBarHeight + 20,
                          );
                        }
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 1.0), //阴影在X轴和Y轴上的偏移
                                color: ColorsUtil.hexColor("#696969"), //阴影颜色
                                blurRadius: 10.0, //阴影程度
                                spreadRadius: -10.0, //阴影扩散的程度 取值可以正数,也可以是负数
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _listData[index]["title"],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "答题时间：${_listData[index]["examSubmitTime"]}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "答题用时：${_listData[index]["useTime"]}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: _listData.length + 1,
                    ),
                  ),
                ],
                onRefresh: () async {
                  setState(() {
                    page = 1;
                  });
                  await _getListData(false);
                  _controller.resetLoadState();
                },
                onLoad: () async {
                  setState(() {
                    page++;
                  });
                  await _getListData(true);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map resultData = {
    "dayAllCount": "0",
    "dayCorrectCount": "0",
    "dayActualCount": "0",
    "correctRate": "100",
  };

  _getResult() async {
    String productId = "";
    await Utils.getData("productId").then((val) {
      if (val != null) {
        productId = val;
      }
    });
    HttpUtils.httpPost(getLas4WeekAnswerCountUrl, {
      "productId": productId,
    }, (res) {
      _getListData(false);
      if (res["code"].toString() == "1") {
        int dayAllCount = int.parse(res["dayAllCount"].toString());
        int dayCorrectCount = int.parse(res["dayCorrectCount"].toString());
        int dayActualCount = int.parse(res["dayActualCount"].toString());
        dayAllCount = dayAllCount.isNaN ? 0 : dayAllCount;
        dayCorrectCount = dayCorrectCount.isNaN ? 0 : dayCorrectCount;
        dayActualCount = dayActualCount.isNaN ? 0 : dayActualCount;
        double correctRate = (dayCorrectCount / dayAllCount * 100);
        correctRate = correctRate.isNaN ? 100 : correctRate;
        setState(() {
          resultData["dayAllCount"] = dayAllCount.toString();
          resultData["dayActualCount"] = dayActualCount.toString();
          resultData["dayCorrectCount"] = dayCorrectCount.toString();
          resultData["correctRate"] = Utils.formatNum(correctRate.toString(), 0);
        });
      }
    }, isCloseLoading: false);
  }

  int page = 1;
  List<Map> _listData = [];

  _getListData(bool load) async {
    HttpUtils.httpPost(historyUrl, {
      "size": "10",
      "page": page.toString(),
    }, (res) {
      if (res["code"].toString() == "1") {
        if (!load) {
          _listData.clear();
        }
        res["paperList"].forEach((res) {
          _listData.add({
            "title": res["title"].toString(),
            "examType": res["examType"].toString(),
            "useTime": res["useTime"].toString(),
            "examSubmitTime": TimeUtils.millisecond2DateTime(res["examSubmitTime"].toString()),
          });
        });
      }
      if (load) {
        if (res["paperList"].length > 0) {
          _controller.finishLoad();
        } else {
          _controller.finishLoad(noMore: true);
        }
      }
      if (_listData.length <= 0) {
        noData = true;
      } else {
        noData = false;
      }
      setState(() {});
    });
  }
}
