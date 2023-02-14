
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:termichat/io/app_manager.dart';
import 'package:termichat/ui/screens/home_screen.dart';

import 'io/app_style.dart';

late TextEditingController usernameField; 

void rebuildApp(){

}

void main() async {
  await AppManager.initAppData();
  // AppStyle.switchTheme();
  runApp(const App());

  doWhenWindowReady(() {
    appWindow.minSize = const Size(500, 400);
    appWindow.size = const Size(500, 400);
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: AppStyle.backgroundColor,
          body: Stack(children: [
            const Align(
              alignment: Alignment.center,
              child: HomeScreen(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(80.0),
                child: SizedBox(
                  width: 160,
                  height: 30,
                  child: TextField(
                    controller: usernameField = TextEditingController(text: AppManager.getUsername()),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Enter your username",
                      hintStyle: TextStyle(
                        color: AppStyle.textColor,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: MoveWindow(),
            ),
          ]),
        ),
      ),
    );
  }
}
