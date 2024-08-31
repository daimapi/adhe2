import 'package:adhe/model/words_model.dart';
import 'package:adhe/pages/test_page.dart';
import 'package:adhe/services/hive_store.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({super.key});

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  late final Box<Words> wordbox;

  void openwrodaddbox({int? key}) {
    final TextEditingController vocController = TextEditingController();
    final TextEditingController transController = TextEditingController();
    final TextEditingController posController = TextEditingController();
    if (key != null) {
      vocController.value =
          TextEditingValue(text: HiveService().readword(key).voc);
      transController.value =
          TextEditingValue(text: HiveService().readword(key).trans);
      posController.value =
          TextEditingValue(text: HiveService().readword(key).pos);
    } else {}
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
            child: Container(
                constraints: const BoxConstraints(
                    maxHeight: 200,
                    maxWidth: 300,
                    minHeight: 100,
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
              if (key != null) {
                HiveService().deleteword(key);
              } else {}
              vocController.clear();
              transController.clear();
              posController.clear();
              Navigator.pop(context);
            },
            child: key == null
                ? const Tooltip(
                    message: "under construction", child: Text("Batch Add"))
                : const Text("Delete"),
          ),
          // Add
          ElevatedButton(
            onPressed: () {
              // add
              if (key != null) {
                HiveService().updateword(
                    Words(
                        voc: vocController.text,
                        pos: posController.text,
                        trans: transController.text,
                        timestamp: DateTime.now(),
                        pp: 0),
                    key);
              } else {
                HiveService().addword(Words(
                    voc: vocController.text,
                    pos: posController.text,
                    trans: transController.text,
                    timestamp: DateTime.now(),
                    pp: 0));
              }
              //print(HiveService().readword(1).voc);
              vocController.clear();
              transController.clear();
              posController.clear();
              Navigator.pop(context);
            },
            child: key == null ? const Text("Add") : const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    wordbox = HiveService().getwordbox();
  }

  String searchdata = "";

  @override
  Widget build(BuildContext context) {
    //List<int> mask = List<int>.generate(
    //    HiveService().getboxlength(), (int index) => index);
    //mask.remove(0);
    List<int> mask = //[1, 2, 3, ...]
      HiveService().maskmanger(input: searchdata);
    //List<dynamic> maskedwords = HiveService().readseqword(mask);
    //print("mask==${maskedwords[0].voc}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("local"),
        actions: [
          IconButton(
              onPressed: () {
                if (mask.length >= 4) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TestPage(
                              mask: mask,
                            )),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: const Text(
                          "There must be more than 4 words to test!"),
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
              },
              icon: const Icon(Icons.quiz),
              tooltip: 'test'),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.sync),
          ),
          IconButton(
              onPressed: openwrodaddbox,
              icon: const Icon(Icons.add),
              tooltip: 'add word'),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: StreamBuilder<BoxEvent>(
        stream: HiveService().getWordStream(),
        builder: (context, snapshot) {
          mask = //[1, 2, 3, ...]
            HiveService().maskmanger(input: searchdata);
          List<dynamic> maskedwords = HiveService().readseqword(mask);
          //maskedwords == [w1, w2, w3, ...]
          //print(mask);
          return Stack(
            children: <Widget>[
              Column(children: [
                Container(
                  constraints:
                      const BoxConstraints(minHeight: 73, maxHeight: 73),
                ),
                Expanded(
                    child: GridView.builder(
                  itemCount: maskedwords.length,
                  //padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 4.0,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    Words word = maskedwords[index];
                    String time =
                        "${word.timestamp.month}/${word.timestamp.day} ${word.timestamp.hour < 10 ? "0${word.timestamp.hour}" : word.timestamp.hour}:${word.timestamp.minute < 10 ? "0${word.timestamp.minute}" : word.timestamp.minute}:${word.timestamp.second < 10 ? "0${word.timestamp.second}" : word.timestamp.second}";
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 5,
                            alignment: Alignment.topLeft,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.elliptical(10, 20)))),
                        child: Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    word.voc,
                                    style: const TextStyle(fontSize: 40),
                                  ),
                                  Text(
                                    word.trans,
                                    style: const TextStyle(fontSize: 40),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    word.pos,
                                    style: const TextStyle(fontSize: 25),
                                  ),
                                  Text(
                                    time,
                                    style: const TextStyle(fontSize: 25),
                                  ),
                                  Text(
                                    word.pp.round().toString(),
                                    style: const TextStyle(
                                        fontSize: 25, color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        onPressed: () {
                          openwrodaddbox(key: mask[index]);
                        });
                  },
                ))
              ]),
              Positioned(
                top: 10,
                right: 15,
                left: 15,
                child: SearchAnchor(
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                      controller: controller,
                      padding: const WidgetStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0)),
                      onTap: controller.openView,
                      onChanged: (_) => controller.openView,
                      onSubmitted: (word) {
                        setState(() {
                          searchdata = word;
                        });
                      },
                      leading: const Icon(Icons.search),
                    );
                  },
                  viewOnSubmitted: (word) {
                    setState(() {
                      searchdata = word;
                      Navigator.pop(context);
                    });
                  },
                  suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                    List<String> sugg = [
                      "voc  ",
                      "trans",
                      "pos  ",
                      "time ",
                      "pp   "
                    ];
                    return List<ListTile>.generate(5, (int index) {
                      final String item = 'search with :  ${sugg[index]}= ';
                      return ListTile(
                        title: Text(
                          item,
                          style: const TextStyle(fontSize: 20),
                        ),
                        onTap: () {
                          controller.value =
                              TextEditingValue(text: "${sugg[index]}= ");
                        },
                      );
                    });
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
