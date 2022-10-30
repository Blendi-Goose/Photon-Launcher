import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photon_launcher/data/version_manager.dart';
import 'package:window_manager/window_manager.dart';

class PlayVersionButton extends StatelessWidget {
  final String v;

  const PlayVersionButton(this.v, {super.key});

  @override
  Widget build(BuildContext context) {
    final winSize = MediaQuery.of(context).size;
    return MaterialButton(
      onPressed: () async {
        if (!VersionManager.instance.hasVersion(v)) return;
        if (Platform.isWindows) {
          await windowManager.minimize();
          await VersionManager.instance.runVersion(v);
          await windowManager.maximize();
        } else {
          await windowManager.hide();
          await VersionManager.instance.runVersion(v);
          await windowManager.show();
        }
      },
      color: Colors.blue,
      child: Text("Play", style: TextStyle(fontSize: winSize.width / 40, color: Colors.white)),
    );
  }
}
