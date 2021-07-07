import 'package:flutter/material.dart';
import 'package:overflow_clinic/screens/about.dart';
import 'package:overflow_clinic/screens/authenticate/add_details.dart';
import 'package:overflow_clinic/screens/dashboard.dart';
import 'package:overflow_clinic/screens/authenticate/authenticate.dart';
import 'package:overflow_clinic/screens/eartest.dart';
import 'package:overflow_clinic/screens/eyetest.dart';
import 'package:overflow_clinic/screens/result.dart';
import 'package:overflow_clinic/screens/settings.dart';
import 'package:overflow_clinic/wrapper.dart';

const String wrapper        = '/wrapper';
const String welcome        = '/welcome';
const String addDetails     = '/addDetails';
const String dashboard      = '/dashboard';
const String eyetest        = '/eyetest';
const String eartest        = '/eartest';
const String resultsScreen  = '/results';
const String settings       = '/settings';
const String aboutUs        = '/aboutus';

Map<String, WidgetBuilder> routes = {
  wrapper       : (context) => Wrapper(),
  welcome       : (context) => AuthenticationScreen(),
  addDetails    : (context) => AddDetails(),
  dashboard     : (context) => Dashboard(),
  eyetest       : (context) => EyeTesting(),
  eartest       : (context) => EarTesting(),
  resultsScreen : (context) => ResultsScreen(),
  settings      : (context) => SettingsPage(),
  aboutUs       : (context) => AboutPage(),
};
