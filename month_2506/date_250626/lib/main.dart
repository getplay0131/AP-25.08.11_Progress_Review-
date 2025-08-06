import 'package:flutter/material.dart';

void main() {
runApp(MaterialApp(home: ,))

}
// class Counter extends StatefulWidget {
//   @override
//   State<Counter> createState() => _CounterState();
//
//   void _showDatePicker() {
//     showCupertinoDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) => Align(
//         alignment: Alignment.center,
//         child: Container(
//           height: 300,
//           child: CupertinoDatePicker(
//             mode: CupertinoDatePickerMode.date,
//             onDateTimeChanged: (date) => setState(() => selectedDate = date),
//             initialDateTime: selectedDate,
//             maximumDate: DateTime.now(),
//           ),
//         ),
//       ),
//     );
//   }
//
// }

// class _CounterState extends State<Counter> {
//   int count = 0;
//
//   void _increment() {
//     setState(() {
//       count++;
//     });
//   }


  // Scaffold(
  // body:Column()
  // children: [
  // Expanded(
  // child: ListView(...),
  // ),
  // ],
  // ),
  // )

  // void _showDatePicker() {
  // showCupertinoDialog(
  // context: context,
  // barrierDismissible: true,
  // builder: (context) => Align(
  // alignment: Alignment.center,
  // child: Container(
  // height: 300,
  // child: CupertinoDatePicker(
  // mode: CupertinoDatePickerMode.date,
  // onDateTimeChanged: (date) => setState(() => selectedDate = date),
  // initialDateTime: selectedDate,
  // maximumDate: DateTime.______(),
  // ),
  // ),
  // ),
  // );
  // }

  // class PostUploader {
  // Future<void> uploadPost(String content) async {
  // // 서버 저장용 UTC 시간
  // DateTime uploadTime = DateTime.now().toUtc();
  //
  // Map<String, dynamic> postData = {
  // 'content': content,
  // 'upload_time': uploadTime.millisecondsSinceEpoch,
  // 'user_id': getCurrentUserId(),
  // };
  //
  // await ApiService.post('/posts', postData);
  // }
  //
  // String formatUploadTime(DateTime serverTime) {
  // // 화면 표시용 로컬 시간 변환
  // DateTime localTime = serverTime.toLocal();
  // return DateFormat('yyyy-MM-dd HH:mm').format(localTime);
  // }
  // }

class _MyAppState extends State<MyApp> {
  Timer? timer;
  StreamController<String> controller = StreamController();

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      controller.add('ping');
    });
  }

  @override
  void dispose() {
    // 여기에 정리 코드 작성
    timer?.cancel();
    controller.close();
    super.dispose();
  }
}
