import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:process_run/shell.dart';

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

  Future<List<File>> buildSources(String compiler, Directory temporary, List<FileSystemEntity> sources, ConfigurationReader configuration) async {
    Shell compilerShell = Shell(commandVerbose: false);

    List<File> builtFiles = List.empty(growable: true);
    for (var source in sources) {
      File builtObject = File("${source.path.split(".").sublist(0, source.path.split(".").length - 1).join(".")}.o");

      String target = "${Path.join(temporary.path, source.path.split("/").last)}.o";

      StringBuffer commandBuilder = StringBuffer("$compiler -c ${source.path}");
      for (DependencyField dependency in configuration.getDependencies()) {
        if(dependency.include != null) {
          commandBuilder.write(" -I${dependency.include}");
        }
      }

      await compilerShell.run(commandBuilder.toString());
      builtObject.copySync(target);
      builtObject.deleteSync();

      builtFiles.add(File(target));
    }

    return builtFiles;
  }

  Future<File> linkAll(String compiler, ConfigurationReader configuration, List<File> objects) async {
    String target = "${configuration.getProjectInfo().name.toLowerCase()}-${configuration.getProjectInfo().version.toLowerCase().replaceAll(" ", "-")}";
    StringBuffer commandBuilder = StringBuffer("$compiler -o $target");

    for(File object in objects) {
      commandBuilder.write(" ${object.path}");
    }

    for(DependencyField field in configuration.getDependencies()) {
      if(field.link != null) {
        String prefix = field.link!.startsWith(Path.separator) ? "-L" : "-l";
        commandBuilder.write(" $prefix${field.link}");
      }
    }

    Shell compilerShell = Shell(commandVerbose: false);
    await compilerShell.run(commandBuilder.toString());

    return File(Path.join(Directory.current.path, target));
  }

  @override
  void build(String compiler, Directory project, {bool debug = false}) async {
    ConfigurationReader config = ConfigurationReader(Path.join(project.path, "darc.yml"));

    Directory temporary = _initTemporaryDirectory(project);

    try {
      List<FileSystemEntity> sources = scanSources(project);

      List<File> objectFiles = await buildSources(compiler, temporary, sources, config);

      await linkAll(compiler, config, objectFiles);
    } catch (exception) {
      print("Built stopped.");
    } finally {
      _closeTemporaryDirectory(temporary);
    }
  }

}