import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nav_router/nav_router.dart';
import 'package:yunda/constant.dart';
import 'package:yunda/testBank/notice_details.dart';
import 'package:yunda/utils/color_util.dart';
import 'package:yunda/utils/http.dart';
import 'package:yunda/utils/not_data.dart';
import 'package:yunda/utils/time_utils.dart';
import 'package:yunda/utils/utils.dart';

class NoticePage extends StatefulWidget {
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Utils.showLoading();
    _getResult();
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
            title: Text("通知消息"),
            centerTitle: true,
          ),
        ),
        preferredSize: Size.fromHeight(44),
      ),
      body: _listData.length <= 0
          ? NotData.notData(true)
          : ListView.builder(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 10),
              itemCount: _listData.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    routePush(NoticeDetailsPage(
                      notice: _listData[index]["content"].toString(),
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 3.0), //阴影在X轴和Y轴上的偏移
                          color: ColorsUtil.hexColor("#696969"), //阴影颜色
                          blurRadius: 13.0, //阴影程度
                          spreadRadius: -9.0, //阴影扩散的程度 取值可以正数,也可以是负数
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 20),
                    child: Flex(
                      direction: Axis.vertical,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                _listData[index]["title"].toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Container(
                              child: Text(
                                TimeUtils.millisecond2DateTime(_listData[index]["time"].toString()),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _listData[index]["desc"].toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  List<Map> _listData = [];

  _getResult() async {
    await HttpUtils.httpGetApi(noticeUrl, null, (res) {
      if (res["code"].toString() == "200") {
        res["list"].forEach((res) {
          _listData.add(res);
        });
      }
      setState(() {});
    });
    BotToast.cleanAll();
  }
}
