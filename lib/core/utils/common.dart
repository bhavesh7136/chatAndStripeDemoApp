import 'package:flutter/material.dart';

extension ExtNum on num {
  Widget get vs => SizedBox(height: toDouble());

  Widget get hs => SizedBox(width: toDouble());
}

extension ExtWidgets on Widget {

  Widget lp(double space) => Padding(
    padding: EdgeInsets.only(left: space),
    child: this,
  );

  Widget rp(double space) => Padding(
    padding: EdgeInsets.only(right: space),
    child: this,
  );

  Widget tp(double space) => Padding(
    padding: EdgeInsets.only(top: space),
    child: this,
  );

  Widget bp(double space) => Padding(
    padding: EdgeInsets.only(bottom: space),
    child: this,
  );

  Widget hp(double width) => Padding(
        padding: EdgeInsets.symmetric(horizontal: width),
        child: this,
      );

  Widget vp(double height) => Padding(
        padding: EdgeInsets.symmetric(vertical: height),
        child: this,
      );

  Widget hwp(double height, double width) => Padding(
        padding: EdgeInsets.symmetric(horizontal: width,vertical: height),
        child: this,
      );

  Widget allp(double padding) => Padding(
        padding: EdgeInsets.all(padding),
        child: this,
      );
}
