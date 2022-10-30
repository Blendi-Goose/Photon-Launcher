import 'dart:io';
import 'package:path/path.dart' as path;

class VersionManager {
  static final instance = VersionManager();

  bool hasVersionDirectory() {
    return Directory('versions').existsSync();
  }

  void makeVersionDirectory() {
    if (hasVersionDirectory()) return;
    Directory('versions').createSync();
  }

  bool hasVersion(String v) {
    if (!hasVersionDirectory()) return false;
    final fileName = v.hashCode.toString();

    return File(path.join('versions', '$fileName.love')).existsSync();
  }

  String getFileName(String v) {
    final fileName = v.hashCode.toString();

    return path.join('.', 'versions', '$fileName.love');
  }

  Future<ProcessResult> runVersion(String v) {
    return Process.run('love', [getFileName(v)], runInShell: true);
  }
}
