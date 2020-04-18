import 'dart:async';
import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nav_router/nav_router.dart';
import 'package:yunda/testBank/answer_result.dart';
import 'package:yunda/testBank/unified_result.dart';
import 'package:yunda/utils/alert_dialog.dart';
import 'package:yunda/utils/color_util.dart';
import 'package:yunda/utils/http.dart';
import 'package:yunda/utils/utils.dart';
import 'package:yunda/widget/tap_color.dart';

import '../constant.dart';

class UnifiedAnswerPage extends StatefulWidget {
  final String unifiedId;
  final String unifiedStr;

  const UnifiedAnswerPage({Key key, this.unifiedId, this.unifiedStr}) : super(key: key);

  @override
  _UnifiedAnswerPageState createState() => _UnifiedAnswerPageState();
}

class _UnifiedAnswerPageState extends State<UnifiedAnswerPage> {
  PageController _controller;
  int currentPageNum = 1;
  List<Map<String, dynamic>> _listData = [];
  double answerNumRow = 6;
  double answerNumSpace = 20;
  double answerNumSpaceWidth = 0;
  double answerNumWidth = 0;
  String examResultId = "";
  bool showAnswer = false;
  Timer _timer;
  int minutes = 0;
  int seconds = 0;
  String timeStr = "00:00";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _answerExam();
    _controller = PageController(initialPage: 0);
    answerNumSpaceWidth = (answerNumRow - 1) * answerNumSpace;
    answerNumWidth = ScreenUtil.screenWidthDp - 30 - answerNumSpaceWidth;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _timer?.cancel();
    _timer = null;
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
            title: GestureDetector(
              onLongPress: () {
                setState(() {
                  showAnswer = !showAnswer;
                });
              },
              onDoubleTap: () {
                int index = 0;
                for (var value in _listData) {
                  _listData[index]["selected"]?.clear();
                  String answer = value["uAnswer"];
                  if (answer != "") {
                    if (answer.contains(",")) {
                      for (var value in answer.split(",")) {
                        _listData[index]["selected"]?.add(value);
                      }
                    } else {
                      _listData[index]["selected"]?.add(answer);
                    }
                  }
                  _listData[index]["selected"]?.sort();
                  index++;
                }
                setState(() {});
              },
              child: Text(showAnswer ? "不正经考试" : "正经考试"),
            ),
            centerTitle: true,
            actions: <Widget>[
              if (_answerDoneNum() >= 1)
                GestureDetector(
                  onTap: () {
                    int num = _listData.length - _answerDoneNum();
                    if (num <= 0) {
                      Utils.showLoading();
                      _submitPaper();
                      return;
                    }
                    AlertDialogUtil.showAlertDialog(context, "您还剩$num题未作答，是否确认交卷？", [
                      "提交试卷",
                      "继续答题"
                    ], [
                      () {
                        Navigator.pop(context);
                        Utils.showLoading();
                        _submitPaper();
                      },
                      () {
                        Navigator.pop(context);
                        showBottomCard();
                      },
                    ]);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 15),
                    child: Text("交卷"),
                  ),
                ),
            ],
          ),
        ),
        preferredSize: Size.fromHeight(44),
      ),
      backgroundColor: ColorsUtil.hexColor("#F5F5F5"),
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "已用时：$timeStr",
                      style: TextStyle(
                        color: ColorsUtil.linearColor2,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      _listData.length >= 1 ? _listData[currentPageNum - 1]["type"] == "1" ? "单选题" : "多选题" : "",
                      style: TextStyle(
                        color: ColorsUtil.linearColor2,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showBottomCard();
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            Icons.library_books,
                            color: Colors.black26,
                            size: 16,
                          ),
                          Container(
                            width: 5,
                          ),
                          RichText(
                            text: TextSpan(
                              text: currentPageNum.toString(),
                              style: TextStyle(
                                color: ColorsUtil.linearColor2,
                                fontSize: 13,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '/${_listData.length.toString()}',
                                  style: TextStyle(
                                    color: ColorsUtil.hexColor("#696969"),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 2,
            color: ColorsUtil.hexColor("#FAFAFA"),
          ),
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                currentPageNum = index + 1;
                setState(() {});
              },
              children: _genList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _genAnswer(String option, String title, int index, String type) {
    bool isSelected = false;
    String answerNum = Utils.answerToNum(option);
    if (_listData[index]["selected"].contains(answerNum)) {
      isSelected = true;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (type == "1") {
          _listData[index]["selected"].clear();
          _listData[index]["selected"]?.add(answerNum);
        } else {
          if (_listData[index]["selected"].contains(answerNum)) {
            _listData[index]["selected"]?.remove(answerNum);
          } else {
            _listData[index]["selected"]?.add(answerNum)?.toSet()?.toList();
          }
        }
        _listData[index]["selected"]?.sort();
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
        decoration: BoxDecoration(
          color: isSelected ? ColorsUtil.hexColor("#E2E2E2") : Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                border: Border.all(color: ColorsUtil.hexColor("#2C82F7")),
                color: isSelected ? ColorsUtil.hexColor("#2C82F7") : Colors.white,
              ),
              alignment: Alignment.center,
              width: 20,
              height: 20,
              child: Text(
                option,
                style: TextStyle(
                  color: isSelected ? Colors.white : ColorsUtil.hexColor("#2C82F7"),
                  fontSize: ScreenUtil().setSp(25),
                ),
              ),
            ),
            Expanded(
              child: Container(
                constraints: BoxConstraints(minHeight: 20),
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  title,
                  style: TextStyle(fontSize: ScreenUtil().setSp(25)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _genList() {
    int index = -1;
    return _listData.map((res) {
      index++;
      return ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15),
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    res["title"],
                    style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                  ),
                ),
                _genAnswer("A", res["choiceA"], index, res["type"]),
                _genAnswer("B", res["choiceB"], index, res["type"]),
                _genAnswer("C", res["choiceC"], index, res["type"]),
                _genAnswer("D", res["choiceD"], index, res["type"]),
                if (res["choiceE"] != "") _genAnswer("E", res["choiceE"], index, res["type"]),
              ],
            ),
          ),
          showAnswer
              ? Container(
                  margin: EdgeInsets.only(left: 15, top: 30, bottom: 50 + ScreenUtil.bottomBarHeight),
                  child: Text("本题答案：${Utils.numToAnswer(res["uAnswer"])}"),
                )
              : SizedBox(),
        ],
      );
    }).toList();
  }

  _answerExam() async {
    Utils.showLoading();
    var res = jsonDecode(widget.unifiedStr.toString());
    examResultId = res["examResultId"].toString();
    HttpUtils.httpPostApi(getAnswersUrl, {"json": res["cqList"].toString()}, (res) {
      res["data"].forEach((res) {
        String userAnswers = res["userAnswers"].toString();
        _listData.add({
          "selected": userAnswers.split(","),
          "type": res["type"].toString(),
          "answers": res["answers"].toString(),
          "uAnswer": res["uAnswer"].toString(),
          "id": res["id"].toString(),
          "psqId": res["psqId"].toString(),
          "title": res["title"].toString(),
          "choiceA": res["choiceA"].toString(),
          "choiceB": res["choiceB"].toString(),
          "choiceC": res["choiceC"].toString(),
          "choiceD": res["choiceD"].toString(),
          "choiceE": res["choiceE"].toString(),
          "questionIndex": res["questionIndex"].toString(),
        });
      });
      _timeStart();
      setState(() {});
    });
  }

  int _answerDoneNum() {
    int num = 0;
    for (var value in _listData) {
      if (value["selected"].join(",") != "") {
        num++;
      }
    }
    return num;
  }

  void showBottomCard() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 7, bottom: 7, left: 15, right: 15),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 0.7,
                        color: ColorsUtil.hexColor("#F4F5F6"),
                      ),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text("答题卡"),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        child: Text("共${_listData.length}题，已完成${_answerDoneNum()}题"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 30),
                    children: <Widget>[
                      Wrap(
                        spacing: answerNumSpace,
                        runSpacing: 15,
                        children: _listData.map((res) {
                          return GestureDetector(
                            onTap: () {
                              int page = int.parse(res["questionIndex"]);
                              page = page.isNaN ? 0 : page - 1;
                              _controller.jumpToPage(page);
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: answerNumWidth / 6,
                              height: answerNumWidth / 6,
                              decoration: BoxDecoration(
                                border: res["selected"].join(",") != ""
                                    ? Border.all(color: Colors.transparent)
                                    : Border.all(
                                        width: currentPageNum.toString() == res["questionIndex"] ? 1.0 : 0.5,
                                        color: ColorsUtil.hexColor(
                                            currentPageNum.toString() == res["questionIndex"] ? "#70BDEA" : "#959697"),
                                      ),
                                borderRadius: BorderRadius.all(Radius.circular(35)),
                                color: res["selected"].join(",") == ""
                                    ? Colors.transparent
                                    : ColorsUtil.hexColor("#E4EFF7"),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                res["questionIndex"],
                                style: TextStyle(
                                  color: ColorsUtil.hexColor(res["selected"].join(",") == "" ? "#959697" : "#70BDEA"),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  _submitPaper() {
    Map<String, Map<String, String>> answerMap = new Map();
    for (var value in _listData) {
      String questionId = value["id"];
      answerMap.putIfAbsent(
        questionId,
        () => {
          "uAnswer": value["selected"].join(","),
          "psqId": value["psqId"],
          "questionId": questionId,
          "time": "20",
        },
      );
    }
    String answerJson = jsonEncode(answerMap);
    HttpUtils.httpPostApi(encryptUrl, {
      "json": answerJson,
    }, (res) {
      HttpUtils.httpPost(unifiedAnswerAllUrl, {
        "examResultId": examResultId,
        "json": res["data"],
        "unifiedId": widget.unifiedId,
      }, (res) {
        if (res["code"].toString() == "1") {
          HttpUtils.httpPost(submitExamUrl, {
            "examResultId": examResultId,
            "unifiedId": widget.unifiedId,
          }, (res) {
            if (res["code"].toString() == "1") {
              _timer?.cancel();
              _timer = null;
              print(res);
              routePush(
                  UnifiedResultPage(
                    totalNum: res["unifiedPaper"]["totalNum"].toString(),
                    totalScore: res["unifiedPaper"]["totalScore"].toString(),
                    examScore: res["unifiedResult"]["examScore"].toString(),
                    timeStr: timeStr,
                  ),
                  RouterType.fade);
            }
          });
        }
      }, isCloseLoading: false);
    }, isCloseLoading: false);
  }

  void _timeStart() {
    _timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      seconds++;
      if (seconds > 59) {
        seconds = 0;
        minutes++;
      }
      timeStr =
          "${minutes >= 10 ? minutes : "0" + minutes.toString()}:${seconds >= 10 ? seconds : "0" + seconds.toString()}";
      setState(() {});
    });
  }
}
