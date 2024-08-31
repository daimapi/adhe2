import 'package:adhe/model/words_model.dart';
import 'package:adhe/services/hive_store.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TestPage extends StatefulWidget {
  final List<int> mask;
  const TestPage({super.key, required this.mask});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late final Box<Words> wordbox;
  late PageController _pageViewController;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(); //viewportFraction: 1);
    wordbox = HiveService().getwordbox();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> maskedwords = HiveService().readseqword(widget.mask);
    return SizedBox(
      height: 500.0,
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.mask.length,
        controller: _pageViewController,
        itemBuilder: (BuildContext context, int index) {
          List<String> trans =
              HiveService().randomtrans(widget.mask, widget.mask[index]);
          int ansindexinlist = trans
              .indexOf(HiveService().readword(widget.mask[index]).trans);
          return Scaffold(
            body: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        maskedwords[index].voc,
                        style: const TextStyle(fontSize: 40),
                      ),
                    )),
                    Expanded(
                      flex: 1,
                      child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          padding: const EdgeInsets.only(
                              top: 15, left: 20, right: 20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                          ),
                          itemBuilder: (BuildContext context, int index_) {
                            return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 3,
                                    alignment: Alignment.center,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.elliptical(30, 20)))),
                                onPressed: () {
                                  if (index_ != ansindexinlist) {
                                    HiveService()
                                        .updatepp(-1, widget.mask[index]);
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        content: Text(
                                            "The anser is \n${trans[ansindexinlist]}"),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              if (index + 1 >
                                                  widget.mask.length - 1) {
                                                Navigator.pop(context);
                                              } else {
                                                _pageViewController
                                                    .animateToPage(
                                                  index + 1,
                                                  duration: const Duration(
                                                      milliseconds: 4),
                                                  curve: Curves.bounceIn,
                                                );
                                              }
                                            },
                                            child: const Text("I knew it"),
                                          ),
                                        ], //TextField(controller: textController),
                                      ),
                                    );
                                  } else {
                                    HiveService()
                                        .updatepp(1, widget.mask[index]);
                                    if (index + 1 > widget.mask.length - 1) {
                                      Navigator.pop(context);
                                    } else {
                                      _pageViewController.animateToPage(
                                        index + 1,
                                        duration:
                                            const Duration(milliseconds: 4),
                                        curve: Curves.bounceIn,
                                      );
                                    }
                                  }
                                },
                                child: Text(trans[index_],
                                    style: const TextStyle(fontSize: 20)));
                          }),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
