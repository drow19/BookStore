class HistoryModel {
  String transId;
  int userId;
  String date;
  String total;

  HistoryModel({
    this.transId,
    this.userId,
    this.date,
    this.total,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json){
    return HistoryModel(
      transId: json['trans_id'],
      userId: json['user_id'],
      date: json['date'],
      total: json['total']
    );
  }
}
