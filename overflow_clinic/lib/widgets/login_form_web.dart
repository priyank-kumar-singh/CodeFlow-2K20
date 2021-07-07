import 'package:flutter/material.dart';
import 'package:overflow_clinic/shared/validator.dart';

class WebRegistrationAndLoginForm extends StatelessWidget {
  WebRegistrationAndLoginForm({@required this.email, @required this.password});

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
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 300.0,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter your email',
            ),
            keyboardType: TextInputType.emailAddress,
            onSaved: email,
            validator: validateEmail,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        SizedBox(
          width: 300.0,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter your Password',
            ),
            onSaved: password,
            obscureText: true,
            validator: validatePassword,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 24.0,
        ),
      ],
    );
  }
}
