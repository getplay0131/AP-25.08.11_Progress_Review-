import 'package:date_250721_250727/screen/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ScheduleAdd extends StatefulWidget {
  ScheduleAdd({Key? key}) : super(key: key);

  @override
  State<ScheduleAdd> createState() => _ScheduleAddState();
}

class _ScheduleAddState extends State<ScheduleAdd> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;

  String title = "";
  DateTime date = DateTime.now();
  String description = "";
  String location = "";
  bool isCompleted = false;

  String currentMode = "add";
  int _selectedIndex = 0;
  Map<String, dynamic> scheduleData = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initScheduleData();
    print("didChangeDependencies called");
    _checkCurrentDataForAddScreenUsedidChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    print("initState called");
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _initScheduleData() {
    print("===== _initScheduleData called =====");
    var args = ModalRoute.of(context)?.settings.arguments;
    if (args != null &&
        args is Map<String, dynamic> &&
        args["mode"] == "edit") {
      scheduleData = args["data"] ?? {};
      title = scheduleData["title"] ?? "";
      date = scheduleData["date"] ?? DateTime.now();
      description = scheduleData["description"] ?? "";
      location = scheduleData["location"] ?? "";
      isCompleted = scheduleData["isCompleted"] ?? false;
      _selectedIndex = scheduleData["selectedIndex"] ?? 0;
      currentMode = "edit";
      _titleController.text = title;
      _descriptionController.text = description;
      _locationController.text = location;
      print("수정 모드로 데이터 설정됨");
    } else {
      title = "";
      date = DateTime.now();
      description = "";
      location = "";
      isCompleted = false;
      _selectedIndex = 0;
      currentMode = "add";
      _titleController.clear();
      _descriptionController.clear();
      _locationController.clear();
      print("초기값 설정됨");
    }
    print("===== _initScheduleData end =====");
  }

  Future<void> _showDatePicker(BuildContext context) async {
    DateTime tempPicked = date;
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext builder) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          height: 340,
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: CupertinoDatePicker(
                  initialDateTime: date,
                  mode: CupertinoDatePickerMode.dateAndTime,
                  use24hFormat: true,
                  onDateTimeChanged: (DateTime newDate) {
                    tempPicked = newDate;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      date = tempPicked;
                    });
                    Navigator.of(context).pop();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    '확인',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        title: Text(
          currentMode == "edit" ? "일정 수정하기" : "일정 추가하기",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _inputForm(
                titleController: _titleController,
                descriptionController: _descriptionController,
                locationController: _locationController,
              ),
              SizedBox(height: 18),
              _buildTimeSection(currentMode),
              SizedBox(height: 18),
              Row(
                children: [
                  Checkbox(
                    value: isCompleted,
                    activeColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    onChanged: (value) {
                      setState(() {
                        isCompleted = value ?? false;
                      });
                    },
                  ),
                  Text(
                    "완료 여부",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18),
              FilledButton(
                onPressed: _collectAndValidateData,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(currentMode == "edit" ? "일정 수정하기" : "일정 추가하기"),
              ),
              SizedBox(height: 28),
              Center(
                child: Text(
                  "현재 모드: ${currentMode == "edit" ? "수정 모드" : "추가 모드"}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputForm({
    required TextEditingController titleController,
    required TextEditingController descriptionController,
    required TextEditingController locationController,
  }) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: "제목",
              prefixIcon: Icon(Icons.title, color: Colors.green),
              filled: true,
              fillColor: Colors.green[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '제목을 입력해주세요.';
              }
              if (value.length > 20) {
                return '제목은 20자 이내로 입력해주세요.';
              }
              if (value.length < 2) {
                return '제목은 2자 이상 입력해주세요.';
              }
              return null;
            },
          ),
          SizedBox(height: 14),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: "설명",
              prefixIcon: Icon(Icons.description, color: Colors.green),
              filled: true,
              fillColor: Colors.green[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '설명을 입력해주세요.';
              }
              if (value.length < 2) {
                return '설명은 2자 이상 입력해주세요.';
              }
              if (value.length > 100) {
                return '설명은 100자 이내로 입력해주세요.';
              }
              return null;
            },
          ),
          SizedBox(height: 14),
          TextFormField(
            controller: locationController,
            decoration: InputDecoration(
              labelText: "위치",
              prefixIcon: Icon(Icons.place, color: Colors.green),
              filled: true,
              fillColor: Colors.green[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '위치를 입력해주세요.';
              }
              if (value.length < 1) {
                return '위치는 1자 이상 입력해주세요.';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  void _collectAndValidateData() {
    print("제목: ${_titleController.text.trim()}");
    print("설명: ${_descriptionController.text.trim()}");
    print("위치: ${_locationController.text.trim()}");
    if (_formKey.currentState!.validate()) {
      setState(() {
        title = _titleController.text.trim();
        description = _descriptionController.text.trim();
        location = _locationController.text.trim();
        scheduleData = {
          "title": title,
          "date": date,
          "description": description,
          "location": location,
          "isCompleted": isCompleted,
        };
      });

      print("===== _collectAndValidateData : checkData ===========");
      _checkCurrentDataForAddScreen();
      if (context.mounted) {
        _moveToHomeScheduleScreenOnlyDataTransmission(
          schedule: scheduleData,
          idx: _selectedIndex,
          mode: currentMode,
        );
        _selectedIndex++;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("입력한 데이터를 확인해주세요."),
          backgroundColor: Colors.red,
        ),
      );
    }

    _titleController.clear();
    _descriptionController.clear();
    _locationController.clear();
  }

  Widget _buildTimeSection(String currentMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.calendar_today, color: Colors.green, size: 20),
        SizedBox(width: 8),
        Text(
          "선택된 날짜/시간: ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} "
          "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: () => _showDatePicker(context),
          icon: Icon(Icons.edit_calendar, color: Colors.green),
          label: Text(currentMode == "edit" ? "날짜/시간 수정" : "날짜/시간 선택"),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.green,
            side: BorderSide(color: Colors.green, width: 1.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _moveToHomeScheduleScreenOnlyDataTransmission({
    Map<String, dynamic>? schedule,
    int? idx,
    String mode = "add",
  }) async {
    print(
      "===== _moveToHomeScheduleScreenOnlyDataTransmission : checkData ===========",
    );
    schedule ??= {
      "title": "새로운 일정",
      "date": DateTime.now(),
      "description": "일정 설명",
      "location": "장소",
      "isCompleted": false,
    };
    idx ??= 0;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("일정을 추가하였습니다.")));
    Navigator.pop(context, {
      "data": scheduleData,
      "mode": currentMode,
      "selectedIndex": _selectedIndex,
    });
    print("schedule: $schedule");
    if (schedule.isEmpty || schedule is! Map<String, dynamic>) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("일정 추가에 실패했습니다!")));
      print("일정 추가에 실패했습니다.");
    }
    _checkCurrentDataForAddScreen();
  }

  void _checkCurrentDataForAddScreenUsedidChangeDependencies() {
    print("===== add screen didChangeDependencies called =====");
    print("title: $title");
    print("date: $date");
    print("description: $description");
    print("location: $location");
    print("isCompleted: $isCompleted");
    print("currentIndex : $_selectedIndex");
    print("currentMode: $currentMode");
    print("========================================");
  }

  void _checkCurrentDataForAddScreen() {
    print("====== 현재 데이터 확인 : AddScreen =====");
    print("title: $title");
    print("date: $date");
    print("description: $description");
    print("location: $location");
    print("isCompleted: $isCompleted");
    print("currentIndex : $_selectedIndex");
    print("currentMode: $currentMode");
    print("========================================");
  }
}
