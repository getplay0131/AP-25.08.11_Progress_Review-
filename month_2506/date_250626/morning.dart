main(){
  Future<void> timeTest() async {
    DateTime start = DateTime.now();

    await Future.delayed(Duration(milliseconds: 500));

    DateTime end = DateTime.now();
    Duration diff = end.difference(start);

    print('소요 시간: ${diff.inMilliseconds}ms');
  }

  Map<String, int> scores = {
    '김철수': 85,
    '이영희': 92,
    '박민수': 78,
    '최지원': 88
  };

  void printHighScores() {
    // 여기에 코드 작성 (entries 사용)
    for (var score in scores.entries) {
      if(score.value >= 80){
        print("이름 : ${score.key}");
      }
    }
  }


}

