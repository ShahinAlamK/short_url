
class ShortModel{
  String?url;
  String?date;
  ShortModel({this.url,this.date});

  Map<String, dynamic> toMap() {
    return {
      'url': this.url,
      'date': this.date,
    };
  }

  factory ShortModel.fromMap(Map<String, dynamic> map) {
    return ShortModel(
      url: map['url'] as String,
      date: map['date'] as String,
    );
  }
}