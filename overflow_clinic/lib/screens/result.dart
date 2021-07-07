import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:overflow_clinic/models/app.dart';
import 'package:overflow_clinic/shared/routes.dart';
import 'package:overflow_clinic/services/firestore.dart';
import 'package:overflow_clinic/themes/decoration.dart';
import 'package:overflow_clinic/models/score.dart';
import 'package:overflow_clinic/shared/handlers.dart';
import 'package:overflow_clinic/widgets/buttons.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

bool _isGeneratingResults = true;

class ResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Results',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            tooltip: 'Back to Home Screen',
            onPressed: () {
              if (!_isGeneratingResults) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  dashboard,
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: ResultsScreenBody(),
    );
  }
}

class ResultsScreenBody extends StatefulWidget {
  @override
  _ResultsScreenBodyState createState() => _ResultsScreenBodyState();
}

class _ResultsScreenBodyState extends State<ResultsScreenBody> {
  String url;
  bool _isLoading = true;
  bool _isError = false;
  String message;

  void handlePDFGenerateForCheckup() async {
    setState(() {
      _isError = false;
      _isLoading = true;
      _isGeneratingResults = true;
      message = 'Please Wait while generating your report...';
    });
    try {
      CheckupResults result = Provider.of<FirestoreService>(context, listen: false).checkupResults;
      DateTime today = DateTime.now();
      String date = today.day.toString() + '-' + today.month.toString() + '-' + today.year.toString();
      Map data = {
        'title'     : Provider.of<FirestoreService>(context, listen: false).name,
        'birthdate' : Provider.of<FirestoreService>(context, listen: false).dob,
        'age'       : Provider.of<FirestoreService>(context, listen: false).age.toString(),
        'date'      : date,
        'vision'    : result.visionAcuity,
        'contrast'  : result.contrast,
        'colorBlind': result.colorBlindness,
        'astigmatism': result.astigmatism,
        'ears'      : result.ears,
      };

      String body = json.encode(data);

      http.Response response = await http.post(
        kIsWeb ? RestAPI.proxy + RestAPI.url : RestAPI.url,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: body,
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 400) {
        throw 'Client error 400';
      } else if (response.statusCode == 500) {
        throw 'Internal server error: 500';
      } else if (response.statusCode == 200) {
        setState(() => message = 'Generating PDF now...');
        await Future.delayed(
          Duration(seconds: 2),
        );
        setState(() => message = 'You can now download your report in PDF');
      }
    } on TimeoutException catch (e) {
      setState(() {
        message = 'Error While Generating report in PDF';
        _isError = true;
      });
      handleSnackBar(
        context: context,
        message: e.message ?? 'Connection Timeout',
        duration: 2000,
      );
    } on PlatformException catch (e) {
      setState(() {
        message = 'Error While Generating report in PDF';
        _isError = true;
      });
      handleSnackBar(
        context: context,
        message: e.message ?? 'Unknown Platform Error',
        duration: 2000,
      );
    } on SocketException catch (e) {
      setState(() {
        message = 'Error While Generating report in PDF';
        _isError = true;
      });
      handleSnackBar(
        context: context,
        message: e.message ?? 'Unknown socket error',
        duration: 2000,
      );
    } catch (_) {
      setState(() {
        message = 'Error While Generating report in PDF';
        _isError = true;
      });
      handleSnackBar(
        context: context,
        message: 'Unknown Error',
        duration: 2000,
      );
    } finally {
      setState(() {
        _isLoading = false;
        _isGeneratingResults = false;
      });
    }
  }

  void handleDownloadPDF() async {
    if (await canLaunch(RestAPI.url)) {
      launch('${RestAPI.downloadURL}');
    } else {
      setState(() {
        message = 'Error in your device.';
        _isError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    handlePDFGenerateForCheckup();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Report Submitted for further process',
            style: kDefaultHeaderTextStyle,
          ),
          Text(
            '$message',
            style: kDefaultTextStyleLarge,
          ),
          SizedBox(
            height: 24.0,
          ),
          Visibility(
            visible: _isLoading,
            child: SpinKitChasingDots(
              color: kDefaultThemeColor,
            ),
          ),
          Visibility(
            visible: _isLoading,
            child: SizedBox(
              height: 24.0,
            ),
          ),
          Visibility(
            visible: _isError && !_isLoading,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SubmitButton(
                  title: 'RETRY',
                  onPressed: handlePDFGenerateForCheckup,
                ),
              ],
            ),
          ),
          Visibility(
            visible: _isError && !_isLoading,
            child: SizedBox(
              height: 24.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SubmitButton(
                enable: !_isError && !_isLoading,
                title: 'Download your report in PDF',
                onPressed: handleDownloadPDF,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
