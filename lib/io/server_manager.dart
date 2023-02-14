
import 'dart:convert';
import 'dart:io';

late Process serverProcess;

Future<void> startServer() async {
  serverProcess = await Process.start('dart', ['core/internal/server.dart', 'temp-config.json']);
  serverProcess.stdout.transform(utf8.decoder).forEach((line) {
    print(line);
  });
}

