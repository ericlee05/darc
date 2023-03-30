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
      original = Path.join(Directory.current.path, original);
    }

    return original;
  }

  ProjectField getProjectInfo() {
    return ProjectField(_yaml["name"] as String,
        _yaml["author"] as String,
        _yaml["version"] as String);
  }

  List<DependencyField> getDependencies() {
    List<DependencyField> dependencies = List.empty(growable: true);
    for (final element in _yaml["dependency"]) {
      String include = _convertIncludeAndLink(element["include"] as String);
      String link = _convertIncludeAndLink(element["link"] as String);

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
  String include;
  String link;
  DependencyField(this.include, this.link);
}