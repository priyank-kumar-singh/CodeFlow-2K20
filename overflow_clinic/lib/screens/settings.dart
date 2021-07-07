import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:overflow_clinic/services/firestore.dart';
import 'package:overflow_clinic/shared/constants.dart';
import 'package:overflow_clinic/shared/handlers.dart';
import 'package:overflow_clinic/themes/decoration.dart';
import 'package:overflow_clinic/widgets/tiles.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String name;
  String dob;
  int age;
  bool loading = false;

  void waiting(bool x) {
    setState(() => loading = x);
  }

  @override
  Widget build(BuildContext context) {
    name = Provider.of<FirestoreService>(context).name;
    dob = Provider.of<FirestoreService>(context).dob;
    age = Provider.of<FirestoreService>(context).age;
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Builder(
          builder: (context) => Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.greenAccent[100],
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Image(
                              image: AssetImage('$kAssetImages/logo.png'),
                            ),
                          ),
                          radius: 35.0,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Flexible(
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$name',
                                style: kDefaultHeaderTextStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                'Age: $age, DOB: $dob',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 14.0,
                    ),
                    Divider(
                      height: 0.0,
                    ),
                    SettingsMenuItemTile(
                      title: 'Change Name',
                      action: () => handleChangeName(context, name),
                    ),
                    Divider(
                      height: 0.0,
                    ),
                    SettingsMenuItemTile(
                      title: 'Change Date of Birth',
                      action: () => handleChangeDOB(context, dob),
                    ),
                    Divider(
                      height: 0.0,
                    ),
                    SettingsMenuItemTile(
                      title: 'Update Email',
                      action: () => handleChangeEmail(context, waiting),
                    ),
                    Divider(
                      height: 0.0,
                    ),
                    SettingsMenuItemTile(
                      title: 'Update Password',
                      action: () => handleChangePassword(context, waiting),
                    ),
                    Divider(
                      height: 0.0,
                    ),
                    SettingsMenuItemTile(
                      title: 'Sign Out',
                      action: () => handleSignOutBottomSheet(context, waiting),
                    ),
                  ],
                ),
                Image(
                  image: AssetImage(
                    'assets/images/team.png',
                  ),
                  height: 60.0,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
