import 'dart:math';

import 'package:flutter/material.dart';
import 'package:photon_launcher/data/api_manager.dart';
import 'package:photon_launcher/ui/gameplay.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences storage;

void main() async {
  storage = await SharedPreferences.getInstance();
  runApp(const PhotonLauncher());
}

class PhotonLauncher extends StatelessWidget {
  const PhotonLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photon Launcher',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Photon Launcher'),
        ),
        body: const MainBody(),
      ),
    );
  }
}

class MainBody extends StatefulWidget {
  const MainBody({super.key});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  late Future<APIData> future;

  @override
  void initState() {
    future = APIManager.instance.getAPIData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<APIData>(
        future: future,
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: LayoutBuilder(builder: (ctx, constraints) {
                final imgSize = min(constraints.maxWidth, constraints.maxHeight) * 0.5;

                return SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Row(
                    children: [
                      const Spacer(),
                      Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.fill,
                        width: imgSize,
                        height: imgSize,
                        filterQuality: FilterQuality.medium,
                      ),
                      const GameplayUI(),
                      const Spacer(),
                    ],
                  ),
                );
              }),
            );
          }

          final size = MediaQuery.of(context).size;

          return Column(
            children: [
              const Spacer(),
              Row(
                children: [
                  const Spacer(),
                  Text("Loading...", style: TextStyle(fontSize: size.width / 20)),
                  const Spacer(),
                ],
              ),
              const CircularProgressIndicator.adaptive(),
              const Spacer(),
            ],
          );
        },
      ),
    );
  }
}
