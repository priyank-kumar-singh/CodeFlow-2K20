import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:overflow_clinic/shared/constants.dart';

class ImageRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Wrap(
        children: [1, 2, 3, 4, 5, 6].map((index) {
          return Image(image: AssetImage('$kTipsImages$index.jpg'));
        }).toList(),
      );
    } else {
      return Column(
        children: [1, 3, 5].map((row) {
          return Row(
            children: [row, row+1].map((index) {
              return Expanded(child: Image(image: AssetImage('$kTipsImages$index.jpg')));
            }).toList(),
          );
        }).toList(),
      );
    }
  }
}
