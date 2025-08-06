import 'dart:async';

main(){
  // Future를 반환하는 함수
   Future<String> fetchData() async{
  return Future.delayed(Duration(seconds: 1), () => "데이터");
  }

// Stream을 반환하는 함수
  Stream<int> countNumbers() async* {
  // 구현부
  }

  int count = 0;
  late Timer timer;

  // timer = Timer.periodic(Duration(seconds: 3), () {
  //   print("Hello");
  //   count++;
  //   if (count >= 5) {
  //     timer.cancel();
  //   }
  // });

  Stream<String> processData() async* {
    try {
      yield "정상 데이터 1";
      throw Exception("에러 발생!");
      yield "정상 데이터 2";
    } catch (e) {
      yield* Stream.error("에러: $e");
      yield "복구된 데이터";
    }
  }

  var then = Future.value("Hello")
      .then((value) => "$value World")
      .then((value) => value.toUpperCase())
      .then((result) => print(result));

print(then);

// 에러 발생하는 코드
//   void processUser(String name, int age, bool isActive) {
//     print("$name, $age, $isActive");
//   }

// 수정된 코드
//   void processUser({ required String name, required int age, required bool
//   isActive}) {
//     print("$name, $age, $isActive");
//   }
//
// processUser("철수", 15, true);

  Stream<String> chatFilter(Stream<String> messages) async* {
    List<String> badWords = ["욕설1", "욕설2"];

    await for (String message in messages) {
      String filteredMessage = message;
      for (String badWord in badWords) {
        filteredMessage = filteredMessage.replaceAll(badWord, "***");
      }
      yield filteredMessage;
    }
  }

// 사용 예시
  Stream<String> chatMessages = Stream.fromIterable([
    "안녕하세요", "욕설1이 포함된 메시지", "정상 메시지"
  ]);

  chatFilter(chatMessages).listen((message) => print("필터링된: $message"));

  class LibraryMonitor {
  late StreamController<String> sc;

  LibraryMonitor() {
  sc = StreamController<String>();
  }

  Stream<String> get updates => sc.stream;

  void addEvent(String event) {
  sc.add(event);
  }

  void dispose() {
  sc.close(); // 메모리 누수 방지
  }
  }

// 사용법
  final monitor = LibraryMonitor();
  monitor.updates.listen((event) => print("도서관 이벤트: $event"));
  monitor.addEvent("해리포터 책이 대출되었습니다");
  monitor.dispose(); // 반드시 호출

}