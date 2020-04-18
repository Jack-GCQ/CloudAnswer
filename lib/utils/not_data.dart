import 'package:flutter/material.dart';

class NotData {
  static notData(bool show, {String text}) {
    if (!show) {
      return null;
    }
    return Container(
      height: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: SizedBox(),
            flex: 2,
          ),
          SizedBox(
            width: 100.0,
            height: 100.0,
            child: Image.asset('assets/images/nodata.png'),
          ),
          Text(
            text != null ? text : "没有数据",
            style: TextStyle(fontSize: 16.0, color: Colors.grey[400]),
          ),
          Expanded(
            child: SizedBox(),
            flex: 3,
          ),
        ],
      ),
    );
  }
}
