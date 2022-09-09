import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  http.Client client = http.Client();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ResponseItem> responses = <ResponseItem>[
    ResponseItem(true, true, "test"),
  ];
  final headers = {
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36'
  };
  final Uri uri = Uri.parse('https://m.tiktok.com/api/item/detail/?itemId=7140979180577082629');

  Future<void> _addVideDetail() async {
    try {
      for (var i = 0; i < 1000; i++) {
        var response = await widget.client.get(uri, headers: headers);

        final Map<String, dynamic> maps = jsonDecode(response.body);
        if (maps.containsKey('itemInfo')) {
          setState(() {
            var itemInfo = maps['itemInfo'];
            if (itemInfo.containsKey("itemStruct")) {
              var itemStruct = itemInfo["itemStruct"];
              var id = itemStruct["id"];
              responses.add(
                ResponseItem(true, true, id),
              );
            }
          });
        } else {
          responses.add(
            ResponseItem(false, false, "empty"),
          );
        }
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: responses.length,
          itemBuilder: (c, i) {
            final text =
                "($i) *** ${responses[i].hasItemInfo}|${responses[i].hasItemStruct}|${responses[i].id}";
            return SizedBox(
              child: Text(
                text,
                // ignore: prefer_const_constructors
                style: TextStyle(
                  color: !responses[i].hasItemInfo ? Colors.red : Colors.black,
                  fontSize: 15,
                ),
              ),
              height: 20,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addVideDetail,
        tooltip: 'Add 20',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ResponseItem {
  final bool hasItemInfo;
  final bool hasItemStruct;
  final String id;

  ResponseItem(this.hasItemInfo, this.hasItemStruct, this.id);
}
