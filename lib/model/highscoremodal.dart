class HighScore {
  int id;
  String Score;

  HighScore({
    this.id,
    this.Score,
  });



//  int get id => id;
  String get score => Score;

  factory HighScore.fromJson(Map<String, dynamic> data) => new HighScore(
      id: data["id"],
      Score: data["Score"]
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "Score": score,

  };


  static fromMap(c) {

  }
//  Map<String, dynamic> toMap() {
//    return {
//      'id': id,
//      'name': name,
//    };
//  }
}




