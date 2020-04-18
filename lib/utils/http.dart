import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:yunda/utils/utils.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';

class HttpUtils {
  static httpPost(String url, Map params, callback, {bool isCloseLoading = true}) async {
    await Utils.getData("token").then((val) {
      if (val != null) {
        params["token"] = val.toString();
      }
    });
    await Utils.getData("userId").then((val) {
      if (val != null) {
        params["userId"] = val.toString();
      }
    });
    params["_yl005_"] = Utils.getAuth(params, false);

    try {
      var dio = new Dio();
//      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
//        client.findProxy = (url) {
//          return "PROXY 192.168.1.106:8888";
//        };
//        //抓Https包设置
//        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//      };
      dio.options.connectTimeout = 10000;
      var response = await dio.post(url,
          data: params,
          options: Options(contentType: Headers.formUrlEncodedContentType, headers: {
            "User-Agent":
                "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1",
          }));
      if (isCloseLoading) {
        BotToast.closeAllLoading();
      }
      if (response.statusCode == 200) {
        var respInfo = jsonDecode(response.toString());
        if (respInfo["code"].toString() != "1") {
          BotToast.closeAllLoading();
          BotToast.showText(text: respInfo["msg"].toString());
        }
        await callback(respInfo);
      } else {
        BotToast.showText(text: "网络请求失败");
        print("状态码返回：${response.statusCode}");
      }
    } catch (e) {
      BotToast.closeAllLoading();
      BotToast.showText(text: "网络请求超时");
      print("异常：$e");
    }
  }

  static httpPostApi(String url, Map params, callback, {bool isCloseLoading = true}) async {
    if (params != null) {
      await Utils.getData("token").then((val) {
        if (val != null) {
          params["token"] = val.toString();
        }
      });
      await Utils.getData("userId").then((val) {
        if (val != null) {
          params["userId"] = val.toString();
        }
      });
      params["_yl005_"] = Utils.getAuth(params, false);
    }

    try {
      var dio = new Dio();
//      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
//        client.findProxy = (url) {
//          return "PROXY 192.168.1.106:8888";
//        };
//        //抓Https包设置
//        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//      };
      dio.options.connectTimeout = 10000;
      var response = await dio.post(url,
          data: params,
          options: Options(contentType: Headers.formUrlEncodedContentType, headers: {
            "User-Agent":
                "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1",
          }));
      if (isCloseLoading) {
        BotToast.closeAllLoading();
      }
      if (response.statusCode == 200) {
        var respInfo = jsonDecode(response.toString());
        if (respInfo["code"].toString() != "200") {
          BotToast.closeAllLoading();
          BotToast.showText(text: respInfo["msg"].toString());
        }
        await callback(respInfo);
      } else {
        BotToast.showText(text: "网络请求失败");
        print("状态码返回：${response.statusCode}");
      }
    } catch (e) {
      BotToast.closeAllLoading();
      BotToast.showText(text: "网络请求超时");
      print("异常：$e");
    }
  }

  static httpGetApi(String url, Map params, callback) async {
    try {
      var dio = new Dio();
      dio.options.connectTimeout = 10000;
      var response = await dio.get(url,
          queryParameters: params,
          options: Options(contentType: Headers.formUrlEncodedContentType, headers: {
            "User-Agent":
                "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1",
          }));
      if (response.statusCode == 200) {
        var respInfo = jsonDecode(response.toString());
        await callback(respInfo);
      } else {
        BotToast.showText(text: "网络请求失败");
        print("状态码返回：${response.statusCode}");
      }
    } catch (e) {
      BotToast.closeAllLoading();
      BotToast.showText(text: "网络请求超时");
      print("异常：$e");
    }
  }

  static httpGet(String url, Map params, callback) async {
    await Utils.getData("token").then((val) {
      if (val != null) {
        params["token"] = val.toString();
      }
    });
    await Utils.getData("userId").then((val) {
      if (val != null) {
        params["userId"] = val.toString();
      }
    });
    params["_yl005_"] = Utils.getAuth(params, false);
    try {
      var dio = new Dio();
//      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
//        client.findProxy = (url) {
//          return "PROXY 192.168.1.106:8888";
//        };
//        //抓Https包设置
//        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//      };
      dio.options.connectTimeout = 10000;
      var response = await dio.get(url,
          queryParameters: params,
          options: Options(contentType: Headers.formUrlEncodedContentType, headers: {
            "User-Agent":
                "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1",
          }));
      BotToast.closeAllLoading();
      if (response.statusCode == 200) {
        var respInfo = jsonDecode(response.toString());
        if (respInfo["code"].toString() != "1") {
          BotToast.closeAllLoading();
          BotToast.showText(text: respInfo["msg"].toString());
        }
        await callback(respInfo);
      } else {
        BotToast.showText(text: "网络请求失败");
        print("状态码返回：${response.statusCode}");
      }
    } catch (e) {
      BotToast.closeAllLoading();
      BotToast.showText(text: "网络请求超时");
      print("异常：$e");
    }
  }

  static httpPostLogin(Map params, callback) async {
    params["encrypt"] = Utils.getAuth(params, true);
    var url = firstLoginUrl;
    var response = await http.post(url, body: params);
    await callback(jsonDecode(response.body.toString()));
  }
}
