import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overflow_clinic/models/user.dart';
import 'package:overflow_clinic/services/firestore.dart';
import 'package:overflow_clinic/shared/constants.dart';
import 'package:overflow_clinic/shared/functions.dart';
import 'package:overflow_clinic/shared/handlers.dart';
import 'package:overflow_clinic/shared/routes.dart';
import 'package:overflow_clinic/widgets/common.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WrapperBody(),
    );
  }
}

class WrapperBody extends StatefulWidget {
  @override
  _WrapperBodyState createState() => _WrapperBodyState();
}

class _WrapperBodyState extends State<WrapperBody> {
  void authenticate() async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      if (user != null) {
        final internet = await checkInternetConnectivity();
        if (internet.code != '1')
          throw internet.message;
        await user.reload().timeout(Duration(seconds: 10));
        if (await documentExist(kUsersCollectionReference.document(user.uid))) {
          final snapshot = await kUsersCollectionReference.document(user.uid).get();
          final LocalUser newUser = LocalUser(
            uid: user.uid,
            email: user.email,
            name: snapshot.data['name'],
            dob: snapshot.data['dob'],
          );
          Provider.of<FirestoreService>(context, listen: false).setUser(newUser);
          Navigator.pushReplacementNamed(context, dashboard);
        }
        else {
          Provider.of<FirestoreService>(context, listen: false).signOutUser();
          Navigator.pushReplacementNamed(context, welcome);
        }
      }
      else {
        Navigator.pushReplacementNamed(context, welcome);
      }
    } on TimeoutException catch (_) {
      handleSnackBarWithRetry(context: context, message: 'Connection Timeout', action: authenticate);
    } on PlatformException catch(e) {
      handleSnackBarWithRetry(context: context, message: e.message ?? 'Unknown Platform Error', action: authenticate);
    } catch (e) {
      handleSnackBarWithRetry(context: context, message: e ?? 'Unknown Error', action: authenticate);
    }
  }

  @override
  void initState() {
    super.initState();
    authenticate();
  }

  @override
  Widget build(BuildContext context) {
    return Loading();
  }
}
