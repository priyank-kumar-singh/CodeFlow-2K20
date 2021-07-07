import 'package:flutter/material.dart';
import 'package:overflow_clinic/shared/routes.dart';
import 'package:overflow_clinic/themes/decoration.dart';
import 'package:overflow_clinic/widgets/buttons.dart';

class EarPage extends StatelessWidget {
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
                  '1. Adjust you volume such that you should be comfortable at.',
                  style: kDefaultTextStyle,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  '2. Make sure you are in noise free environment',
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
              onPressed: () => Navigator.pushNamed(context, eartest),
            ),
          ],
        ),
      ),
    );
  }
}
