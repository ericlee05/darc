import 'dart:io';

import 'pennon/pennon_engine.dart';

abstract class BuildEngine {
  void build(String compiler, Directory project, {
    bool debug = false
  });

  static final Map<String, BuildEngine> engines = Map.fromEntries([
    MapEntry("pennon", PennonEngine())
  ]);
}