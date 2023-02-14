
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:termichat/io/app_style.dart';
import 'package:termichat/ui/screens/chat_screen.dart';

class JoinServerScreen extends StatelessWidget{
  JoinServerScreen({super.key});

  TextEditingController hostNameField = TextEditingController();
  TextEditingController portNameField = TextEditingController();
  TextEditingController serverCodeField = TextEditingController();

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
                        "Join a running Server",
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ClientChatScreen(host: hostNameField.text, port: portNameField.text, code: serverCodeField.text)));
                              },
                              tooltip: "Connect",
                              icon: const Icon(
                                Icons.private_connectivity,
                                color: Colors.blue,
                              ),
                              iconSize: 36,
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
          Align(
            alignment: Alignment.center,
            child: MoveWindow(),
          ),
        ],
      ),
    );
  }

}
