import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:photon_launcher/data/api_manager.dart';
import 'package:photon_launcher/data/version_manager.dart';
import 'package:photon_launcher/main.dart';
import 'package:photon_launcher/ui/download_button.dart';
import 'package:photon_launcher/ui/play_button.dart';

class GameplayUI extends StatefulWidget {
  const GameplayUI({super.key});

  @override
  State<GameplayUI> createState() => _GameplayUIState();
}

class _GameplayUIState extends State<GameplayUI> {
  Map<String, CancelToken> cancelTokens = {};
  Map<String, Future> downloadFutures = {};
  late String current;

  @override
  void initState() {
    current = storage.getString("current") ?? APIManager.instance.currentVersions.first;
    if (!APIManager.instance.currentVersions.contains(current)) {
      current = APIManager.instance.currentVersions.first;
    }
    super.initState();
  }

  Widget getButton() {
    final size = MediaQuery.of(context).size;

    if (VersionManager.instance.hasVersion(current)) {
      return PlayVersionButton(current);
    } else {
      if (cancelTokens[current] == null) {
        cancelTokens[current] = CancelToken();
      }
      if (downloadFutures[current] == null) {
        return VersionDownloadButton(current, (future) {
          downloadFutures[current] = future;
          future.then((v) => setState(() {}));
        }, cancelTokens[current]!);
      } else {
        return MaterialButton(
          onPressed: () {
            setState(() {
              cancelTokens[current]!.cancel();
              downloadFutures[current]!.ignore();
              downloadFutures.remove(current);
            });
          },
          color: Colors.yellow,
          child: Text('Cancel', style: TextStyle(fontSize: size.width / 40)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        const Spacer(),
        SizedBox(
          width: size.width / 5,
          height: size.height / 8,
          child: Row(
            children: [
              const Spacer(),
              Text(
                "Versions:",
                style: TextStyle(fontSize: size.width / 50),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 10, height: 2),
              DropdownButton(
                  value: current,
                  items: APIManager.instance.currentVersions
                      .map(
                        (ver) => DropdownMenuItem(
                          value: ver,
                          child: Text("v $ver"),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      current = v ?? current;
                      storage.setString("current", current);
                    });
                  }),
              const Spacer(),
            ],
          ),
        ),
        getButton(),
        const Spacer(),
      ],
    );
  }
}
