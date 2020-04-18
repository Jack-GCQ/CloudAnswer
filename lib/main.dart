import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nav_router/nav_router.dart';
import 'package:yunda/login.dart';
import 'package:yunda/start.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BotToastInit(
      child: MaterialApp(
        title: '云答题',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
            color: Colors.transparent,
            elevation: 0,
            textTheme: TextTheme(
              title: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.white,
          ),
        ),
//        theme: CupertinoThemeData(
//          barBackgroundColor: ColorsUtil.hexColor("#eeeeee"),
//        ),
        navigatorObservers: [BotToastNavigatorObserver()],
        navigatorKey: navGK,
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}
