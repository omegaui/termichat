import 'dart:convert';
import 'dart:io';

import '../internal/server.dart';

dynamic configuration;

void loadConfig({tempConfig}) {
  if(tempConfig != null){
    configuration = tempConfig;
    return;
  }
  configuration = jsonDecode(File(serverConfigPath).readAsStringSync());
}
