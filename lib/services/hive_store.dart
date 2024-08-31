import 'dart:async';

import 'package:adhe/model/words_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

class HiveService {
  //init box
  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(WordsAdapter());
    await Hive.openBox<Words>('localwords');
    Box<Words> wordbox = Hive.box('localwords');
    if (wordbox.length < 1) {
      wordbox.add(Words(
          voc: "box property", //
          trans: "\$name", //
          pos: "\$docID", //
          timestamp: DateTime.now(), //time
          pp: 0)); //dont change pp value
    } else {
      wordbox.putAt(
          0,
          Words(
              voc: "box property", //
              trans: "\$name", //
              pos: "\$docID", //
              timestamp: DateTime.now(), //time
              pp: 0));
    }
  }

  //get word stream
  Stream<BoxEvent> getWordStream() {
    final box = getwordbox();
    return box.watch();
  }

  //get word
  Box<Words> getwordbox() {
    return Hive.box('localwords');
  }

  //get length
  int getboxlength() {
    return getwordbox().length;
  }

  //add word
  Future<void> addword(Words value) async {
    Box<Words> box = getwordbox();
    await box.add(value);
  }

  //update word
  Future<void> updateword(Words newword, int key) async {
    Words oldword = readword(key);
    Words outputword = Words(
        voc: newword.voc,
        trans: newword.trans,
        pos: newword.pos,
        timestamp: oldword.timestamp,
        pp: newword.pp);//oldpp ? oldword.pp : newword.pp);
    Box<Words> box = getwordbox();
    await box.putAt(key, outputword);
  }

  //read word
  dynamic readword(int key) {
    Box<Words> box = getwordbox();
    return box.getAt(key);
  }

  //read word seq
  List<dynamic> readseqword(List<int> keys) {
    List<dynamic> maskedwords = [];
    for (final key in keys) {
      maskedwords.add(readword(key));
    }
    return maskedwords;
  }

  //delete word
  Future<void> deleteword(int key) async {
    Box<Words> box = getwordbox();
    await box.deleteAt(key);
  }

  //delete word weq
  Future<void> deleteseqword(List<int> keys) async {
    for (final key in keys) {
      if (key != 0) {
        await deleteword(key);
      }
    }
  }

  //depose box
  Future<void> dispose() async {
    await Hive.box('localwords').close();
  }

  //search(mask) manger
  List<int> maskmanger({required String input}) {
    List<int> searchmask =
        List<int>.generate(getboxlength(), (int index) => index);
    if (input.isNotEmpty && input.length <= 7) searchmask = [];
    if (input.length > 7) {
      List<dynamic> wordlist = readseqword(searchmask);
      searchmask = [];
      String searchtype = input.substring(0, 5);
      String searchword = input.substring(7);
      //print("=${searchword}=============================================");
      switch (searchtype) {
        case 'voc  ':
          int c = 0;
          for (Words word in wordlist) {
            if (word.voc == searchword) {
              searchmask.add(c);
            }
            c += 1;
          }
          break;
        case 'trans':
          int c = 0;
          for (Words word in wordlist) {
            if (word.trans == searchword) {
              searchmask.add(c);
            }
            c += 1;
          }
          break;
        case 'pos  ':
          int c = 0;
          for (Words word in wordlist) {
            if (word.pos == searchword) {
              searchmask.add(c);
            }
            c += 1;
          }
          break;
        case 'pp   ':
          int c = 0;
          for (Words word in wordlist) {
            if (word.pp.toInt().toString() == searchword) {
              searchmask.add(c);
            }
            c += 1;
          }
          break;
        case 'time ':
          int c = 0;
          for (Words word in wordlist) {
            String time = "${word.timestamp.month}/${word.timestamp.day}";
            if (time == searchword) {
              searchmask.add(c);
            }
            c += 1;
          }
          break;
      }
    }
    if (searchmask.isNotEmpty && searchmask[0] == 0) {
      searchmask.remove(0);
    }
    //searchmask = List<int>.generate(getboxlength(), (int index) => index);
    //searchmask.remove(0);
    return searchmask;
  }

  //random 3 trans
  List<String> randomtrans(List<int> widgetmask, int anskey) {
    List<String> trans = [readword(anskey).trans];
    int word = widgetmask[Random().nextInt(widgetmask.length)];
    for (int i = 0; i <= 2; i += 1) {
      while (trans.any((element) => element == readword(word).trans)) {
        word = widgetmask[Random().nextInt(widgetmask.length)];
      }
      trans.add(readword(word).trans);
    }
    trans.shuffle();
    return trans;
  }

  //update pp
  Future<void> updatepp(int offset, int key) async {
    Words oldword = readword(key);
    Words outputword = Words(
        voc: oldword.voc,
        trans: oldword.trans,
        pos: oldword.pos,
        timestamp: oldword.timestamp,
        pp: oldword.pp + offset);
    Box<Words> box = getwordbox();
    await box.putAt(key, outputword);
  }
}
