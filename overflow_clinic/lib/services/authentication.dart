import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overflow_clinic/models/user.dart';
import 'package:overflow_clinic/shared/constants.dart';
import 'package:overflow_clinic/shared/routes.dart';
import 'package:overflow_clinic/services/firestore.dart';
import 'package:overflow_clinic/shared/functions.dart';
import 'package:overflow_clinic/shared/handlers.dart';
import 'package:provider/provider.dart';

class AuthenticationService {
  /// `User Email`
  final String email;

  /// `User Password`
  final String password;

  /// The `function` to trigger when `waiting` for the completion of operation
  ///
  /// This can be used to toggle states between loading and not loading
  final Function waiting;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthenticationService({
    @required this.email,
    @required this.password,
    @required this.waiting,
  });

  /// This function will sign in the user with email and password
  void getUserSignInWithEmailAndPassword(BuildContext context) async {
    waiting(true);
    try {
      final AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password).timeout(Duration(seconds: 10));
      final FirebaseUser user = result.user;
      if (user != null) {
        if (await documentExist(kUsersCollectionReference.document(user.uid))) {
          final snapshot = await kUsersCollectionReference.document(user.uid).get().timeout(Duration(seconds: 5));
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
          Navigator.pushNamed(context, addDetails);
        }
      }
      else {
        throw 'error';
      }
    } on PlatformException catch (e) {
      handleSnackBar(context: context, message: e.message ?? 'Unknown Platform Error');
    } on TimeoutException catch (_) {
      handleSnackBar(context: context, message: 'Connection Timeout');
    } on SocketException catch (e) {
      handleSnackBar(context: context, message: e.message ?? 'Unknown Socket Error');
    } catch (e) {
      handleSnackBar(context: context, message: 'Unknown error while signing in user');
    } finally {
      waiting(false);
    }
  }

  /// This function will create a new user in firebase with email and password
  void getRegisterNewUserWithEmailAndPassword(BuildContext context) async {
    waiting(true);
    try {
      final AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final FirebaseUser user = result.user;
      if (user != null)
        Navigator.of(context).pushNamed(addDetails);
      else
        throw 'error';
    } on PlatformException catch (e) {
      handleSnackBar(context: context, message: e.message ?? 'Unknown Platform Error');
    } on TimeoutException catch (_) {
      handleSnackBar(context: context, message: 'Connection Timeout');
    } on SocketException catch (e) {
      handleSnackBar(context: context, message: e.message ?? 'Unknown Socket Error');
    } catch (_) {
      handleSnackBar(context: context, message: 'Unknown error while registering new user');
    } finally {
      waiting(false);
    }
  }
}
