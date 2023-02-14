import 'package:colored_print/colored_print.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../data/user.dart';
import 'connection.dart';

class Client {
  late WebSocketChannel channel;
  String hostAddress;
  User user;

  Client(this.hostAddress, this.user) {
    channel = connect(hostAddress, user);
    channel.stream.listen((message) {
      print(message);
    });
  }

  void send(String message) {
    channel.sink.add("[${PrintColor.blue(user.uniqueID)}] >>>> $message");
  }
}

void main(){
  Client client = Client('127.0.0.1:8088', User(uniqueID: 'omegaui', serverCode: 'code'));
}

