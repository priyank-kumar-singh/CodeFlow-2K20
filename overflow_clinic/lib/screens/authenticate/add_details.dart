import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:overflow_clinic/models/message.dart';
import 'package:overflow_clinic/models/user.dart';
import 'package:overflow_clinic/shared/routes.dart';
import 'package:overflow_clinic/services/firestore.dart';
import 'package:overflow_clinic/themes/decoration.dart';
import 'package:overflow_clinic/shared/handlers.dart';
import 'package:overflow_clinic/widgets/buttons.dart';
import 'package:overflow_clinic/widgets/info_form.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AddDetails extends StatefulWidget {
  @override
  _AddDetailsState createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  String name, dob;
  bool _isLoading = false;
  bool _isError = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void handleSaveFormData(BuildContext context) async {
    if (!_formKey.currentState.validate())
      return null;
    _formKey.currentState.save();
    if (!_isError) {
      setState(() => _isLoading = true);
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      LocalUser newUser = LocalUser(
        uid: user.uid,
        email: user.email,
        name: name,
        dob: dob,
      );
      Provider.of<FirestoreService>(context, listen: false).setUser(newUser);
      ResultMessage result = await Provider.of<FirestoreService>(context, listen: false).createNewUserDatabase();
      setState(() => _isLoading = false);
      if (result.code != '1')
        handleSnackBar(context: context, message: result.message);
      else
        Navigator.pushNamedAndRemoveUntil(context, dashboard, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    width: kIsWeb ? 300.0: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Add your personal details-',
                            style: kDefaultHeaderTextStyle,
                          ),
                          Form(
                            key: _formKey,
                            child: PersonalDetailForm(
                              name: (value) => name = value,
                              dob: (value) => dob = value,
                              error: (value) => _isError = value,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SubmitButton(
                                onPressed: () => handleSaveFormData(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
