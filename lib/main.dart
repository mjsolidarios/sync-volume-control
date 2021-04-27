import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Volume Controller'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _currentSliderValue = 0;

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void connectToServer() {
    print("Connecting to server....");
    Socket socket = io(
        'https://sync-volume-server.herokuapp.com:3000',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());
    socket.connect();

    socket.onConnect((_) {
      print('connect');
    });

    socket.onConnectError((data) {
      print("Connection error. ${data.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Volume"),
            Slider(
              value: _currentSliderValue,
              min: 0,
              max: 100,
              label: _currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
