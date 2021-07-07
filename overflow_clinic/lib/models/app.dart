import 'package:flutter/material.dart';

class AppDetails {
  static const String name = 'Overflow Clinic';
  static const String version = '1.0.0';
  static const String logo = 'assets/images/logo.png';
  static const String intro = 'Overflow Clinic is an eye and ear testing app which was developed by seeing the situation of COVID-19 pandemic. Because of this pandemic people are not able to move out to a doctor as it may be risky to go out of home so we came with a solution with this app where you can test your eyes and ears at home and we will advice you to consult a doctor only if something is really serious.\n\nWe as Team Hackerflow created this app in Codeflow held at Tantrafiesta 2020 in Indian Institute of Information Technology, Nagpur.';
  static const String working = '';
}

class RestAPI {
  static const proxy = 'https://cors-anywhere.herokuapp.com/';
  static const url = 'https://api-hackoverflow.herokuapp.com/';
  static const downloadURL = 'https://api-hackoverflow.herokuapp.com/download/';
}

class Creator {
  final String name;
  final String role;
  final String about;
  final String facebook;
  final String github;
  final String instagram;
  final String linkedin;
  final String twitter;
  final String youtube;

  Creator({
    @required this.name,
    @required this.about,
    @required this.role,
    this.facebook,
    this.github,
    this.instagram,
    this.linkedin,
    this.twitter,
    this.youtube,
  });
}

final List<Creator> creators = [
  Creator(
    name: 'Priyank Kumar Singh',
    role: 'App Developer and Backend Service Management',
    about: 'Student at Indian Institute of Information Technology, Nagpur',
    github: 'https://www.github.com/kpriyanksingh',
    instagram: 'https://www.instagram.com/priyank_kumar_singh',
    linkedin: 'https://www.linkedin.com/in/priyank-kumar-singh-9a7221193/',
    youtube: 'https://www.youtube.com/channel/UC4w4CiMgAG6s9aP8RcXPAzw',
  ),
  Creator(
    name: 'Raghav Agrawal',
    role: 'Web and App Developer',
    about: 'Student at Indian Institute of Information Technology, Nagpur',
    github: 'https://www.github.com/raghav1701',
  ),
  Creator(
    name: 'Keertiraj Malkar',
    role: 'REST APIs and other Backend Services Developer',
    about: 'Student at Indian Institute of Information Technology, Nagpur',
    github: 'https://github.com/kirteeraj',
    instagram: 'https://www.instagram.com/kirteeraj_malkar/',
    linkedin: 'https://www.linkedin.com/in/kirteeraj-malkar-7420601a0',
    youtube: 'https://www.youtube.com/channel/UCz6uWQjzOAZey6MMWjVq76g'
  ),
  Creator(
    name: 'Pranav Patil',
    role: 'Content Writer',
    about: 'Student at Indian Institute of Information Technology, Nagpur',
    github: 'https://www.github.com/patilcyber',
    instagram: 'https://www.instagram.com/p_a_t_i_l___3030/',
    linkedin: 'https://www.linkedin.com/in/pranav-patil-418691199',
  ),
];
