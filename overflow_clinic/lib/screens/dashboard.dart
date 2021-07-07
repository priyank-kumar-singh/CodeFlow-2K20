import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:overflow_clinic/screens/dashboard/history.dart';
import 'package:overflow_clinic/screens/dashboard/ear.dart';
import 'package:overflow_clinic/screens/dashboard/eye.dart';
import 'package:overflow_clinic/screens/dashboard/home.dart';
import 'package:overflow_clinic/shared/handlers.dart';
import 'package:overflow_clinic/shared/routes.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentScreenIndex = 0;

  bool _isLoading = false;

  final List<Widget> _childScreen = [
    HomePage(),
    EyePage(),
    EarPage(),
    HistoryPage(),
  ];

  final List<String> _popUpMenuItems = [
    'About Us',
    'Contact Us    ',
    'Settings      ',
    'Sign Out',
  ];

  void handlePopupMenuItem(String option) {
    if (option == _popUpMenuItems[0]) {
      Navigator.pushNamed(context, aboutUs);
    } else if (option == _popUpMenuItems[1]) {

    } else if (option == _popUpMenuItems[2]) {
      Navigator.pushNamed(context, settings);
    } else {
      handleSignOutDialog(context, (bool x) => setState(() => _isLoading = x));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            child: Text('Overflow Clinic'),
            onTap: () => handlePopupMenuItem('About Us'),
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) {
                return _popUpMenuItems.map((option) => PopupMenuItem(
                  child: Text(option),
                  value: option,
                )).toList();
              },
              onSelected: handlePopupMenuItem,
            ),
          ],
        ),
        body: _childScreen[_currentScreenIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentScreenIndex,
          onTap: (value) => setState(() => _currentScreenIndex = value),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.eye),
              title: Text("Eye Care"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text("Ear Care"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              title: Text("History"),
            ),
          ],
        ),
      ),
    );
  }
}
