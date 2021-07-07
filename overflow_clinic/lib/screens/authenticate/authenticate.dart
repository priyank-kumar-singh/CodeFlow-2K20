import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:overflow_clinic/services/authentication.dart';
import 'package:overflow_clinic/shared/constants.dart';
import 'package:overflow_clinic/themes/decoration.dart';
import 'package:overflow_clinic/widgets/buttons.dart';
import 'package:overflow_clinic/widgets/login_form.dart';
import 'package:overflow_clinic/widgets/login_form_web.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  /// Denotes the currentScreen `true` means signin and `false` means register
  bool _currentScreen = true;

  bool _isLoading = false;

  BuildContext _scaffoldContext;

  String email, password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleSwitchingSigninAndRegister() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {
      _currentScreen = !_currentScreen;
      _formKey.currentState.reset();
    });
  }

  void _handleSignInRequest() {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    AuthenticationService(
      email: email,
      password: password,
      waiting: (bool x) => setState(() => _isLoading = x),
    ).getUserSignInWithEmailAndPassword(_scaffoldContext);
  }

  void _handleRegisterRequest() {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    AuthenticationService(
      email: email,
      password: password,
      waiting: (bool x) => setState(() => _isLoading = x),
    ).getRegisterNewUserWithEmailAndPassword(_scaffoldContext);
  }

  Widget _buildWebBasedUI(BuildContext context) {
    return Container(
      color: kDefaultThemeColor,
      height: double.infinity,
      child: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome To HackOverflow Clinic',
                      style: kDefaultHeaderTextStyle.copyWith(
                        fontSize: 40.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 48.0,
                    ),
                  ],
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 30.0),
                      child: CircleAvatar(
                        backgroundColor: kThemeGroundColor,
                        backgroundImage: AssetImage('$kAssetImages/logo.png'),
                        radius: 100.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0))
                        ),
                        shadowColor: Colors.grey,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              WebRegistrationAndLoginForm(
                                email: (value) => email = value,
                                password: (value) => password = value,
                              ),
                              SubmitButton(
                                title: _currentScreen ? 'SignIn' : 'Register',
                                onPressed: _currentScreen
                                    ? _handleSignInRequest
                                    : _handleRegisterRequest,
                              ),
                              SizedBox(
                                height: 24.0,
                              ),
                              Wrap(
                                children: [
                                  Text(
                                    _currentScreen
                                        ? 'Don\'t have an account? '
                                        : 'Already have an account? ',
                                    style: kDefaultTextStyle,
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      _currentScreen
                                          ? 'Register Now'
                                          : 'SignIn Now',
                                      style: kDefaultTextStyle.copyWith(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    onTap: _handleSwitchingSigninAndRegister,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 80.0,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneBasedUI(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome To HackOverflow Clinic',
            style: kDefaultHeaderTextStyle,
            textAlign: TextAlign.center,
          ),
          Flexible(
            child: SizedBox(
              height: 48.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: kThemeGroundColor,
                backgroundImage: AssetImage('$kAssetImages/logo.png'),
                radius: 50.0,
              ),
            ],
          ),
          Flexible(
            child: SizedBox(
              height: 48.0,
            ),
          ),
          Form(
            key: _formKey,
            child: RegistrationAndLoginForm(
              email: (value) => email = value,
              password: (value) => password = value,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SubmitButton(
                title: _currentScreen ? 'SignIn' : 'Register',
                onPressed:
                    _currentScreen ? _handleSignInRequest : _handleRegisterRequest,
              ),
            ],
          ),
          Flexible(
            child: SizedBox(
              height: 48.0,
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text(
                _currentScreen
                    ? 'Don\'t have an account? '
                    : 'Already have an account? ',
                style: kDefaultTextStyle,
              ),
              GestureDetector(
                child: Text(
                  _currentScreen ? 'Register Now' : 'SignIn Now',
                  style: kDefaultTextStyle.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: _handleSwitchingSigninAndRegister,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        body: SafeArea(
          child: Builder(
            builder: (context) {
              _scaffoldContext = context;
              return kIsWeb
                  ? _buildWebBasedUI(context)
                  : _buildPhoneBasedUI(context);
            },
          ),
        ),
      ),
    );
  }
}
