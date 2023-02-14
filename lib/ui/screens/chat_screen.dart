import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:termichat/core/internal/client.dart';
import 'package:termichat/io/app_manager.dart';
import 'package:termichat/ui/screens/create_server_screen.dart';

import '../../core/data/user.dart';
import '../../io/app_style.dart';

class OwnerChatScreen extends StatefulWidget {

  const OwnerChatScreen({super.key});

  @override
  State<OwnerChatScreen> createState() => _OwnerChatScreenState();
}

class _OwnerChatScreenState extends State<OwnerChatScreen> {
  late Client client;
  List<Widget> messages = [];
  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    client = ClientSubscription.create((message) {
      setState(() {
        messages.add(Container(
          decoration: BoxDecoration(
            color: AppStyle.backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 12
              ),
            ),
          ),
        ));
        messages.add(const SizedBox(height: 5));
        scrollController.animateTo(
            scrollController.positions.last.maxScrollExtent + 100,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInCubic);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: MediaQuery.of(context).size.height - 100,
                decoration: BoxDecoration(
                  color: AppStyle.neoBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: AppStyle.neoLightShadowColor,
                        blurRadius: 16,
                        offset: const Offset(-9, -9)
                    ),
                    BoxShadow(
                        color: AppStyle.neoDarkShadowColor,
                        blurRadius: 16,
                        offset: const Offset(9, 9)
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: messages,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                color: AppStyle.backgroundColor,
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: messageController,
                        textInputAction: TextInputAction.none,
                        style: TextStyle(
                          color: AppStyle.textColor,
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            client.send(value);
                            messages.add(Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          color: AppStyle.textColor,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ));
                            messages.add(const SizedBox(height: 5));
                            scrollController.animateTo(
                                scrollController.positions.last.maxScrollExtent + 100,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInCubic);
                            messageController.text = "";
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
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


class ClientChatScreen extends StatefulWidget {

  final String host;
  final String port;
  final String code;

  const ClientChatScreen({super.key, required this.host, required this.port, required this.code});

  @override
  State<ClientChatScreen> createState() => _ClientChatScreenState();
}

class _ClientChatScreenState extends State<ClientChatScreen> {
  late Client client;
  List<Widget> messages = [];
  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    client = ClientSubscription.connect(widget.host, widget.port, widget.code, (message) {
      setState(() {
        messages.add(Container(
          decoration: BoxDecoration(
            color: AppStyle.backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 12
              ),
            ),
          ),
        ));
        messages.add(const SizedBox(height: 5));
        scrollController.animateTo(
            scrollController.positions.last.maxScrollExtent + 100,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInCubic);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: MediaQuery.of(context).size.height - 100,
                decoration: BoxDecoration(
                  color: AppStyle.neoBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: AppStyle.neoLightShadowColor,
                        blurRadius: 16,
                        offset: const Offset(-9, -9)
                    ),
                    BoxShadow(
                        color: AppStyle.neoDarkShadowColor,
                        blurRadius: 16,
                        offset: const Offset(9, 9)
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: messages,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                color: AppStyle.backgroundColor,
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: messageController,
                        textInputAction: TextInputAction.none,
                        style: TextStyle(
                          color: AppStyle.textColor,
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            client.send(value);
                            messages.add(Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          color: AppStyle.textColor,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ));
                            messages.add(const SizedBox(height: 5));
                            scrollController.animateTo(
                                scrollController.positions.last.maxScrollExtent + 100,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInCubic);
                            messageController.text = "";
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
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


class ClientSubscription {
  static Client create(listener) {
    return Client(
        "${serverConfig['host-address']}:${serverConfig['hosting-port']}",
        User(uniqueID: AppManager.getUsername(), serverCode: serverConfig['server-code']),
        listener);
  }
  static Client connect(String host, String port, String serverCode, listener) {
    return Client(
        "$host:$port",
        User(uniqueID: AppManager.getUsername(), serverCode: serverCode),
        listener);
  }
}
