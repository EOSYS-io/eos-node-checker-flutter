import 'package:intl/intl.dart';

class EosNode {
  final String title;
  final String url;
  final int rank;
  final double votes;
  double votePercents;
  String endpoint;
  String version;
  int number = 0;
  int lastNumber = 0;
  String id;
  DateTime time;
  String producer;

  EosNode(this.title, this.url, this.rank, this.votes, double totalVotes) {
    votePercents = (totalVotes > 0 ? votes / totalVotes * 100 : 0.0);
  }

  void fromJson(Map<String, dynamic> json) {
    version = json['server_version'];
    number = json['head_block_num'];
    lastNumber = json['last_irreversible_block_num'];
    id = json['head_block_id'];
    time = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(json['head_block_time'], true);
    producer = json['head_block_producer'];
  }

  void setError() {
    version = null;
    number = 0;
    lastNumber = 0;
    id = null;
    time = null;
    producer = null;
  }
}