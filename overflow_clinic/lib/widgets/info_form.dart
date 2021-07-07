import 'package:flutter/material.dart';
import 'package:overflow_clinic/themes/decoration.dart';
import 'package:overflow_clinic/shared/validator.dart';

class PersonalDetailForm extends StatefulWidget {
  PersonalDetailForm({@required this.name, @required this.dob, this.error});

  /// This Function will trigger each time the value of name field changes
  ///
  /// The new value will be passed as the string parameter to the function
  final Function name;

  /// This Function will trigger each time the value of date field changes
  ///
  /// The new value will be passed as the string parameter to the function
  final Function dob;

  /// The `error message` you get after some operation can be passed to this function
  final Function error;

  @override
  _PersonalDetailFormState createState() => _PersonalDetailFormState();
}

class _PersonalDetailFormState extends State<PersonalDetailForm> {
  String dd, mm, yy, error;

  List<String> days = [];
  List<String> months = [];
  List<String> years = [];

  void buildAge() {
    widget.dob(dd + '-' + mm + '-' + yy);
  }

  void verifyAge() {
    if (this.dd == null || this.mm == null || this.yy == null) {
      setState(() => error = 'Invalid Date');
      widget.error(true);
      return;
    }

    int dd = int.parse(this.dd);
    int mm = int.parse(this.mm);

    if ((mm <=7 && mm%2==0 && dd == 31) || (mm>=8 && mm%2!=0 && dd == 31) || (mm == 2 && dd >29)) {
      setState(() => error = 'Invalid Date');
      widget.error(true);
    } else {
      setState(() => error = null);
      widget.error(false);
      buildAge();
    }
  }

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();

    for (int i=1 ; i<=31 ; ++i)
      days.add(i.toString());

    for (int i=1 ; i<=12 ; ++i)
      months.add(i.toString());

    for (int i=today.year, j=100  ; j>0 ; --i, j--)
      years.add(i.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 24.0,
        ),
        Row(
          children: [
            Text(
              'Enter Your Name and Date of Birth',
              style: kDefaultTextStyle,
            ),
          ],
        ),
        SizedBox(
          height: 24.0,
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Your Name',
          ),
          maxLength: 20,
          onSaved: (_) => verifyAge(),
          onChanged: widget.name,
          validator: validateName,
        ),
        SizedBox(
          height: 24.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton(
              hint: Text('Day'),
              items: days.map((day) => DropdownMenuItem(
                child: Text('$day'),
                value: day,
              )).toList(),
              onChanged: (value) => setState(() => dd = value),
              value: dd,
            ),
            SizedBox(
              width: 8.0,
            ),
            DropdownButton(
              hint: Text('Month'),
              items: months.map((month) => DropdownMenuItem(
                child: Text('$month'),
                value: month,
              )).toList(),
              onChanged: (value) => setState(() => mm = value),
              value: mm,
            ),
            SizedBox(
              width: 8.0,
            ),
            DropdownButton(
              hint: Text('Year'),
              items: years.map((year) => DropdownMenuItem(
                child: Text('$year'),
                value: year,
              )).toList(),
              onChanged: (value) => setState(() => yy = value),
              value: yy,
            ),
          ],
        ),
        SizedBox(
          height: 14.0,
        ),
        Visibility(
          visible: error != '' && error != null,
          child: Text(
            '$error',
            style: kErrorMessageTextStyle,
          ),
        ),
      ],
    );
  }
}
