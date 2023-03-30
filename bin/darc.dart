import 'dart:io';

import 'package:args/command_runner.dart';

import 'cli/command_build.dart';
import 'cli/command_init.dart';

void main(List<String> arguments) {
  final runner = CommandRunner("darc", "Modern build tools for C/C++")
      ..addCommand(InitCommand())
      ..addCommand(BuildCommand())
      ..run(arguments).catchError((error) {
        if (error is! UsageException) throw error;
        print(error);
        exit(64);
      });
}
