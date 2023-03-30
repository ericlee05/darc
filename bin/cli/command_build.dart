import 'dart:async';
import 'dart:io';
import 'package:args/command_runner.dart';
import '../engine/BuildEngine.dart';

class BuildCommand extends Command {
  @override
  String get name => "build";

  @override
  String get description => "Build darc project.";

  BuildCommand() {
    argParser.addOption("compiler", abbr: "c", defaultsTo: "g++", help: "Compiler name");
    argParser.addOption("debug", abbr: "d", help: "Build binary as debuggable");
  }

  @override
  FutureOr? run() {
    BuildEngine.engines["pennon"]?.build(argResults!["compiler"], Directory.current);
  }
}