import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/taurus_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nav_router/nav_router.dart';
import 'package:yunda/testBank/answer.dart';
import 'package:yunda/utils/color_util.dart';
import 'package:yunda/utils/http.dart';
import 'package:yunda/utils/not_data.dart';
import 'package:yunda/utils/utils.dart';
import 'package:yunda/widget/tap_color.dart';

import '../constant.dart';

class SpecialSkillsPage extends StatefulWidget {
  @override
  _SpecialSkillsPageState createState() => _SpecialSkillsPageState();
}

class _SpecialSkillsPageState extends State<SpecialSkillsPage> {
  var _skillList = [];
  EasyRefreshController _controller;
  bool noData = true;
  bool isOnTapDown = false;
  String outlineId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = EasyRefreshController();
    Utils.showLoading();
    Utils.getData("outlineId").then((val) {
      setState(() {
        outlineId = val.toString();
      });
      _getListData();
    });
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
            title: Text("专项技能型"),
            centerTitle: true,
          ),
        ),
        preferredSize: Size.fromHeight(44),
      ),
      body: EasyRefresh.custom(
        emptyWidget: NotData.notData(noData),
        enableControlFinishRefresh: false,
        enableControlFinishLoad: true,
        controller: _controller,
        header: DeliveryHeader(),
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= _skillList.length) {
                  return Container(
                    height: ScreenUtil.bottomBarHeight + 30,
                  );
                }
                return Container(
                  child: Column(
                    children: <Widget>[
                      TapColor(
                        activeColor: ColorsUtil.hexColor("#EBEBEB"),
                        unActiveColor: Colors.white,
                        onTap: () {
                          routePush(
                              AnswerPage(
                                code: _skillList[index]["code"],
                                examType: "jinengAuto",
                              ),
                              RouterType.cupertino);
                        },
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              height: 45,
                              alignment: Alignment.centerLeft,
                              child:
                                  Text("${_skillList[index]["name"].toString()} (${_skillList[index]["percentage"]})"),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 15),
                              padding: EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                gradient: ColorsUtil.bottom2top(),
                              ),
                              child: Text(
                                "开始测试",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: ColorsUtil.hexColor("#EBEBEB"),
                        margin: EdgeInsets.only(left: 15, right: 15),
                      ),
                    ],
                  ),
                );
              },
              childCount: _skillList.length + 1,
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
    await HttpUtils.httpPost(chapterListUrl, {
      "outlineId": outlineId,
    }, (res) {
      if (res["code"].toString() == "1") {
        _skillList.clear();
        res["courseList"].forEach((res) {
          res["chapterList"].forEach((res) {
            double answer = double.parse(res["answer"].toString());
            double total = double.parse(res["total"].toString());
            answer = answer.isNaN ? 0 : answer;
            total = total.isNaN ? 0 : total;
            double percentage = ((answer / total) * 100);
            String percentageStr = percentage >= 100 ? "100" : percentage.toStringAsFixed(2);
            _skillList.add({
              "code": res["code"].toString(),
              "name": res["name"].toString(),
              "percentage": percentageStr + "%",
            });
          });
        });
      }
    });
    if (_skillList.length <= 0) {
      noData = true;
    } else {
      noData = false;
    }
    setState(() {});
  }
}
