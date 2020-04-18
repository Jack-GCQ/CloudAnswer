import 'package:flutter/material.dart';

class TapColor extends StatefulWidget {
  @required final Widget child;
  @required final Color activeColor;
  @required final Color unActiveColor;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;

  const TapColor({Key key, this.activeColor, this.unActiveColor, this.onTap, this.onLongPress, this.child}) : super(key: key);


  @override
  _TapColorState createState() => _TapColorState();
}

class _TapColorState extends State<TapColor> {
  bool isOnTapDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: (details) {
        setState(() {
          isOnTapDown = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          isOnTapDown = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isOnTapDown = false;
        });
      },
      child: Container(
        color: isOnTapDown ? widget.activeColor : widget.unActiveColor,
        child: widget.child,
      ),
    );
  }
}
