import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:overflow_clinic/models/score.dart';
import 'package:overflow_clinic/shared/constants.dart';
import 'package:overflow_clinic/shared/functions.dart';
import 'package:overflow_clinic/shared/handlers.dart';
import 'package:overflow_clinic/shared/routes.dart';
import 'package:overflow_clinic/services/firestore.dart';
import 'package:overflow_clinic/widgets/common.dart';
import 'package:overflow_clinic/widgets/tiles.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  void handleDownload(BuildContext context, Map report) {
    CheckupScores _score = CheckupScores(
      type          : report['type'],
      visionAcuity  : report['vision'],
      contrast      : report['contrast'],
      colorBlindness: report['colorBlind'],
      astigmatism   : report['astigmatism'],
      ears          : report['ear'],
    );
    Provider.of<FirestoreService>(context, listen: false).copyCheckupScoreDataInProviderCache(_score);
    Navigator.pushNamed(context, resultsScreen);
  }

  void handleRemove(BuildContext context, String uid) async {
    dynamic result = await Provider.of<FirestoreService>(context, listen: false).deleteCheckupReportFromFirestoreDatabase(uid);
    if (result.code == '1') {
      handleSnackBar(context: context, message: result.message, duration: 1000);
      setState(() {});
    }
    else
      handleSnackBar(context: context, message: result.message, duration: 1000);
  }

  @override
  Widget build(BuildContext context) {
    final String _uid = Provider.of<FirestoreService>(context).uid;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: kUsersCollectionReference.document(_uid).collection('reports').orderBy('timestamp', descending: true).getDocuments().asStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }
          try {
            final List<DocumentSnapshot> reports = snapshot.data.documents;
            if (reports.isEmpty)
              throw 'No Previous Reports';
            return ListView.builder(
              itemCount: reports.length,
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 20.0),
              itemBuilder: (context, index) {
                return ReportHistoryTile(
                  title: reports[index].data['type'] == 0 ? 'Eye Checkup' : 'Ear Checkup',
                  subtitle: convertTimestampToDateTime(reports[index].data['timestamp']),
                  download: () => handleDownload(context, reports[index].data),
                  remove: () => handleRemove(context, reports[index].documentID),
                );
              }
            );
          } catch (_) {
            return CenterHeaderText('No Checkup History');
          }
        },
      ),
    );
  }
}
