import 'package:flutter/material.dart';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:example/list_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LAN Scanner Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'LAN Scanner Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Set<DeviceModel> hosts = Set<DeviceModel>();
  LanScanner scanner = LanScanner();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: buildHostsListView(hosts),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          hosts.clear();

          var stream = scanner.preciseScan(
            '192.168.0',
            progressCallback: (ProgressModel progress) {
              print('${progress.percent * 100}% 192.168.0.${progress.currIP}');
            },
          );

          stream.listen((DeviceModel device) {
            if (device.exists) {
              setState(() {
                hosts.add(device);
              });
            }
          });
        },
        tooltip: 'Start scanning',
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
