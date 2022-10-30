import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:photon_launcher/data/version_manager.dart';

const String apiURL = "https://PhotonVersionRepo.bledniappel.repl.co";

class APIData {
  int status;
  String content;

  APIData(this.status, this.content);

  bool get errored => status >= 400;
  bool get crash => status >= 500;
  bool get ok => status == 200;
}

class APIManager {
  final dio = Dio();

  static final instance = APIManager();

  APIData? _cache;

  Future<APIData> getAPIData([CancelToken? token]) {
    if (_cache != null) return Future.value(_cache);
    return dio.get(apiURL, cancelToken: token).then((value) {
      _cache = APIData(value.statusCode ?? 404, value.data);
      return _cache!;
    });
  }

  Future download(String version, [CancelToken? cancelToken]) async {
    final data = await getAPIData(cancelToken);

    final dataMap = jsonDecode(data.content);

    if (dataMap["versions"] != null) {
      if (dataMap["versions"][version] != null) {
        final downloadPath = dataMap["versions"][version]!;

        VersionManager.instance.makeVersionDirectory();
        return dio.download(downloadPath, VersionManager.instance.getFileName(version), cancelToken: cancelToken);
      }
    }

    return null;
  }

  List<String> get currentVersions {
    if (_cache == null) return [];

    final dataMap = jsonDecode(_cache!.content);

    return (dataMap["versions"] as Map<String, dynamic>).keys.toList();
  }
}
