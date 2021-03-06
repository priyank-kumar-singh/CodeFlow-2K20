import 'package:flutter/material.dart';
import 'package:overflow_clinic/themes/decoration.dart';
import 'package:url_launcher/url_launcher.dart';

class ChoiceButton extends StatelessWidget {
  const ChoiceButton({
    @required this.action,
    this.title = '',
    this.value,
    this.color = kDefaultThemeColor,
  });
  final String title;
  final String value;
  final Color color;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(
        title,
        style: TextStyle(
          color: kThemeGroundColor,
        ),
      ),
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      onPressed: () => action(value),
    );
  }
}

class SquareButton extends StatelessWidget {
  SquareButton({this.icon, this.value, this.action});

  final IconData icon;
  final String value;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.green,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 35.0,
          ),
        ),
      ),
      onTap: () => action(value),
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    @required this.onPressed,
    this.enable = true,
    this.title = 'Continue',
  });

  final bool enable;
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(
        title,
        style: TextStyle(
          color: kThemeGroundColor,
        ),
      ),
      color: kDefaultThemeColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      onPressed: enable ? onPressed : null,
    );
  }
}

class SocialMediaButton extends StatelessWidget {
  SocialMediaButton({
    @required this.icon,
    @required this.url,
    this.size = 30.0,
  });

  /// Icon value can be `Facebook`, `Instagram`, `GitHub`, `LinkedIn`, `Twitter`, `YouTube`
  final String icon;

  /// URL to be launched when click this social media button
  final String url;

  final double size;

  @override
  Widget build(BuildContext context) {
    final String image = 'assets/icons/' + icon.toLowerCase() + '.png';
    return IconButton(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      icon: Image(image: AssetImage(image), height: size, width: size),
      onPressed: () => _launchUrl(context, url),
      splashRadius: 25.0,
    );
  }

  _launchUrl(BuildContext context, String url) async {
    try {
      if (await canLaunch(url))
        await launch(url);
      else
        throw 'error';
    } catch (e) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Error in launching target url')));
    }
  }
}
