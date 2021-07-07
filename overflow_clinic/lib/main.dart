import 'package:flutter/material.dart';
import 'package:overflow_clinic/models/app.dart';
import 'package:overflow_clinic/shared/routes.dart';
import 'package:overflow_clinic/services/firestore.dart';
import 'package:overflow_clinic/themes/light.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(OverFlowClinic());
}

class OverFlowClinic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => FirestoreService(),
        ),
      ],
      child: MaterialApp(
        title: AppDetails.name,
        debugShowCheckedModeBanner: false,
        theme: kdefaultTheme,
        initialRoute: wrapper,
        routes: routes,
      ),
    );
  }
}
