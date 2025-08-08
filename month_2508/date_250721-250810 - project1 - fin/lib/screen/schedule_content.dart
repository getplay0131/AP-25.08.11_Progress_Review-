import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleContent extends StatefulWidget {
  const ScheduleContent({Key? key}) : super(key: key);

  @override
  State<ScheduleContent> createState() => _ScheduleContentState();
}

class _ScheduleContentState extends State<ScheduleContent> {
  String title = "";
  DateTime date = DateTime.now();
  String description = "";

  String location = "";

  bool isCompleted = false;

  List<Map<String, dynamic>> scheduleList = [];

  Map<String, dynamic> scheduleData = {};

  bool _dataLoaded = false; // 데이터 로딩 여부를 확인하기 위한 변수
  // 의존성 문제로 화면 로딩시 자동 데이터 표시
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _initLoadScheduleData();
    // saveToData();
    _checkCurrentDataForScheduleContentUsedidChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scheduleData = {
      'title': title,
      'date': date.toIso8601String(),
      'description': description,
      'location': location,
      'isCompleted': isCompleted,
    };
    _checkCurrentDataForScheduleContent();
    loadFromData();
  }

  void _initLoadScheduleData() {
    // 초기 데이터 로딩 함수
    print("초기 데이터 로딩 시작");
    var args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      scheduleData = args["data"];
      title = scheduleData['title'] ?? "제목 없음";
      date = scheduleData['date'] ?? DateTime.now();
      description = scheduleData['description'] ?? "설명 없음";
      location = scheduleData['location'] ?? "위치 없음";
      isCompleted = scheduleData['isCompleted'] ?? false;
      _dataLoaded = true; // 데이터가 로딩되었음을 표시
      scheduleList.add(scheduleData);
      print("didChangeDependencies에서 데이터 로딩 완료");
    } else {
      print("didChangeDependencies에서 데이터 로딩 실패");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "일정 상세 보기",
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) // context가 유효한지 확인
              {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("홈 버튼이 눌렸습니다!")));
                Navigator.maybePop(context);
              }
            },
            icon: Icon(Icons.home, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                child: Text("일정 저장하기"),
                onPressed: () {
                  if (context.mounted) // context가 유효한지 확인
                  {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("일정 저장 버튼이 눌렸습니다!")));
                    // setState(() {
                    //   scheduleData = {
                    //     'title': title,
                    //     'date': date.toIso8601String(),
                    //     'description': description,
                    //     'location': location,
                    //     'isCompleted': isCompleted,
                    //   };
                    // });
                    saveToData();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("저장 실패!"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    throw Exception("저장 실패!");
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (context.mounted) // context가 유효한지 확인
                  {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("일정 로딩 버튼이 눌렸습니다!")));
                    // 댄을 사용해 논 블로킹 작업 진행
                    loadFromData().then((loadedData) {
                      if (loadedData.isNotEmpty) {
                        setState(() {
                          scheduleList = loadedData;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("일정 데이터가 불러와졌습니다.")),
                        );
                        print("일정 데이터가 불러와졌습니다.");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("저장된 일정 데이터가 없습니다.")),
                        );
                        print("저장된 일정 데이터가 없습니다.");
                      }
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("로딩 실패!"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    throw Exception("로딩 실패!");
                  }
                },
                child: Text("일정 불러오기"),
              ),
            ],
          ),

          Center(
            child: scheduleList.isEmpty
                ? Card(
                    margin: EdgeInsets.all(16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "저장된 일정이 없습니다.",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                : Column(
                    children: scheduleList.map((item) {
                      return Card(
                        margin: EdgeInsets.all(16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "제목: ${item['title'] ?? ''}",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "날짜: ${(item['date'] != null) ? DateTime.parse(item['date'].toString()).toLocal().toString().split(' ')[0] : ''}",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "설명: ${item['description'] ?? ''}",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "위치: ${item['location'] ?? ''}",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "완료 여부: ${(item['isCompleted'] == true) ? "완료" : "미완료"}",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> saveToData() async {
    try {
      Map<String, dynamic> scheduleData = {
        'title': title, // 현재 화면의 title 값
        'date': date.toIso8601String(), // 현재 화면의 date 값
        'description': description, // 현재 화면의 description 값
        'location': location, // 현재 화면의 location 값
        'isCompleted': isCompleted, // 현재 화면의 isCompleted 값
      };

      // 📋 저장하기 전 데이터 확인 로그
      print("=== 저장할 데이터 확인 ===");
      print("제목: ${scheduleData['title']}");
      print("날짜: ${scheduleData['date']}");
      print("설명: ${scheduleData['description']}");
      print("위치: ${scheduleData['location']}");
      print("완료여부: ${scheduleData['isCompleted']}");

      var pref = await SharedPreferences.getInstance();
      var scheduleToJson = jsonEncode(scheduleData);
      print("일정 데이터 JSON: $scheduleToJson");
      if (scheduleToJson != null && scheduleToJson.isNotEmpty) {
        await pref.setString('scheduleData', scheduleToJson);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("일정 데이터가 저장되었습니다.")));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("일정 데이터가 저장되었습니다. 홈화면으로 돌아갑니다")));
        print("일정 데이터가 저장되었습니다.");
        Navigator.pop(context, scheduleData);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("일정 데이터가 비어있습니다.")));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("일정 데이터를 확인해주세요."),
            backgroundColor: Colors.red,
          ),
        );
        print("일정 데이터가 비어있습니다.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("저장 중 오류가 발생했습니다: $e"),
          backgroundColor: Colors.red,
        ),
      );
      print("저장 중 오류 발생: $e");
    }
  }

  Future<List<Map<String, dynamic>>> loadFromData() async {
    List<Map<String, dynamic>> scheduleList = [];
    try {
      var pref = await SharedPreferences.getInstance();
      String? scheduleJson = pref.getString('scheduleData');
      if (scheduleJson != null && scheduleJson.isNotEmpty) {
        Map<String, dynamic> scheduleMap = jsonDecode(scheduleJson);
        setState(() {
          title = scheduleMap['title'] ?? "제목 없음";
          date = scheduleMap['date'] != null
              ? DateTime.parse(scheduleMap['date'])
              : DateTime.now();
          description = scheduleMap['description'] ?? "설명 없음";
          location = scheduleMap['location'] ?? "위치 없음";
          isCompleted = scheduleMap['isCompleted'] ?? false;
        });
        print("=== 로딩된 데이터 확인 ===");
        print("로딩된 제목 : ${scheduleMap["title"]}");
        print("로딩된 날짜 : ${scheduleMap["date"]}");
        print("로딩된 설명 : ${scheduleMap["description"]}");
        print("로딩된 위치 : ${scheduleMap["location"]}");
        print(
          "로딩된 완료 여부 : ${scheduleMap["isCompleted"] == true ? "완료" : "미완료"}",
        );
        scheduleList.add(scheduleMap);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("일정 데이터가 불러와졌습니다.")));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("저장된 일정 데이터가 없습니다.")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("데이터 로딩 중 오류가 발생했습니다: $e"),
          backgroundColor: Colors.red,
        ),
      );
      print("데이터 로딩 중 오류 발생: $e");
    }
    return scheduleList;
  }

  void _checkCurrentDataForScheduleContentUsedidChangeDependencies() {
    print("===== schedule_content screen didChangeDependencies called =====");
    print("title: $title");
    print("date: $date");
    print("description: $description");
    print("location: $location");
    print("isCompleted: $isCompleted");
    print("========================================");
  }

  void _checkCurrentDataForScheduleContent() {
    print("====== 현재 데이터 확인 : schedule_content =====");
    print("title: $title");
    print("date: $date");
    print("description: $description");
    print("location: $location");
    print("isCompleted: $isCompleted");
    print("========================================");
  }
}
