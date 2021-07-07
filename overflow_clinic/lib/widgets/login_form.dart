import 'package:flutter/material.dart';
import 'package:overflow_clinic/shared/validator.dart';

class RegistrationAndLoginForm extends StatelessWidget {
  RegistrationAndLoginForm({@required this.email, @required this.password});

  /// This Function will trigger each time the value of email field changes
  ///
  /// The new value will be passed as the string parameter to the function
  final Function email;

  /// This Function will trigger each time the value of password field changes
  ///
  /// The new value will be passed as the string parameter to the function
  final Function password;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 48.0,
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter your email',
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: email,
          onSaved: email,
          validator: validateEmail,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 8.0,
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter your Password',
          ),
          onChanged: password,
          onSaved: password,
          obscureText: true,
          validator: validatePassword,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 24.0,
        ),
      ],
    );
  }
}
