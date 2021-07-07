import 'package:overflow_clinic/models/question.dart';

final String visionAcuityQuestion = 'Choose corresponding arrow option indicating the direction of the open side of the \'E\'.';
final List<Question> visionAcuityQuestionAnswer = [
  Question(
    solution: 'L',
  ),
  Question(
    solution: 'R',
  ),
  Question(
    solution: 'T',
  ),
  Question(
    solution: 'B',
  ),
  Question(
    solution: 'L',
  ),
  Question(
    solution: 'B',
    points: 2,
  ),
  Question(
    solution: 'T',
    points: 2,
  ),

  Question(
    solution: 'B',
    points: 2,
  ),
  Question(
    solution: 'T',
    points: 2,
  ),
  Question(
    solution: 'R',
    points: 3,
  ),
  Question(
    solution: 'T',
    points: 3,
  ),
  Question(
    solution: 'L',
    points: 3,
  ),
];

final String contrastTestQuestion = 'Choose corresponding arrow option indicating the direction of the open side of the \'C\'.';
final List<Question> contrastTestQuestionAnswer = [
  Question(
    solution: 'L',
  ),
  Question(
    solution: 'T',
  ),
  Question(
    solution: 'B',
  ),
  Question(
    solution: 'T',
  ),
  Question(
    solution: 'B',
  ),
  Question(
    solution: 'R',
  ),
  Question(
    solution: 'L',
  ),
  Question(
    solution: 'R',
  ),
  Question(
    solution: 'L',
  ),
  Question(
    solution: 'T',
  ),
];

final String colorBlindTestQuestion = 'Choose appropriate option out of given 4 corresponding to the number shown in the image.';
  final List<Question> colorBlindTestQuestionAnswer = [
  Question(
    solution: '12',
    points: 1,
    option1: '13',
    option2: '12',
    option3: '19',
    option4: 'None',
  ),
  Question(
    solution: '29',
    points: 2,
    option1: '18',
    option2: '68',
    option3: '29',
    option4: 'None',
  ),
  Question(
    solution: '15',
    points: 2,
    option1: '15',
    option2: '78',
    option3: '19',
    option4: 'None',
  ),
  Question(
    solution: '97',
    points: 2,
    option1: '19',
    option2: '69',
    option3: '97',
    option4: 'None',
  ),
  Question(
    solution: '16',
    points: 2,
    option1: '76',
    option2: '18',
    option3: '16',
    option4: 'None',
  ),
  Question(
    solution: 'None',
    points: 3,
    option1: '69',
    option2: '27',
    option3: '13',
    option4: 'None',
  ),
];

final String astigmatismQuestion = 'How does the lines in the image looks like?';
final Question astigmatismQuestionAnswer = Question(
  points: 5,
  option1: 'Perfect',
  option2: 'Blurry',
  option3: 'Curved',
  option4: 'Can\'t See',
);

final List<String> earQuestions = [
  'Do you sometimes find it challenging to have a conversation in quiet surroundings?',
  'Do you find it difficult to understand speech on TV and radio?',
  'Do you often have to ask people to repear themselves?',
  'Do you find it hard to have a conversation on the phone?',
  'Do you sometimes have difficulty understanding speech on the telephone or TV?',
  'Do you sometimes feel people are mumbling or not speaking clearly?',
  'Do you find it difficult to follow a conversation in a noisy restaurant or crowded room?',
];

final String soundQuestion1 = 'How many times the sound repeats?';
final String soundQuestion2 = 'Can you hear the sound?';
