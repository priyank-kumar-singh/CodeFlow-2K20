import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:overflow_clinic/shared/constants.dart';
import 'package:overflow_clinic/shared/routes.dart';
import 'package:overflow_clinic/services/firestore.dart';
import 'package:overflow_clinic/shared/questions.dart';
import 'package:overflow_clinic/themes/decoration.dart';
import 'package:overflow_clinic/shared/handlers.dart';
import 'package:overflow_clinic/models/score.dart';
import 'package:overflow_clinic/widgets/buttons.dart';
import 'package:overflow_clinic/widgets/common.dart';
import 'package:provider/provider.dart';

class EyeTesting extends StatefulWidget {
  @override
  _EyeTestingState createState() => _EyeTestingState();
}

class _EyeTestingState extends State<EyeTesting> {
  int _currentQuestion = 0;
  int _currentTestScreen = 0;
  bool _isLastQuestion = false;
  bool _isFABEnable = true;
  bool _isZeroQuestion = true;
  CheckupScores _score;
  BuildContext _scaffoldContext;
  bool _previousQuestionAnswerStatus = false;
  int _snackBarDuration = 500;
  bool _isLoading = false;

  List<String> _titles = [
    'Vision Acuity Test',
    'Contrast Test',
    'Color Blindness Test',
    'Astigmatism Test',
  ];

  void nextScreen() {
    setState(() {
      _currentQuestion = 0;
      _currentTestScreen++;
      _isZeroQuestion = true;
    });
  }

  void handleFABGetStarted() {
    setState(() {
      _currentQuestion++;
      _isZeroQuestion = false;
      _isFABEnable = false;
    });
  }

  void handleFABNextQuestion() async {
    if ((_currentTestScreen == 0 &&
            _currentQuestion == visionAcuityQuestionAnswer.length) ||
        (_currentTestScreen == 1 &&
            _currentQuestion == contrastTestQuestionAnswer.length) ||
        (_currentTestScreen == 2 &&
            _currentQuestion == colorBlindTestQuestionAnswer.length))
      nextScreen();
    else if (_currentTestScreen == 3 && _currentQuestion == 1) {
      setState(() => _isLoading = true);
      Provider.of<FirestoreService>(context, listen: false).copyCheckupScoreDataInProviderCache(_score);
      dynamic result = await Provider.of<FirestoreService>(context, listen: false).createCheckupReportInFirestoreDatabase();
      setState(() => _isLoading = false);
      if (result.code != '1')
        handleSnackBar(context: _scaffoldContext, message: result.message, duration: 4000);
      else {
        Navigator.pushNamedAndRemoveUntil(context, resultsScreen, (route) => false);
      }
    } else {
      setState(() {
        _currentQuestion++;
        _isFABEnable = false;
      });
    }
  }

  void handleAcuityForward(String value) {
    if (_isFABEnable == true)
      return;
    if (value == visionAcuityQuestionAnswer[_currentQuestion - 1].solution) {
      _score.scoreVisionAcuity(
          visionAcuityQuestionAnswer[_currentQuestion - 1].points);
      showSuccessfulMessageInSnackBar();
    } else {
      showUnsuccessfulMessageInSnackBar();
    }
    setState(() => _isFABEnable = true);
  }

  void handleContrastForward(String value) {
    if (_isFABEnable == true)
      return;
    if (value == contrastTestQuestionAnswer[_currentQuestion - 1].solution) {
      _score.scoreContrast(
          contrastTestQuestionAnswer[_currentQuestion - 1].points);
      showSuccessfulMessageInSnackBar();
    } else {
      showUnsuccessfulMessageInSnackBar();
    }
    setState(() => _isFABEnable = true);
  }

  void handleColorBlindnessForward(String value) {
    if (_isFABEnable == true)
      return;
    if (value == colorBlindTestQuestionAnswer[_currentQuestion - 1].solution) {
      _score.scoreColorBlindness(
          colorBlindTestQuestionAnswer[_currentQuestion - 1].points);
      showSuccessfulMessageInSnackBar();
    } else if (_currentQuestion == colorBlindTestQuestionAnswer.length) {
      handleSnackBar(
        context: _scaffoldContext,
        message: 'A correct eye will see no number in this image',
        duration: 2000,
      );
    } else {
      showUnsuccessfulMessageInSnackBar();
    }
    setState(() => _isFABEnable = true);
  }

  void handleAstigmatism(String value) {
    if (_isFABEnable == true)
      return;
    else if (value == astigmatismQuestionAnswer.option1) {
      _score.scoreAstigmatism(5);
      handleSnackBar(context: _scaffoldContext, message: 'Nice', duration: 2000);
    }
    else if (value == astigmatismQuestionAnswer.option2) {
      _score.scoreAstigmatism(3);
      handleSnackBar(context: _scaffoldContext, message: 'Need checkup', duration: 2000);
    }
    else if (value == astigmatismQuestionAnswer.option3) {
      _score.scoreAstigmatism(1);
      handleSnackBar(context: _scaffoldContext, message: 'Suffering from Astigmatism', duration: 2000);
    }
    else {
      handleSnackBar(context: _scaffoldContext, message: 'Danger', duration: 2000);
    }
    setState(() {
      _isFABEnable = true;
      _isLastQuestion = true;
    });
  }

  void showSuccessfulMessageInSnackBar() {
    if (_previousQuestionAnswerStatus == true)
      handleSnackBar(
        context: _scaffoldContext,
        message: 'Yippee one more correct answer',
        duration: _snackBarDuration,
      );
    else
      handleSnackBar(
        context: _scaffoldContext,
        message: 'Yippee correct answer',
        duration: _snackBarDuration,
      );
    _previousQuestionAnswerStatus = true;
  }

  void showUnsuccessfulMessageInSnackBar() {
    if (_previousQuestionAnswerStatus == false)
      handleSnackBar(
        context: _scaffoldContext,
        message: 'Oops! one more incorrect answer',
        duration: _snackBarDuration,
      );
    else
      handleSnackBar(
        context: _scaffoldContext,
        message: 'Oops! incorrect answer',
        duration: _snackBarDuration,
      );
    _previousQuestionAnswerStatus = false;
  }

  Widget handleRenderTestScreen(BuildContext context) {
    if (_currentQuestion == 0) {
      if (_currentTestScreen == 0)
        return CenterHeaderText('Part 1:\nVision Acuity Test');
      else if (_currentTestScreen == 1)
        return CenterHeaderText('Part 2:\nContrast Test');
      else if (_currentTestScreen == 2)
        return CenterHeaderText('Part 3:\nColor Blindness Test');
      if (_currentTestScreen == 3)
        return CenterHeaderText('Final Test:\nAstigmatism Test');
    } else if (_currentTestScreen == 0)
      return _buildVisionAcuityTestBody(context);
    else if (_currentTestScreen == 1)
      return _buildContrastTestBody(context);
    else if (_currentTestScreen == 2)
      return _buildColorBlindnessTestBody(context);
    return _buildAstigmatism(context);
  }

  Widget _buildVisionAcuityTestBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$visionAcuityQuestion',
          style: kDefaultTextStyleLarge,
          textAlign: TextAlign.justify,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SquareButton(
                  action: handleAcuityForward,
                  icon: Icons.arrow_upward,
                  value: 'T',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SquareButton(
                  action: handleAcuityForward,
                  icon: Icons.arrow_back,
                  value: 'L',
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image(
                    image: AssetImage(
                      '$kVisionTestImages$_currentQuestion.png',
                    ),
                    height: 100,
                    width: 100,
                  ),
                ),
                SquareButton(
                  action: handleAcuityForward,
                  icon: Icons.arrow_forward,
                  value: 'R',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SquareButton(
                  action: handleAcuityForward,
                  icon: Icons.arrow_downward,
                  value: 'B',
                ),
              ],
            ),
          ],
        ),
        Container(
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildContrastTestBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$contrastTestQuestion',
          style: kDefaultTextStyleLarge,
          textAlign: TextAlign.justify,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SquareButton(
                  action: handleContrastForward,
                  icon: Icons.arrow_upward,
                  value: 'T',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SquareButton(
                  action: handleContrastForward,
                  icon: Icons.arrow_back,
                  value: 'L',
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Image(
                    image: AssetImage(
                      '$kContrastTestImages$_currentQuestion.png',
                    ),
                    height: 40,
                    width: 40,
                  ),
                ),
                SquareButton(
                  action: handleContrastForward,
                  icon: Icons.arrow_forward,
                  value: 'R',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SquareButton(
                  action: handleContrastForward,
                  icon: Icons.arrow_downward,
                  value: 'B',
                ),
              ],
            ),
          ],
        ),
        Container(
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildColorBlindnessTestBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$colorBlindTestQuestion',
          style: kDefaultTextStyleLarge,
          textAlign: TextAlign.justify,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Image(
                      image: AssetImage('$kColorBlindnessTestImages$_currentQuestion.png'),
                      width: 300,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceButton(
                  action: handleColorBlindnessForward,
                  title: colorBlindTestQuestionAnswer[_currentQuestion - 1]
                      .option1,
                  value: colorBlindTestQuestionAnswer[_currentQuestion - 1]
                      .option1,
                ),
                SizedBox(
                  width: 10.0,
                ),
                ChoiceButton(
                  action: handleColorBlindnessForward,
                  title: colorBlindTestQuestionAnswer[_currentQuestion - 1]
                      .option2,
                  value: colorBlindTestQuestionAnswer[_currentQuestion - 1]
                      .option2,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceButton(
                  action: handleColorBlindnessForward,
                  title: colorBlindTestQuestionAnswer[_currentQuestion - 1]
                      .option3,
                  value: colorBlindTestQuestionAnswer[_currentQuestion - 1]
                      .option3,
                ),
                SizedBox(
                  width: 10.0,
                ),
                ChoiceButton(
                  action: handleColorBlindnessForward,
                  title: colorBlindTestQuestionAnswer[_currentQuestion - 1]
                      .option4,
                  value: colorBlindTestQuestionAnswer[_currentQuestion - 1]
                      .option4,
                ),
              ],
            ),
          ],
        ),
        Container(
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildAstigmatism(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$astigmatismQuestion',
          style: kDefaultTextStyleLarge,
          textAlign: TextAlign.justify,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Image(
                      image: AssetImage(kAstigmatismTestImage),
                      width: 300,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceButton(
                  action: handleAstigmatism,
                  title: astigmatismQuestionAnswer.option1,
                  value: astigmatismQuestionAnswer.option1,
                ),
                SizedBox(
                  width: 10.0,
                ),
                ChoiceButton(
                  action: handleAstigmatism,
                  title: astigmatismQuestionAnswer.option2,
                  value: astigmatismQuestionAnswer.option2,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceButton(
                  action: handleAstigmatism,
                  title: astigmatismQuestionAnswer.option3,
                  value: astigmatismQuestionAnswer.option3,
                ),
                SizedBox(
                  width: 10.0,
                ),
                ChoiceButton(
                  action: handleAstigmatism,
                  title: astigmatismQuestionAnswer.option4,
                  value: astigmatismQuestionAnswer.option4,
                ),
              ],
            ),
          ],
        ),
        Container(
          width: double.infinity,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _score = CheckupScores(type: 0);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_currentTestScreen]),
          actions: [
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: kThemeGroundColor,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        floatingActionButton: SubmitButton(
          enable: _isFABEnable,
          onPressed: _isZeroQuestion ? handleFABGetStarted : handleFABNextQuestion,
          title: _isZeroQuestion ? 'Start Test' : _isLastQuestion ? 'Submit' : 'Next',
        ),
        body: Builder(
          builder: (context) {
            _scaffoldContext = context;
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                child: handleRenderTestScreen(context),
              ),
            );
          },
        ),
      ),
    );
  }
}
