import 'dart:async';
import 'package:args/command_runner.dart';

class InitCommand extends Command {
  @override
  String get name => "init";

  @override
  String get description => "Initialize this directory as darc project.";

  InitCommand() {
    argParser.addOption("name", help: "Name of project");
    argParser.addOption("author", help: "Author of project");
  }

  @override
  FutureOr? run() {
    print("done");
  }
}