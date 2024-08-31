import 'package:adhe/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController vocController = TextEditingController();
  final TextEditingController transController = TextEditingController();
  final TextEditingController posController = TextEditingController();

  late final Box box;

  void openwrodaddbox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
            child: Container(
                constraints: const BoxConstraints(
                    maxHeight: 300,
                    maxWidth: 300,
                    minHeight: 300,
                    minWidth: 300),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: vocController,
                      autofocus: true,
                      decoration: const InputDecoration(
                          labelText: "Vocabulary", hintText: "apple"),
                    ),
                    TextField(
                      controller: transController,
                      decoration: const InputDecoration(
                          labelText: "Translation", hintText: "蘋果"),
                    ),
                    TextField(
                      controller: posController,
                      decoration: const InputDecoration(
                          labelText: "Part of Speech", hintText: "n"),
                    )
                  ],
                ))), //TextField(controller: textController),
        actions: [
          // Sequence Add
          ElevatedButton(
            onPressed: () {
              vocController.clear();
              transController.clear();
              posController.clear();
              Navigator.pop(context);
            },
            child: const Text("Sequence Add"),
          ),
          // Add
          ElevatedButton(
            onPressed: () {
              // add
              if (docID == null) {
                firestoreService.addword(vocController.text,
                    transController.text, posController.text);
              }

              // update
              else {
                firestoreService.updateWord(docID, vocController.text,
                    transController.text, posController.text);
              }
              vocController.clear();
              transController.clear();
              posController.clear();
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    box = Hive.box('localwords');
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        backgroundColor: Colors.yellow[200],
        appBar: AppBar(
          title: const Text("voc list"),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              splashRadius: 25,
              icon: const Icon(Icons.add),
              tooltip: 'add voc',
              onPressed: openwrodaddbox,
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getwordStream(),
          builder: (context, snapshot) {
            //if have data
            if (snapshot.hasData) {
              List wordList = snapshot.data!.docs;

              //display data
              return ListView.builder(
                  itemCount: wordList.length,
                  itemBuilder: (context, index) {
                    //get each doc
                    DocumentSnapshot document = wordList[index];
                    String docID = document.id;

                    //get vocs from doc
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    String vocText = data['voc'];

                    //display
                    return ListTile(
                      title: Text(vocText),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                          onPressed: () => openwrodaddbox(docID: docID),
                          icon: const Icon(Icons.settings),
                          splashRadius: 25,
                        ),
                        IconButton(
                          onPressed: () => firestoreService.deleteWord(docID),
                          icon: const Icon(Icons.delete),
                          splashRadius: 25,
                        )
                      ]),
                    );
                  });
            }

            //if no data
            else {
              return const Text("No texts...");
            }
          },
        ));
  }
}
