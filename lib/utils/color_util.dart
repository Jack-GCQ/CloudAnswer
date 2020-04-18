import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorsUtil {
  static Color hexColor(String s) {
    if (s == null || s.length != 7 || int.tryParse(s.substring(1, 7), radix: 16) == null) {
      s = '#999999';
    }
    return new Color(int.parse(s.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static final Color linearColor1 = ColorsUtil.hexColor("#3B8EFF");
  static final Color linearColor2 = ColorsUtil.hexColor("#0A67E6");

  static Gradient left2right() {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        linearColor1,
        linearColor2,
      ],
    );
  }

  static Gradient right2left() {
    return LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      colors: [
        linearColor1,
        linearColor2,
      ],
    );
  }

  static Gradient top2bottom() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        linearColor1,
        linearColor2,
      ],
    );
  }

  static Gradient bottom2top() {
    return LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        linearColor1,
        linearColor2,
      ],
    );
  }

  static List<Gradient> gradientList() {
    List<Gradient> listData = [
      LinearGradient(colors: [
        ColorsUtil.hexColor("#5B96FC"),
        ColorsUtil.hexColor("#5BCAFF"),
      ]),
      LinearGradient(colors: [
        ColorsUtil.hexColor("#84FAB0"),
        ColorsUtil.hexColor("#8FD3F4"),
      ]),
      LinearGradient(colors: [
        ColorsUtil.hexColor("#5EE7DF"),
        ColorsUtil.hexColor("#B490CA"),
      ]),
      LinearGradient(colors: [
        ColorsUtil.hexColor("#D299C2"),
        ColorsUtil.hexColor("#FEF9D7"),
      ]),
      LinearGradient(colors: [
        ColorsUtil.hexColor("#F470D3"),
        ColorsUtil.hexColor("#C073F3"),
      ]),
      LinearGradient(colors: [
        ColorsUtil.hexColor("#4EADFD"),
        ColorsUtil.hexColor("#06EFFE"),
      ]),
      LinearGradient(colors: [
        ColorsUtil.hexColor("#FDA3A4"),
        ColorsUtil.hexColor("#FCC5C0"),
      ]),
    ];
    return listData;
  }

  static Gradient gradientRandom() {
    List<Gradient> listData = gradientList();
    int rand = Random().nextInt(listData.length - 1);
    return listData[rand];
  }
}
