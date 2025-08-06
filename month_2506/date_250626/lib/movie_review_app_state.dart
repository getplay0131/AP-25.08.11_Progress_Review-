import 'package:flutter/material.dart';

class MovieReviewAppState extends StatefulWidget {
  const MovieReviewAppState({Key? key}) : super(key: key);

  @override
  _MovieReviewAppStateState createState() => _MovieReviewAppStateState();
}

class _MovieReviewAppStateState extends State<MovieReviewAppState> {
  Map<String, (String, double)> userReviews = {}; // 영화제목: (리뷰, 평점)

  // 리뷰 추가 메서드 작성 (Record 사용)
  void addReview(String movieTitle, String review, double rating) {
    // 여기에 코드 작성
    userReviews[movieTitle] = (review, rating);
  }

  // 4점 이상 영화만 출력하는 메서드 작성 (entries 사용)
  List<String> getHighRatedMovies() {
    // 여기에 코드 작성
    var entries = userReviews.entries;
    List<String> targetTitle = [];
    for (var o in entries) {
      var score = o.value.$2;
      if (score >= 4) {
        targetTitle.add(o.key);
      }
    }
    return targetTitle;
  }

  // 서버에 리뷰 업로드 (UTC 시간 사용)
  Future<void> uploadReview(String movieTitle) async {
    if (userReviews.containsKey(movieTitle)) {
      // 여기에 업로드 코드 작성 (DateTime.now().toUtc() 사용)
      addReview(movieTitle, "리뷰", 4.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
