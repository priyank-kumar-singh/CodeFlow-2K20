import 'package:flutter/material.dart';

/// `Default Light Theme` with custom changes
final ThemeData kdefaultTheme = ThemeData.light().copyWith(
  appBarTheme: AppBarTheme(
    centerTitle: false,
    color: Colors.greenAccent,
  ),

  backgroundColor: Colors.white,

  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.white,
    modalBackgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
    ),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.green,
    selectedIconTheme: IconThemeData(
      color: Colors.green,
    ),
    selectedLabelStyle: TextStyle(
      color: Colors.green,
    ),
    unselectedIconTheme: IconThemeData(
      color: Colors.grey,
    ),
    unselectedLabelStyle: TextStyle(
      color: Colors.grey,
    ),
    type: BottomNavigationBarType.fixed,
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData().copyWith(
    backgroundColor: Colors.lightBlueAccent,
  ),

  inputDecorationTheme: InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.green, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
    hintStyle: TextStyle(color: Colors.grey),
    labelStyle: TextStyle(color: Colors.grey),
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: Color(0xFF323232),
    behavior: SnackBarBehavior.floating,
    actionTextColor: Colors.purple,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  ),

  scaffoldBackgroundColor: Colors.white,

  textTheme: TextTheme(
    bodyText2: TextStyle(color: Colors.black54),
    subtitle1: TextStyle(color: Colors.black54),
  ),
);
