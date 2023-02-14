import 'package:colored_print/colored_print.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../data/user.dart';
import 'connection.dart';

class Client {
  late WebSocketChannel channel;
  String hostAddress;
  User user;

  Client(this.hostAddress, this.user, listener) {
    channel = connect(hostAddress, user);
    channel.stream.listen(listener);
  }

  void send(String message) {
    channel.sink.add("[${user.uniqueID}] >>>> $message");
  }
}
