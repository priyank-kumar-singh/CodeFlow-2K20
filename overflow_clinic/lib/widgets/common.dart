import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:overflow_clinic/themes/decoration.dart';

class CenterHeaderText extends StatelessWidget {
  CenterHeaderText(this.title);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title',
        style: kDefaultHeaderTextStyle,
      ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitChasingDots(
        color: kDefaultThemeColor,
      ),
    );
  }
}
