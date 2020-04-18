import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yunda/utils/color_util.dart';

class NoticeDetailsPage extends StatefulWidget {
  final String notice;

  const NoticeDetailsPage({Key key, this.notice}) : super(key: key);

  @override
  _NoticeDetailsPageState createState() => _NoticeDetailsPageState();
}

class _NoticeDetailsPageState extends State<NoticeDetailsPage> {
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
            title: Text("详情"),
            centerTitle: true,
          ),
        ),
        preferredSize: Size.fromHeight(44),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 30),
        children: <Widget>[
          Container(
            child: Text(widget.notice.toString()),
          ),
        ],
      ),
    );
  }
}
