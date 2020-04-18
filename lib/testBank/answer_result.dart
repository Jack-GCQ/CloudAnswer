import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yunda/testBank/index.dart';
import 'package:yunda/utils/color_util.dart';
import 'package:yunda/utils/http.dart';
import 'package:yunda/utils/utils.dart';

import '../constant.dart';

class AnswerResultPage extends StatefulWidget {
  final String examResultId;
  final String paperId;
  final String timeStr;

  const AnswerResultPage({Key key, this.examResultId, this.paperId, this.timeStr}) : super(key: key);

  @override
  _AnswerResultPageState createState() => _AnswerResultPageState();
}

class _AnswerResultPageState extends State<AnswerResultPage> {
  String hitokoto = "";

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
        body: Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Container(
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Image.asset(
                  "assets/images/result_background.png",
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
                        "${resultData["correctRate"].toString()}%",
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "本次正确率",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
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
                                widget.timeStr.toString(),
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
                                resultData["errorCount"],
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
                                resultData["totalCount"],
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
                                "练习时间",
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
                                "错题数",
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
                                "总题数",
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
                child: AppBar(
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          new MaterialPageRoute(builder: (context) => IndexPage()), (route) => route == null);
                    },
                    child: Icon(CupertinoIcons.back),
                  ),
                  title: Text("答题结果"),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                ),
                preferredSize: Size.fromHeight(44),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 30),
          child: Text(hitokoto),
        ),
      ],
    ));
  }

  Map<String, String> resultData = {
    "correctCount": "0",
    "totalCount": "0",
    "correctRate": "0",
    "errorCount": "0",
  };

  _getResult() {
    HttpUtils.httpGetApi(hitokotoUrl, null, (res) {
      setState(() {
        hitokoto = res["hitokoto"];
      });
    });
    HttpUtils.httpPost(reportUrl, {
      "examResultId": widget.examResultId,
      "paperId": widget.paperId,
    }, (res) {
      if (res["code"].toString() == "1") {
        int correctCount = int.parse(res["examReport"]["correctCount"].toString());
        int totalCount = int.parse(res["examReport"]["totalCount"].toString());
        correctCount = correctCount.isNaN ? 0 : correctCount;
        totalCount = totalCount.isNaN ? 0 : totalCount;
        setState(() {
          resultData["correctCount"] = correctCount.toString();
          resultData["totalCount"] = totalCount.toString();
          resultData["errorCount"] = (totalCount - correctCount).toString();
          resultData["correctRate"] = Utils.formatNum((correctCount / totalCount * 100).toString(), 0);
        });
      }
    });
  }
}
