import 'package:flutter/material.dart';
import 'package:overflow_clinic/models/app.dart';
import 'package:overflow_clinic/themes/decoration.dart';
import 'package:overflow_clinic/widgets/about_card.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int member = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Introduction-',
                  style: kDefaultHeaderTextStyle,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  '${AppDetails.intro}',
                  style: kDefaultTextStyle,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Team Details-',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 4.0,
                ),
              ]..addAll(
                creators.map((creator) {
                  return TeamMemberInfoCard(member++);
                }).toList()
              ),
            ),
          ),
        ),
      ),
    );
  }
}
