import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:process_run/which.dart';
import 'package:yaml/yaml.dart';

import '../../util/configuration_reader.dart';
import '../BuildEngine.dart';

class PennonEngine extends BuildEngine {
  bool _isSourceFile(FileSystemEntity entity) {
    final List<String> extensions = [ ".c", ".cpp", ".cc" ];

    if(entity.statSync().type != FileSystemEntityType.file) {
      return false;
    }

    return extensions.lastIndexWhere((element) => entity.path.endsWith(element)) != -1;
  }

  Directory _initTemporaryDirectory(Directory parent) {
    return Directory(Path.join(parent.path, ".tmp"))
      ..createSync();
  }

  void _closeTemporaryDirectory(Directory temporary) {
    temporary.delete(recursive: true);
  }

  List<FileSystemEntity> scanSources(Directory project) {
    return project.listSync(recursive: true, followLinks: false)
        .where((element) => _isSourceFile(element)).toList();
  }

  List<File> buildSources(String compiler, Directory temporary, List<FileSystemEntity> sources) {
    List<File> builtFiles = List.empty(growable: true);
    for (var source in sources) {
      String target = Path.join(temporary.path, source.path.split("/").last);
      String command = "${compiler} ";

      builtFiles.add(File(target));
    }

    return builtFiles;
  }

  @override
  void build(String compiler, Directory project, {bool debug = false}) {
    ConfigurationReader config = ConfigurationReader(Path.join(project.path, "darc.yml"));

    Directory temporary = _initTemporaryDirectory(project);

    List<FileSystemEntity> sources = scanSources(project);

    List<File> objectFiles = buildSources(compiler, temporary, sources);

    for (var element in sources) { print(element); }

    _closeTemporaryDirectory(temporary);
  }

}