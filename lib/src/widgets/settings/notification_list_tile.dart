import 'package:flutter/material.dart';

class NotificationSwitchListTile extends StatefulWidget {
  const NotificationSwitchListTile({
    super.key,
  });

  @override
  State<NotificationSwitchListTile> createState() =>
      _NotificationSwitchListTileState();
}

class _NotificationSwitchListTileState
    extends State<NotificationSwitchListTile> {
  bool _enabled = true;

  @override
  void initState() {
    // final flag = getPushSubsciption();
    // setState(() {
    //   _enabled = flag ?? false;
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      value: _enabled,
      onChanged: (newValue) async {
        setState(() {
          _enabled = newValue;
        });
        // await disablePush(!newValue);
      },
      secondary: const Icon(Icons.notifications_outlined),
      title: const Text('Notification'),
      subtitle: const Text('Push notifications'),
    );
  }
}
