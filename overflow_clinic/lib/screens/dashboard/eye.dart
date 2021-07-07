import 'package:flutter/material.dart';
import 'package:overflow_clinic/shared/routes.dart';
import 'package:overflow_clinic/themes/decoration.dart';
import 'package:overflow_clinic/widgets/buttons.dart';

class EyePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Guidelines for the test',
                  style: kDefaultHeaderTextStyle,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  '1. Place yourself 1-meter from the screen',
                  style: kDefaultTextStyle,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  '2. If you have glasses for distance vision or glasses with progressive lenses, keep them on.',
                  style: kDefaultTextStyle,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  '3. Without pressing on the eyesolid, cover your left/right eye with your hand.',
                  style: kDefaultTextStyle,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  '4. Indicate which way the open side of the \'E\' is facing by choosing appropriate option.',
                  style: kDefaultTextStyle,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
            SubmitButton(
              title: 'Start Test',
              onPressed: () => Navigator.pushNamed(context, eyetest),
            ),
          ],
        ),
      ),
    );
  }
}
