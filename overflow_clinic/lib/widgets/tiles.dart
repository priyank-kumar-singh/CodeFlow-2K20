import 'package:flutter/material.dart';

class ReportHistoryTile extends StatelessWidget {
  ReportHistoryTile({
    @required this.title,
    @required this.subtitle,
    @required this.download,
    @required this.remove,
  });

  final String title;
  final String subtitle;
  final Function download;
  final Function remove;

  final List<String> _popUpMenuItems = [
    'Download',
    'Remove',
  ];

  void handlePopupMenuItem(String option) {
    if (option == 'Download')
      download();
    else
      remove();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: PopupMenuButton(
        itemBuilder: (context) {
          return _popUpMenuItems.map((option) => PopupMenuItem(
            child: Text(option),
            value: option,
          )).toList();
        },
        onSelected: handlePopupMenuItem,
      ),
    );
  }
}

class SettingsMenuItemTile extends StatelessWidget {

  SettingsMenuItemTile({
    @required this.title,
    @required this.action,
  });

  final String title;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
      ),
      onTap: action,
    );
  }
}
