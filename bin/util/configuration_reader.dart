import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:yaml/yaml.dart';

class ConfigurationReader {
  dynamic _yaml;
  ConfigurationReader(String path) {
    _yaml = loadYaml(File(path).readAsStringSync());
  }

  String _convertIncludeAndLink(String original) {
    if(original.startsWith(".")) {
      original = Path.canonicalize(Path.join(Directory.current.path, original));
    }

    return original;
  }

  ProjectField getProjectInfo() {
    return ProjectField(_yaml["project"]["name"] as String,
        _yaml["project"]["author"] as String,
        _yaml["project"]["version"] as String);
  }

  List<DependencyField> getDependencies() {
    List<DependencyField> dependencies = List.empty(growable: true);

    if(_yaml["dependency"] == null) {
      return dependencies;
    }

    for (final element in _yaml["dependency"]) {
      String? include = (element["include"] != null) ? _convertIncludeAndLink(element["include"] as String) : null;
      String? link = (element["link"] != null) ? _convertIncludeAndLink(element["link"] as String) : null;

      dependencies.add(DependencyField(include, link));
    }

    return dependencies;
  }
}

class ProjectField {
  String name;
  String author;
  String version;
  ProjectField(this.name, this.author, this.version);
}

class DependencyField {
  String? include;
  String? link;
  DependencyField(this.include, this.link);
}