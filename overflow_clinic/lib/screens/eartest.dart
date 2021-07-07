import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:overflow_clinic/shared/routes.dart';
import 'package:overflow_clinic/services/firestore.dart';
import 'package:overflow_clinic/shared/questions.dart';
import 'package:overflow_clinic/themes/decoration.dart';
import 'package:overflow_clinic/shared/handlers.dart';
import 'package:overflow_clinic/models/score.dart';
import 'package:overflow_clinic/widgets/buttons.dart';
import 'package:overflow_clinic/widgets/common.dart';
import 'package:provider/provider.dart';

class EarTesting extends StatefulWidget {
  @override
  _EarTestingState createState() => _EarTestingState();
}

class _EarTestingState extends State<EarTesting> {
  final player = AudioCache();
  int _currentQuestion = -1;
  bool _isLastQuestion = false;
  bool _isFABEnable = true;
  bool _isZeroQuestion = true;
  CheckupScores _score;
  BuildContext _scaffoldContext;
  bool _previousQuestionAnswerStatus = false;
  int _snackBarDuration = 500;
  bool _isLoading = false;

  void handleFABGetStarted() {
    setState(() {
      _currentQuestion++;
      _isZeroQuestion = false;
      _isFABEnable = false;
    });
  }

  void handleFABNextQuestion() async {
    if (_currentQuestion == 8) {
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

  void handleYesNoQuestion(String value) {
    if (_isFABEnable == true) return;
    if (value == 'NO') {
      _score.scoreEars(1);
      handleSnackBar(
        context: _scaffoldContext,
        message: 'Nice',
        duration: _snackBarDuration,
      );
    } else {
      handleSnackBar(
        context: _scaffoldContext,
        message: 'Oh! No',
        duration: _snackBarDuration,
      );
    }
    setState(() => _isFABEnable = true);
  }

  void handleSoundQuestionOptions(String value) {
    if (_isFABEnable == true)
      return;
    if (value == '4') {
      _score.scoreEars(1);
      showSuccessfulMessageInSnackBar();
    } else {
      showUnsuccessfulMessageInSnackBar();
    }
    setState(() => _isFABEnable = true);
  }

  void handleSoundQuestionYesNo(String value) {
    if (_isFABEnable == true)
      return;
    if (value == 'YES') {
      _score.scoreEars(2);
      handleSnackBar(
          context: _scaffoldContext,
          message: 'Nice',
          duration: _snackBarDuration);
    } else {
      handleSnackBar(
          context: _scaffoldContext,
          message: 'Oh! No',
          duration: _snackBarDuration);
    }
    setState(() {
      _isFABEnable = true;
      _isLastQuestion = true;
    });
  }

  void playSound(int soundNumber) {
    if (!_isFABEnable)
      player.play('sounds/sound$soundNumber.mp3');
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
    if (_currentQuestion == -1) {
      return CenterHeaderText('Tap the start button to start the test.');
    } else if (_currentQuestion >= 0 && _currentQuestion < 7) {
      return _buildYesNoQuestions(context);
    } else if (_currentQuestion == 7) {
      return _buildSoundQuestionOptions(context);
    } else {
      return _buildSoundQuestionYesNo(context);
    }
  }

  Widget _buildYesNoQuestions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              '${earQuestions[_currentQuestion]}',
              style: kDefaultTextStyleLarge,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
        SizedBox(
          height: 30.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceButton(
              action: handleYesNoQuestion,
              title: 'NO',
              value: 'NO',
            ),
            SizedBox(
              width: 10.0,
            ),
            ChoiceButton(
              action: handleYesNoQuestion,
              color: Colors.redAccent,
              title: 'YES',
              value: 'YES',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSoundQuestionOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              '$soundQuestion1',
              style: kDefaultTextStyleLarge,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
        SizedBox(
          height: 30.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton.icon(
              icon: Icon(Icons.play_arrow),
              label: Text('Play Sound'),
              onPressed: () => playSound(1),
            ),
          ],
        ),
        SizedBox(
          height: 50.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceButton(
              action: handleSoundQuestionOptions,
              title: '3',
              value: '3',
            ),
            SizedBox(
              width: 10.0,
            ),
            ChoiceButton(
              action: handleSoundQuestionOptions,
              title: '2',
              value: '2',
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceButton(
              action: handleSoundQuestionOptions,
              title: '4',
              value: '4',
            ),
            SizedBox(
              width: 10.0,
            ),
            ChoiceButton(
              action: handleSoundQuestionOptions,
              title: 'None',
              value: 'None',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSoundQuestionYesNo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              '$soundQuestion2',
              style: kDefaultTextStyleLarge,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
        SizedBox(
          height: 30.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton.icon(
              icon: Icon(Icons.play_arrow),
              label: Text('Play Sound'),
              onPressed: () => playSound(2),
            ),
          ],
        ),
        SizedBox(
          height: 50.0,
        ),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            ChoiceButton(
              action: handleSoundQuestionYesNo,
              color: Colors.redAccent,
              title: 'NO',
              value: 'NO',
            ),
            SizedBox(
              width: 10.0,
            ),
            ChoiceButton(
              action: handleSoundQuestionYesNo,
              title: 'YES',
              value: 'YES',
            ),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _score = CheckupScores(type: 1);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ear Sensitivity Test'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            tooltip: 'Cancel Test',
            onPressed: () => Navigator.pop(context),
          ),
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
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                child: handleRenderTestScreen(context),
              ),
            );
          },
        ),
      ),
    );
  }
}
