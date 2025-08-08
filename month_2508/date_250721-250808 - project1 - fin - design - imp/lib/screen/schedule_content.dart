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
  bool _dataLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initLoadScheduleData();
    _checkCurrentDataForScheduleContentUsedidChangeDependencies();
  }

  @override
  void initState() {
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
    var args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      scheduleData = args["data"];
      title = scheduleData['title'] ?? "제목 없음";
      date = scheduleData['date'] ?? DateTime.now();
      description = scheduleData['description'] ?? "설명 없음";
      location = scheduleData['location'] ?? "위치 없음";
      isCompleted = scheduleData['isCompleted'] ?? false;
      _dataLoaded = true;
      scheduleList = [scheduleData];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "일정 상세 보기",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("홈 버튼이 눌렸습니다!")));
                Navigator.maybePop(context);
              }
            },
            icon: Icon(Icons.home, color: isDark ? Colors.white : Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Center(
          child: _dataLoaded
              ? Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: isDark ? Colors.grey[850] : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Chip(
                              label: Text(
                                isCompleted ? "완료" : "미완료",
                                style: TextStyle(
                                  color: isCompleted
                                      ? Colors.green[800]
                                      : Colors.orange[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: isCompleted
                                  ? Colors.green[100]
                                  : Colors.orange[100],
                            ),
                            Spacer(),
                            Icon(
                              isCompleted
                                  ? Icons.check_circle
                                  : Icons.event_note,
                              color: isCompleted ? Colors.green : Colors.grey,
                              size: 28,
                            ),
                          ],
                        ),
                        SizedBox(height: 18),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        _infoRow(
                          Icons.calendar_today,
                          "날짜",
                          "${date.toLocal()}".split(' ')[0],
                        ),
                        SizedBox(height: 8),
                        _infoRow(Icons.description, "설명", description),
                        SizedBox(height: 8),
                        _infoRow(Icons.place, "위치", location),
                        SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FilledButton.tonal(
                              onPressed: () => saveToData(),
                              child: Text("일정 저장"),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.green[50],
                                foregroundColor: Colors.green[800],
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            FilledButton.tonal(
                              onPressed: () async {
                                var loaded = await loadFromData();
                                if (loaded.isNotEmpty) {
                                  setState(() {
                                    scheduleList = loaded;
                                  });
                                }
                              },
                              child: Text("일정 불러오기"),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.blue[50],
                                foregroundColor: Colors.blue[800],
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Card(
                  margin: EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      "저장된 일정이 없습니다.",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: isDark ? Colors.green[200] : Colors.green, size: 20),
        SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.grey[200] : Colors.grey[800],
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Future<void> saveToData() async {
    try {
      Map<String, dynamic> scheduleData = {
        'title': title,
        'date': date.toIso8601String(),
        'description': description,
        'location': location,
        'isCompleted': isCompleted,
      };
      var pref = await SharedPreferences.getInstance();
      var scheduleToJson = jsonEncode(scheduleData);
      if (scheduleToJson.isNotEmpty) {
        await pref.setString('scheduleData', scheduleToJson);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("일정 데이터가 저장되었습니다.")));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("일정 데이터가 저장되었습니다. 홈화면으로 돌아갑니다")));
        Navigator.pop(context, scheduleData);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("일정 데이터가 비어있습니다.")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("저장 중 오류가 발생했습니다: $e"),
          backgroundColor: Colors.red,
        ),
      );
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
