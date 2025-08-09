// void main() {
//   runApp(PhoneCostApp());
// }
//
// class PhoneCostApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: '핸드폰 구매 비용 계산기',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//       ),
//       home: PhoneCostCalculator(),
//     );
//   }
// }
//
// class PhoneCostCalculator extends StatefulWidget {
//   @override
//   State<PhoneCostCalculator> createState() => _PhoneCostCalculatorState();
// }
//
// class _PhoneCostCalculatorState extends State<PhoneCostCalculator> {
//   final _formatter = NumberFormat.currency(locale: 'ko_KR', symbol: '₩');
//   final int oldMonthlyFee = 40000;
//   final int months = 24;
//   final int repairCost = 800000;
//
//   int foldDevicePrice = 1800000; // 폴드폰 기기값
//   int foldMonthlyFee = 40000; // 폴드폰 요금제
//
//   int barDevicePrice = 1200000; // 바형 스마트폰 기기값
//   int tabletPrice = 600000; // 태블릿 기기값
//   int barMonthlyFee = 40000; // 바형 스마트폰 요금제
//   int tabletMonthlyFee = 10000; // 태블릿 요금제
//
//   @override
//   Widget build(BuildContext context) {
//     int oldTotal = (oldMonthlyFee * months) + repairCost;
//
//     int foldTotal = foldDevicePrice + (foldMonthlyFee * months);
//     int barTabletTotal =
//         barDevicePrice +
//         tabletPrice +
//         ((barMonthlyFee + tabletMonthlyFee) * months);
//
//     int diffFold = foldTotal - oldTotal;
//     int diffBarTablet = barTabletTotal - oldTotal;
//
//     return Scaffold(
//       appBar: AppBar(title: Text('핸드폰 구매 비용 계산기'), centerTitle: true),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '기존 요금제 + 수리비',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               '월 ${_formatter.format(oldMonthlyFee)} x $months개월 + 수리비 ${_formatter.format(repairCost)} = ${_formatter.format(oldTotal)}',
//             ),
//             SizedBox(height: 24),
//             Text(
//               '새 기기 구매 옵션',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 12),
//             Text('1. 폴드폰 단독 구매'),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       labelText: '폴드폰 기기값 (원)',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                     onChanged: (v) =>
//                         setState(() => foldDevicePrice = int.tryParse(v) ?? 0),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       labelText: '월 요금제 (원)',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                     onChanged: (v) =>
//                         setState(() => foldMonthlyFee = int.tryParse(v) ?? 0),
//                   ),
//                 ),
//               ],
//             ),
//             Text('총 비용: ${_formatter.format(foldTotal)}'),
//             Text(
//               '차액: ${_formatter.format(diffFold.abs())} (${diffFold > 0 ? "더 비쌈" : "더 저렴함"})',
//             ),
//             SizedBox(height: 24),
//             Text('2. 바형 스마트폰 + 태블릿 구매'),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       labelText: '바형 스마트폰 기기값 (원)',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                     onChanged: (v) =>
//                         setState(() => barDevicePrice = int.tryParse(v) ?? 0),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       labelText: '태블릿 기기값 (원)',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                     onChanged: (v) =>
//                         setState(() => tabletPrice = int.tryParse(v) ?? 0),
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       labelText: '바형 월 요금제 (원)',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                     onChanged: (v) =>
//                         setState(() => barMonthlyFee = int.tryParse(v) ?? 0),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       labelText: '태블릿 월 요금제 (원)',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                     onChanged: (v) =>
//                         setState(() => tabletMonthlyFee = int.tryParse(v) ?? 0),
//                   ),
//                 ),
//               ],
//             ),
//             Text('총 비용: ${_formatter.format(barTabletTotal)}'),
//             Text(
//               '차액: ${_formatter.format(diffBarTablet.abs())} (${diffBarTablet > 0 ? "더 비쌈" : "더 저렴함"})',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// 작업 필요사항. 스케줄 추가에서 텍스트필드로 데이터 입력받고 넘겨야함.

import 'package:date_250721_250727/screen/home_screen.dart';
import 'package:date_250721_250727/screen/schedule_add.dart';
import 'package:date_250721_250727/screen/schedule_content.dart';
import 'package:flutter/material.dart';
import 'dart:math';

// 25.07.21 수학 문제
// void main() {
//   int originalPrice = 100000;
//   int year = 5;
//   double interestRate = 0.03;
//   var round = (originalPrice * pow(1 + interestRate, year)).round();
//   print(round);
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// 25-07-26 할 일!
// TODO : 할일 수정 기능 구현하기
// 홈 스크린에 수정 또는 보기 기능 > 보기 기능일때는 기존 로직 유지 > 수정 기능일때는 수정 화면으로 이동 > 수정 화면은 추가 화면에 로직의 내용을 바꿔서 표시 > 수정 완료후 홈 스크린으로 돌아가기 > 이때 상세 내용에도 해당 내용이 전달 되어야 함
// TODO : 할일 삭제 기능 구현하기
// TODO : 할일 완료 토글 기능 구현하기

void main() {
  runApp(
    MaterialApp(
      home: HomeScreen(),
      initialRoute: '/', // 홈을 지정하고나 이니셜 루트로 지정하거나 둘중 한가지만 해야한다.
      routes: {
        // "/": (context) => HomeScreen(),
        "/home_screen": (context) => HomeScreen(),
        "/schedule_add": (context) => ScheduleAdd(),
        "/schedule_content": (context) => ScheduleContent(),
      },
    ),
  );
}
