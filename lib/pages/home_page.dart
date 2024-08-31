import 'package:adhe/pages/view_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void verinfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("ver 1.0.0"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("close"),
          ),
        ], //TextField(controller: textController),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: const Text("ADHE"),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            splashRadius: 25,
            icon: const Icon(Icons.info_outline),
            tooltip: 'info',
            onPressed: verinfo,
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 80), elevation: 5),
              child: const Text("Fetch"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const ViewPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 80), elevation: 5),
              child: const Text(
                "View",
              ),
            ),
            //ElevatedButton(
            //  onPressed: () {},
            //  style: ElevatedButton.styleFrom(
            //      textStyle: const TextStyle(fontSize: 80), elevation: 5),
            //  child: const Text("Test"),
            //),
          ],
        ),
      ),
    );
  }
}
