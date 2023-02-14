
import 'package:flutter/material.dart';
import 'package:termichat/io/app_manager.dart';
import 'package:termichat/io/app_style.dart';
import 'package:termichat/main.dart';
import 'package:termichat/ui/screens/create_server_screen.dart';
import 'package:termichat/ui/screens/join_server_screen.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () async {
            await AppManager.setUsername(usernameField.text);
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateServerScreen()));
          },
          style: TextButton.styleFrom(
              backgroundColor: Colors.grey.withOpacity(0.3),
              foregroundColor: Colors.white
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Create Server",
              style: TextStyle(
                fontSize: 16,
                color: AppStyle.textColor
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () async {
            await AppManager.setUsername(usernameField.text);
            Navigator.push(context, MaterialPageRoute(builder: (context) => JoinServerScreen()));
          },
          style: TextButton.styleFrom(
              backgroundColor: Colors.grey.withOpacity(0.3),
              foregroundColor: Colors.white
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "Join Server",
              style: TextStyle(
                fontSize: 16,
                  color: AppStyle.textColor
              ),
            ),
          ),
        ),
      ],
    );
  }

}

