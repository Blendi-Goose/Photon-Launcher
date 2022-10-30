import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:photon_launcher/data/api_manager.dart';

class VersionDownloadButton extends StatelessWidget {
  final void Function(Future) onDownload;
  final CancelToken? token;
  final String v;

  const VersionDownloadButton(this.v, this.onDownload, this.token, {super.key});

  @override
  Widget build(BuildContext context) {
    final winSize = MediaQuery.of(context).size;

    return MaterialButton(
      onPressed: () {
        final future = APIManager.instance.download(v, token);
        onDownload(future);
      },
      color: Colors.green,
      child: Text("Download", style: TextStyle(fontSize: winSize.width / 40, color: Colors.white)),
    );
  }
}
