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
  final _formKey =
      GlobalKey<FormState>(); // 폼 키 선언 > 폼 위젯에 연결하여 유효성 검사 등을 수행할 수 있다.

  // 데이터 입력받기 위한 컨트롤러 선언 > 추후 텍스트필드에 연결 > 마지막에 디스포즈 필요
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;

  String title = "";
  DateTime date = DateTime.now();
  String description = "";
  String location = "";
  bool isCompleted = false;

  String currentMode = "add"; // 현재 모드 (추가 또는 수정)
  int _selectedIndex = 0; // 현재 선택된 인덱스

  Map<String, dynamic> scheduleData = {};

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _initScheduleData(); // didChangeDependencies내에서 호출하는 경우 셋트테이트 없어도 동작한다. 단 비동기 작업이나 외부 데이터 로딩 등으로 상태가 변경될때는 필요하다
    print("didChangeDependencies called");
    _checkCurrentDataForAddScreenUsedidChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    print("initState called");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _initScheduleData() {
    // 초기값 설정
    print("===== _initScheduleData called =====");
    var args = ModalRoute.of(context)?.settings.arguments;
    if (args != null &&
        args is Map<String, dynamic> &&
        args["mode"] == "edit") {
      //   수정 모드로 표시
      scheduleData = args["data"] ?? {};
      // isEditMode = true;
      title = scheduleData["title"] ?? "";
      date = scheduleData["date"] ?? DateTime.now();
      description = scheduleData["description"] ?? "";
      location = scheduleData["location"] ?? "";
      isCompleted = scheduleData["isCompleted"] ?? false;
      _selectedIndex = scheduleData["selectedIndex"] ?? 0; // 선택된 인덱스 설정
      currentMode = "edit"; // 현재 모드를 수정으로 설정
      _titleController.text = title;
      _descriptionController.text = description;
      _locationController.text = location;
      print("수정 모드로 데이터 설정됨");
    } else {
      // 초기값 설정
      // isEditMode = false;
      title = "";
      date = DateTime.now();
      description = "";
      location = "";
      isCompleted = false;
      _selectedIndex = 0; // 초기 선택된 인덱스
      currentMode = "add"; // 현재 모드를 추가로 설정
      _titleController.clear();
      _descriptionController.clear();
      _locationController.clear();
      print("초기값 설정됨");
    }
    print("===== _initScheduleData end =====");
  }

  // 날짜 선택을 위한 메소드
  Future<void> _showDatePicker(BuildContext context) async {
    DateTime tempPicked = date;
    await showModalBottomSheet(
      // showModalBottomSheet를 사용하여 날짜 선택기 표시
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 300,
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: CupertinoDatePicker(
                  initialDateTime: date,
                  mode: CupertinoDatePickerMode.dateAndTime, // 날짜와 시간 선택 모드
                  use24hFormat: true,
                  onDateTimeChanged: (DateTime newDate) {
                    tempPicked = newDate;
                  },
                ),
              ),
              CupertinoButton(
                child: Text('확인'),
                onPressed: () {
                  setState(() {
                    date = tempPicked;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentMode == "edit" ? "일정 수정하기" : "일정 추가하기",
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
        children: [
          inputForm(
            // 입력 폼 위젯
            titleController: _titleController,
            descriptionController: _descriptionController,
            locationController: _locationController,
          ),
          _buildTimeSection(currentMode), // 날짜/시간 선택 섹션
          Checkbox(
            // 완료 여부 체크박스
            value: isCompleted,
            onChanged: (value) {
              // 체크박스 상태 변경 시 호출되는 콜백
              setState(() {
                isCompleted = value ?? false;
              });
            },
          ),
          ElevatedButton(
            onPressed: _collectAndValidateData, // 데이터 수집 및 유효성 검사 메소드 호출
            child: Text(currentMode == "edit" ? "일정 수정하기" : "일정 추가하기"),
          ),
          SizedBox(height: 20),
          Text(
            "현재 모드: ${currentMode == "edit" ? "수정 모드" : "추가 모드"}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget inputForm({
    required TextEditingController titleController,
    required TextEditingController descriptionController,
    required TextEditingController locationController,
  }) {
    return Form(
      key: _formKey, // 폼 위젯에 키를 연결하여 유효성 검사 등을 수행할 수 있다.
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              // 제목 입력 필드
              controller: titleController,
              decoration: InputDecoration(labelText: "제목"),
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
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "설명"),
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
            TextFormField(
              controller: locationController,
              decoration: InputDecoration(labelText: "위치"),
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
      ),
    );
  }

  // 데이터 수집 및 유효성 검사 메소드
  void _collectAndValidateData() {
    print("제목: ${_titleController.text.trim()}");
    print("설명: ${_descriptionController.text.trim()}");
    print("위치: ${_locationController.text.trim()}");
    if (_formKey.currentState!.validate()) {
      // 폼 유효성 검사
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
      // 데이터가 유효하면 다음 화면으로 이동
      if (context.mounted) // context가 유효한지 확인
      {
        _moveToHomeScheduleScreenOnlyDataTransmission(
          schedule: scheduleData,
          idx: _selectedIndex, // 현재 선택된 인덱스 전달
          mode: currentMode, // 현재 모드 정보 전달
        );
        _selectedIndex++; // 인덱스 증가
      }
    } else {
      // 데이터가 유효하지 않으면 에러 메시지 표시
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

  // 날짜/시간 선택 섹션 위젯
  Widget _buildTimeSection(String currentMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "선택된 날짜/시간: ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} "
          "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(width: 12),
        ElevatedButton(
          onPressed: () => _showDatePicker(context),
          child: Text(currentMode == "edit" ? "날짜/시간 수정" : "날짜/시간 선택"),
        ),
      ],
    );
  }

  // 홈 화면으로 이동하면서 데이터 전송
  Future<void> _moveToHomeScheduleScreenOnlyDataTransmission({
    Map<String, dynamic>? schedule,
    int? idx,
    String mode = "add", // 기본 모드는 'add'
  }) async {
    print(
      "===== _moveToHomeScheduleScreenOnlyDataTransmission : checkData ===========",
    );
    _checkCurrentDataForAddScreen();
    schedule ??= {
      "title": "새로운 일정",
      "date": DateTime.now(),
      "description": "일정 설명",
      "location": "장소",
      "isCompleted": false,
    };
    idx ??= 0; // 현재 인덱스는 리스트의 길이, 임시

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("일정을 추가하였습니다.")));
    // 데이터 받아서 scheduleList에 추가 > 반영 필요
    Navigator.pop(context, {
      "data": scheduleData,
      "mode": currentMode,
      "selectedIndex": _selectedIndex,
    });
    print("schedule: $schedule");
    if (schedule.isEmpty || schedule is! Map<String, dynamic>) {
      // result가 null이거나 Map<String, dynamic> 타입이 아닐 경우
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
