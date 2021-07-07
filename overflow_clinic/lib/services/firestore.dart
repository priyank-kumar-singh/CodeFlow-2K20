import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:overflow_clinic/models/message.dart';
import 'package:overflow_clinic/models/user.dart';
import 'package:overflow_clinic/models/score.dart';
import 'package:overflow_clinic/shared/constants.dart';
import 'package:overflow_clinic/shared/functions.dart';

class FirestoreService extends ChangeNotifier {
  LocalUser _currentUser = LocalUser();
  CheckupScores _checkupScores = CheckupScores();
  CheckupResults _checkupResults = CheckupResults();

  /// Get read only recent checkupScore data
  CheckupScores get checkupScore    => _checkupScores;

  /// Get read only recent checkupResult data
  CheckupResults get checkupResults => _checkupResults;

  /// Get read only curretly signed in user's uid.
  String get uid   => _currentUser.uid;

  /// Get read only curretly signed in user's name.
  String get name  => _currentUser.name;

  /// Get read only curretly signed in user's email.
  String get email => _currentUser.email;

  /// Get read only curretly signed in user's date of birth.
  String get dob   => _currentUser.dob;

  /// Get read only curretly signed in user's age.
  int get age      => _currentUser.age;

  FirebaseAuth _auth = FirebaseAuth.instance;

  /// set user data in provider cache
  void setUser(LocalUser user) => _currentUser.setUser(user);

  /// SingOut current user and clear local cached data also
  Future<void> signOutUser() async {
    try {
      await _auth.signOut();
      _currentUser.clear();
    } catch (e) {
      print(e);
    }
  }

  Future<ResultMessage> createNewUserDatabase() async {
    try {
      if (await documentExist(kUsersCollectionReference.document(_currentUser.uid))) {
        await kUsersCollectionReference.document(_currentUser.uid).updateData({
          'name': _currentUser.name,
          'dob': _currentUser.dob,
        }).timeout(Duration(seconds: 4));
      } else {
        await kUsersCollectionReference.document(_currentUser.uid).setData({
          'name': _currentUser.name,
          'dob': _currentUser.dob,
        }).timeout(Duration(seconds: 4));
      }
      return ResultMessage(code: '1', message: 'User Created Successfully');
    } on PlatformException catch (e) {
      return ResultMessage(code: '2', message: e.message ?? 'Unknown Platform Error');
    } on TimeoutException catch (_) {
      return ResultMessage(code: '3', message: 'Connection Timeout');
    } on SocketException catch (e) {
      return ResultMessage(code: '4', message: e.message ?? 'Unknown socket error');
    } catch (e) {
      return ResultMessage(code: '5', message: 'Unknown Error');
    }
  }

  void copyCheckupScoreDataInProviderCache(CheckupScores scores) {
    _checkupScores.type           = scores.type;
    _checkupScores.visionAcuity   = scores.visionAcuity;
    _checkupScores.contrast       = scores.contrast;
    _checkupScores.colorBlindness = scores.colorBlindness;
    _checkupScores.astigmatism    = scores.astigmatism;
    _checkupScores.ears           = scores.ears;
    createCheckupReportInProviderCache();
  }

  void createCheckupReportInProviderCache() {
    if (_checkupScores.type == 0) {
      if (_checkupScores.visionAcuity > 16) {
        _checkupResults.visionAcuity = 'Your Eyes are good';
      } else if (_checkupScores.visionAcuity > 12) {
        _checkupResults.visionAcuity = 'Your may need to consult a doctor';
      } else{
        _checkupResults.visionAcuity = 'Your eyes are in critical stage, consult a doctor now';
      }

      if (_checkupScores.contrast >= 9) {
        _checkupResults.contrast = 'Your Eyes are good';
      } else if (_checkupScores.contrast > 6) {
        _checkupResults.contrast = 'Your may need to consult a doctor';
      } else{
        _checkupResults.contrast = 'Your eyes are in critical stage, consult a doctor now';
      }

      if (_checkupScores.colorBlindness >= 9) {
        _checkupResults.colorBlindness = 'Your Eyes are good';
      } else if (_checkupScores.colorBlindness > 6) {
        _checkupResults.colorBlindness = 'Your may need to consult a doctor';
      } else{
        _checkupResults.colorBlindness = 'Your eyes are in critical stage, consult a doctor now';
      }

      if (_checkupScores.astigmatism == 5) {
        _checkupResults.astigmatism = 'Your Eyes are good';
      } else if (_checkupScores.astigmatism >= 3) {
        _checkupResults.astigmatism = 'Your may need to consult a doctor';
      } else{
        _checkupResults.astigmatism = 'Your eyes are in critical stage, consult a doctor now';
      }

      _checkupResults.ears = 'None';
    } else {
      if (_checkupScores.ears > 6) {
        _checkupResults.ears = 'Your Ears are good';
      } else if (_checkupScores.ears > 4) {
        _checkupResults.ears = 'Your may need to consult a doctor';
      } else {
        _checkupResults.ears = 'Your ears are in critical stage, consult a doctor now';
      }
      _checkupResults.visionAcuity = 'None';
      _checkupResults.contrast = 'None';
      _checkupResults.colorBlindness = 'None';
      _checkupResults.astigmatism = 'None';
    }
  }

  Future<ResultMessage> createCheckupReportInFirestoreDatabase() async {
    try {
      _checkupScores = _checkupScores;
      await kUsersCollectionReference.document(_currentUser.uid).collection('reports').add({
        'vision': _checkupScores.visionAcuity,
        'contrast': _checkupScores.contrast,
        'colorBlind': _checkupScores.colorBlindness,
        'astigmatism': _checkupScores.astigmatism,
        'ear': _checkupScores.ears,
        'type': _checkupScores.type,
        'timestamp': Timestamp.now(),
      }).timeout(Duration(seconds: 5));
      return ResultMessage(code: '1', message: 'Report Submitted Successfully');
    } on PlatformException catch (e) {
      return ResultMessage(code: '2', message: e.message ?? 'Unknown Platform Error');
    } on TimeoutException catch (_) {
      return ResultMessage(code: '3', message: 'Connection Timeout');
    } on SocketException catch (e) {
      return ResultMessage(code: '4', message: e.message ?? 'Unknown socket error');
    } catch (_) {
      return ResultMessage(code: '5', message: 'Unknown Error');
    }
  }

  Future<ResultMessage> deleteCheckupReportFromFirestoreDatabase(String uid) async {
    try {
      await kUsersCollectionReference.document(_currentUser.uid).collection('reports').document(uid).delete().timeout(Duration(seconds: 5));
      return ResultMessage(code: '1', message: 'Report Deleted Successfully');
    } on PlatformException catch (e) {
      return ResultMessage(code: '2', message: e.message ?? 'Unknown Platform Error');
    } on TimeoutException catch (_) {
      return ResultMessage(code: '3', message: 'Connection Timeout');
    } on SocketException catch (e) {
      return ResultMessage(code: '4', message: e.message ?? 'Unknown socket error');
    } catch (_) {
      return ResultMessage(code: '5', message: 'Unknown Error');
    }
  }

  Future<String> changeBasicInfo(String property, String content) async {
    try {
      await kUsersCollectionReference.document(_currentUser.uid).updateData({
        property: content,
      }).timeout(Duration(seconds: 2));
      if (property == 'name')
        _currentUser.name = content;
      else {
        _currentUser.dob = content;
        _currentUser.age = _currentUser.findAge(content);
      }
      notifyListeners();
      return 'Information Updated';
    } on TimeoutException catch(_) {
      return 'Connection Timeout';
    } on PlatformException catch(e) {
      return e.message ?? 'Unknown Platform Error';
    } on SocketException catch(e) {
      return e.message ?? 'Unknown socket error';
    } catch (_) {
      return 'Unknown Error';
    }
  }

  /// Update `Email` with newEmail
  ///
  /// This is a security sensitive operation requires user to have recently signed in. So it requires `AuthCredentials`
  ///
  /// AuthCredential credential = EmailAuthProvider.getCredential(email: currentEmail, password: currentPassword);
  Future<ResultMessage> updateEmail(String newEmail, AuthCredential credential) async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      await user.reauthenticateWithCredential(credential).timeout(Duration(seconds: 5));
      await user.updateEmail(newEmail).timeout(Duration(seconds: 5));
      return ResultMessage(code: '1', message: 'Email Updated Successfully');
    } on TimeoutException catch(_) {
      return ResultMessage(code: '2', message: 'Connection Timeout');
    } on PlatformException catch(e) {
      return ResultMessage(code: '3', message: e.message ?? 'Unknown Platform Error');
    } on SocketException catch (e) {
      return ResultMessage(code: '4', message: e.message ?? 'Unknown socket error');
    } catch (_) {
      return ResultMessage(code: '5', message: 'Unknown Error');
    }
  }

  /// Update `Password` with newPassword
  ///
  /// This is a security sensitive operation requires user to have recently signed in. So it requires `AuthCredentials`
  ///
  /// AuthCredential credential = EmailAuthProvider.getCredential(email: currentEmail, password: currentPassword);
  Future<ResultMessage> updatePassword(String newPassword, AuthCredential credential) async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      await user.reauthenticateWithCredential(credential).timeout(Duration(seconds: 5));
      user.updatePassword(newPassword).timeout(Duration(seconds: 5));
      return ResultMessage(code: '1', message: 'Password Updated Successfully');
    } on TimeoutException catch(_) {
      return ResultMessage(code: '2', message: 'Connection Timeout');
    } on PlatformException catch(e) {
      return ResultMessage(code: '3', message: e.message ?? 'Unknown Platform Error');
    } on SocketException catch (e) {
      return ResultMessage(code: '4', message: e.message ?? 'Unknown socket error');
    } catch (_) {
      return ResultMessage(code: '5', message: 'Unknown Error');
    }
  }
}
