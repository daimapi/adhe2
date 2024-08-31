import 'package:hive/hive.dart';

part 'words_model.g.dart';

@HiveType(typeId: 1)
class Words {
  @HiveField(0)
  final String voc;
  @HiveField(1)
  final String trans;
  @HiveField(2)
  final String pos;
  @HiveField(3)
  final DateTime timestamp;
  @HiveField(4)
  final double pp;

  Words({
    required this.voc,
    required this.trans,
    required this.pos,
    required this.timestamp,
    required this.pp,
  });
}