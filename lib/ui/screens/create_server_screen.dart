// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:termichat/io/app_manager.dart';
import 'package:termichat/io/app_style.dart';
import 'package:termichat/io/server_manager.dart';
import 'package:termichat/ui/screens/chat_screen.dart';

bool messageCachingEnabled = false;
int limit = -1;
dynamic serverConfig = {};

class CreateServerScreen extends StatelessWidget {
  CreateServerScreen({super.key});

  TextEditingController serverNameField = TextEditingController();
  TextEditingController hostNameField = TextEditingController();
  TextEditingController portNameField = TextEditingController();
  TextEditingController allowedUsersField = TextEditingController();
  TextEditingController blockedUsersField = TextEditingController();
  TextEditingController serverCodeField = TextEditingController();

  bool validate(BuildContext context, {displayLog=true}) {
    String serverName = serverNameField.text;
    String hostAddress = hostNameField.text;
    String port = portNameField.text;
    String allowedUsersText = allowedUsersField.text;
    String blockedUsersText = blockedUsersField.text;
    String serverCode = serverCodeField.text;

    // validating server configurations

    List<Widget> logWidgets = [];

    if (serverName.isEmpty) {
      logWidgets.add(Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Server name cannot be empty!",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ));
      logWidgets.add(const SizedBox(height: 5));
    }
    if (hostAddress.isEmpty) {
      logWidgets.add(Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Host Address is a required field, ex: 192.86.54.102",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ));
      logWidgets.add(const SizedBox(height: 5));
    }
    if (port.isEmpty) {
      logWidgets.add(Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Port is a required field, ex: 8088",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ));
      logWidgets.add(const SizedBox(height: 5));
    }
    if (serverCode.isEmpty) {
      logWidgets.add(Container(
        decoration: BoxDecoration(
          color: Colors.amber.shade800,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "WARNING: You didn't provided a Server Code, Anyone with your host address and port can attempt to join the server!",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ));
      logWidgets.add(const SizedBox(height: 5));
    }
    if (logWidgets.isNotEmpty && displayLog) {
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          barrierColor: AppStyle.neoDarkShadowColor,
          builder: (context) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: logWidgets,
                ),
              ),
            );
          });
    }
    return logWidgets.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: AppStyle.textColor,
                          size: 20,
                        ),
                        splashRadius: 20,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Create and host your own server",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () async {
                                bool validationResult = validate(context);
                                if(!validationResult){
                                  return;
                                }
                                String? path = await FilesystemPicker.open(
                                  theme: FilesystemPickerTheme(
                                    backgroundColor: AppStyle.backgroundColor,
                                    messageTextStyle: TextStyle(
                                      color: AppStyle.textColor,
                                      fontSize: 12,
                                    ),
                                    topBar: FilesystemPickerTopBarThemeData(
                                      backgroundColor: AppStyle.neoBackgroundColor,
                                      foregroundColor: AppStyle.textColor,
                                      shadowColor: AppStyle.neoDarkShadowColor,
                                      titleTextStyle: TextStyle(
                                        color: AppStyle.textColor,
                                      ),
                                      iconTheme: IconThemeData(
                                        size: 20,
                                        color: AppStyle.textColor
                                      ),
                                    ),
                                  ),
                                  title: 'Pick a folder to save the config',
                                  context: context,
                                  rootDirectory: Directory(Platform.environment['HOME'] as String),
                                  fsType: FilesystemType.folder,
                                  pickText: 'Save config to this folder',
                                );
                                if(path != null){
                                  String config = const JsonEncoder.withIndent("  ").convert({
                                    "name": serverNameField.text,
                                    "host-address": hostNameField.text,
                                    "hosting-port": portNameField.text,
                                    "owner-id": AppManager.getOwnerID(),
                                    "connections-limit": limit,
                                    "allowed-users-list": allowedUsersField.text.isNotEmpty ? allowedUsersField.text.split(',').map((id) => id.trim()).toList() : [],
                                    "blocked-users-list": blockedUsersField.text.isNotEmpty ? blockedUsersField.text.split(',').map((id) => id.trim()).toList() : [],
                                    "push-previous-messages-to-new-users": messageCachingEnabled,
                                    "server-code": serverCodeField.text
                                  });
                                  File("$path/server-config.json").writeAsStringSync(config, flush: true);
                                }
                              },
                              tooltip: "Save Config",
                              icon: const Icon(
                                Icons.save,
                                color: Colors.blueGrey,
                              ),
                              splashRadius: 20,
                            ),
                            IconButton(
                              onPressed: () async {
                                String? path = await FilesystemPicker.open(
                                  theme: FilesystemPickerTheme(
                                    backgroundColor: AppStyle.backgroundColor,
                                    messageTextStyle: TextStyle(
                                      color: AppStyle.textColor,
                                      fontSize: 12,
                                    ),
                                    topBar: FilesystemPickerTopBarThemeData(
                                      backgroundColor: AppStyle.neoBackgroundColor,
                                      foregroundColor: AppStyle.textColor,
                                      shadowColor: AppStyle.neoDarkShadowColor,
                                      titleTextStyle: TextStyle(
                                        color: AppStyle.textColor,
                                      ),
                                      iconTheme: IconThemeData(
                                          size: 20,
                                          color: AppStyle.textColor
                                      ),
                                    ),
                                  ),
                                  title: 'Pick a server config file',
                                  context: context,
                                  rootDirectory: Directory(Platform.environment['HOME'] as String),
                                  fsType: FilesystemType.file,
                                  pickText: 'Pick this one',
                                );
                                if(path != null){
                                  dynamic config = jsonDecode(File(path).readAsStringSync());
                                  serverNameField.text = config['name'];
                                  hostNameField.text = config['host-address'];
                                  portNameField.text = config['hosting-port'].toString();
                                  serverCodeField.text = config['server-code'];
                                  allowedUsersField.text = config['allowed-users-list'].join(",");
                                  blockedUsersField.text = config['blocked-users-list'].join(",");
                                  messageCachingEnabled = config['push-previous-messages-to-new-users'];
                                  limit = config['connections-limit'];
                                }
                              },
                              tooltip: "Load Config",
                              icon: const Icon(
                                Icons.file_open,
                                color: Colors.blueGrey,
                              ),
                              splashRadius: 20,
                            ),
                            IconButton(
                              onPressed: () async {
                                bool validationResult = validate(context);
                                if(validationResult) {
                                  File('temp-config.json').writeAsStringSync(jsonEncode(serverConfig = {
                                    "name": serverNameField.text,
                                    "host-address": hostNameField.text,
                                    "hosting-port": int.parse(portNameField.text),
                                    "owner-id": AppManager.getOwnerID(),
                                    "connections-limit": limit,
                                    "allowed-users-list": allowedUsersField.text.isNotEmpty ? allowedUsersField.text.split(',').map((id) => id.trim()).toList() : [],
                                    "blocked-users-list": blockedUsersField.text.isNotEmpty ? blockedUsersField.text.split(',').map((id) => id.trim()).toList() : [],
                                    "push-previous-messages-to-new-users": messageCachingEnabled,
                                    "server-code": serverCodeField.text
                                  }), flush: true);
                                  await startServer();
                                  Future.delayed(const Duration(seconds: 2), () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnerChatScreen())));
                                }
                              },
                              tooltip: "Create Server",
                              icon: const Icon(
                                Icons.done_outline_rounded,
                                color: Colors.blue,
                              ),
                              splashRadius: 20,
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 100,
                    decoration: BoxDecoration(
                      color: AppStyle.neoBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppStyle.neoLightShadowColor,
                          blurRadius: 16,
                          offset: const Offset(-9, -9),
                        ),
                        BoxShadow(
                          color: AppStyle.neoDarkShadowColor,
                          blurRadius: 16,
                          offset: const Offset(9, 9),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    "Server Name",
                                    style: TextStyle(
                                        color: AppStyle.textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 200,
                                height: 40,
                                child: TextField(
                                  controller: serverNameField,
                                  style: TextStyle(
                                    color: AppStyle.textColor,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Enter Server name",
                                    hintStyle: TextStyle(
                                        color: AppStyle.textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 5),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    "Address",
                                    style: TextStyle(
                                        color: AppStyle.textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 100,
                                height: 40,
                                child: TextField(
                                  controller: hostNameField,
                                  style: TextStyle(
                                    color: AppStyle.textColor,
                                    fontSize: 12,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "ex: 127.0.0.1",
                                    hintStyle: TextStyle(
                                      color: AppStyle.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    "Port",
                                    style: TextStyle(
                                        color: AppStyle.textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 95,
                                height: 40,
                                child: TextField(
                                  controller: portNameField,
                                  style: TextStyle(
                                    color: AppStyle.textColor,
                                    fontSize: 12,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "ex: 8080",
                                    hintStyle: TextStyle(
                                      color: AppStyle.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 5),
                          child: Row(
                            children: [
                              Text(
                                "Connections Limit",
                                style: TextStyle(
                                  color: AppStyle.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 200,
                                height: 40,
                                child: SpinBox(
                                  iconColor: MaterialStateColor.resolveWith(
                                      (states) => AppStyle.textColor),
                                  textStyle: TextStyle(
                                    fontSize: 12,
                                    color: AppStyle.textColor,
                                  ),
                                  min: -1,
                                  max: 1000,
                                  acceleration: 1,
                                  textAlign: TextAlign.center,
                                  onChanged: (value) {
                                    limit = value.toInt();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Allowed Users List",
                                style: TextStyle(
                                  color: Colors.blue.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 250,
                                height: 40,
                                child: TextField(
                                  controller: allowedUsersField,
                                  style: TextStyle(
                                    color: AppStyle.textColor,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "ex: jerry, max",
                                    hintStyle: TextStyle(
                                      color: AppStyle.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Blocked Users List",
                                style: TextStyle(
                                  color: Colors.red.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 250,
                                height: 40,
                                child: TextField(
                                  controller: blockedUsersField,
                                  style: TextStyle(
                                    color: AppStyle.textColor,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "ex: steven, john",
                                    hintStyle: TextStyle(
                                      color: AppStyle.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 5),
                          child: Row(
                            children: [
                              Text(
                                "Enable Message Cache",
                                style: TextStyle(
                                  color: AppStyle.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              StatefulBuilder(
                                builder: (context, setState) {
                                  return Checkbox(
                                    value: messageCachingEnabled,
                                    onChanged: (value) {
                                      setState(() => messageCachingEnabled =
                                          value as bool);
                                    },
                                  );
                                },
                              ),
                              const SizedBox(width: 20),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade800,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    "Server Code",
                                    style: TextStyle(
                                        color: AppStyle.textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 100,
                                height: 40,
                                child: TextField(
                                  controller: serverCodeField,
                                  obscureText: true,
                                  style: TextStyle(
                                    color: AppStyle.textColor,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "ex: #devs-only",
                                    hintStyle: TextStyle(
                                        color: AppStyle.textColor,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: MoveWindow(),
          )
        ],
      ),
    );
  }
}
