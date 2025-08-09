import 'package:flutter/material.dart';

// 일정 추가시 일정 상세보기에 안넘어감 > 3일차에 디버깅 우선으로 해당 문제 해결과 복습 진행하기
// 25-07-26 할 일!
// TODO : 할일 수정 기능 구현하기
// 홈 스크린에 수정 또는 보기 기능 [클리어](상세보기 모드 클릭시 일정 상세 보기 화면으로 이동하며, 수정 모드는 수정 화면으로 이동하고 플로팅 버튼은 추가 화면으로 이동만 담당!)>
// 보기 기능일때는 기존 로직 유지 >
// 수정 기능일때는 수정 화면으로 이동  >
// 수정 화면은 추가 화면에 로직의 내용을 바꿔서 표시  >
// 수정 완료후 홈 스크린으로 돌아가기  >
// 이때 상세 내용에도 해당 내용이 전달 되어야 함
// 25-07-28 할일!
// TODO : 스크린 전환시 데이터 전달 무너짐 > 수정 필요!
// 25-07-29 할일!
// TODO : 에딧 모드 불리언 타입 값으로 통일! > 에딧모드와 커런트 모드로 관리!
// 25-07-30 할일!
// TODO : 추가 또는 수정화면에서 데이터 받기 및 전달 > 추가시 데이터 전달 완료! > 홈스크린에서 받는 부분 수정 필요!
// 25-07-31 할일!
// TODO : 홈 스크린에서 데이터 받는 부분 수정 > 추가시 데이터 전달 부분 수정하기! > 완료!
// 25-08-01 할일!
// TODO : 데이터 삭제 및 완료 토글 진행하기 > 로직 개선중 불가.. 이넘 vs 불리언 값 선택하기
// 25-08-02 할일!
// TODO : 데이터 삭제 및 완료 토글 진행하기 > 로직 불리언 또는 이넘으로 개선하고 삭제 과정 진행하기 > 40분 가량 진행 : 홈스크린 로직 개선 작업 진행중 > IDE 작업으로 인해 코딩에 영향 발생
// 25-08-03 할일!
// TODO : 개선 로직 통해 기본 동작 수행되도록 하기 > 동작함 > 단 수정 과 삭제 변환 로직 개선 필요
// 25-08-04 할일!
// TODO : 개선 로직 통해 기본 동작 수행되도록 하기 > 동작함 > 개선 하였으나 인덱스 잘못 가져오는 문제 발생
// 25-08-05 할일!
// TODO : 삭제 및 수정시 인덱스 활용하여  수정과 삭제 문제 해결하기
// 25-08-06 할일!
// TODO : 삭제 및 수정시 인덱스 활용하여 수정과 삭제 문제 해결 > 완료!
// 25-08-07 할일!
// TODO : 일정 상세보기 데이터 전달 문제 발견 ! > 리딩 버튼을 3가지 모드 순환하도록 개선 및 상세보기 화면으로 데이터 전달하도록 수정
// 25-08-08 할일!
// TODO : 일정 상세보기 데이터 전달 문제 발견 ! > 해당 스케줄을 전달할수 있도록 수정하기 > 완료! 버튼 수정하기!

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum ScheduleMode { add, edit, delete, view } // 안전성 위해 이넘 클래스 사용

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> schedule = {
    // 기본 일정 데이터
    "title": "일정 1",
    "date": DateTime.now(),
    "description": "일정 1 설명",
    "location": "장소 1",
    "isCompleted": false,
  };
  List<Map<String, dynamic>> scheduleList = []; // 일정을 저장할 리스트

  String currentMode = ""; // 현재 모드를 스트링 값으로 저장
  bool switchToEditMode = false;
  bool switchToDeleteMode = false;
  bool switchToAddMode = false;
  bool switchToViewMode = false;
  int selectedIndex = 0; // 선택된 인덱스

  void _checkCurrentMode() {
    // 현재 모드 확인 함수
    print("===== 현재 모드 확인 =====");
    print("현재 모드: $currentMode");
    print("추가 모드: $switchToAddMode");
    print("수정 모드: $switchToEditMode");
    print("삭제 모드: $switchToDeleteMode");
    print("상세 보기 모드: $switchToViewMode");
  }

  // 모드에 따라 불리언 플래그 활성화 및 관리
  void _enableToMode(ScheduleMode Mode) {
    print("===== _enableToMode called =====");
    print("모드 전환 시작! 현재 모드: $Mode");
    setState(() {
      switch (Mode) {
        case ScheduleMode.add:
          switchToAddMode = true;
          switchToEditMode = false;
          switchToDeleteMode = false;
          switchToViewMode = false;
          currentMode = "add";
          break;
        case ScheduleMode.edit:
          switchToAddMode = false;
          switchToEditMode = true;
          switchToDeleteMode = false;
          switchToViewMode = false;
          currentMode = "edit";
          break;
        case ScheduleMode.delete:
          switchToAddMode = false;
          switchToEditMode = false;
          switchToDeleteMode = true;
          switchToViewMode = false;
          currentMode = "delete";
          break;
        case ScheduleMode.view:
          switchToAddMode = false;
          switchToEditMode = false;
          switchToDeleteMode = false;
          switchToViewMode = true;
          currentMode = "view";
          break;
        default:
          switchToAddMode = false;
          switchToEditMode = false;
          switchToDeleteMode = false;
          switchToViewMode = false;
          currentMode = "";
      }
    });
    print("모드 전환 완료! 현재 모드: $Mode");
    _checkCurrentMode();
    print("===== _enableToMode end =====");
    _switchToMode(); // 불리언 플래그 활성화 함수 호출
  }

  //
  void _switchToMode() {
    print("===== switchToMode called =====");
    setState(() {
      if (switchToAddMode) {
        currentMode = ScheduleMode.add.name;
        print("현재 모드는 추가 모드 입니다!");
      } else if (switchToEditMode) {
        currentMode = ScheduleMode.edit.name;
        print("현재 모드는 수정 모드 입니다!");
      } else if (switchToDeleteMode) {
        currentMode = ScheduleMode.delete.name;
        print("현재 모드는 삭제 모드 입니다!");
      } else if (switchToViewMode) {
        currentMode = ScheduleMode.view.name;
        print("현재 모드는 상세 보기 모드 입니다!");
      }
    });
    _checkCurrentMode(); // 현재 모드 확인 함수 호출
    print("모드 전환 완료! 현재 모드: $currentMode");
    print("===== switchToMode end =====");
  }

  void _changeToTargetMode({int? idx = 0}) {
    print("===== changeToTargetMode called =====");
    if (idx == null) {
      print("선택된 인덱스가 null입니다. 기본값 0으로 설정합니다.");
    } else {
      setState(() {
        selectedIndex = idx!;
      });
    }

    if (currentMode == "add") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("일정 추가 화면으로 이동!")));
      _MoveToAddScheduleScreenOnlyDataTransmission(
        schedule: scheduleList[selectedIndex],
        idx: selectedIndex,
        mode: "add",
      );
    } else if (currentMode == "edit") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("일정 수정 화면으로 이동!")));
      _MoveToAddScheduleScreenOnlyDataTransmission(
        schedule: scheduleList[selectedIndex],
        idx: selectedIndex,
        mode: "edit",
      );
    } else if (currentMode == "delete") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("일정 삭제 화면으로 이동!")));
      _MoveToViewScheduleScreenOnlyDataTransmission(
        schedule: scheduleList[selectedIndex],
        idx: selectedIndex,
        mode: "delete",
      );
    } else if (currentMode == "view") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("일정 상세보기 화면으로 이동!")));
      _MoveToViewScheduleScreenOnlyDataTransmission(
        schedule: scheduleList[selectedIndex],
        idx: selectedIndex,
        mode: "view",
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("잘못된 모드가 선택되었습니다!")));
      print("잘못된 모드가 선택되었습니다!");
      _resetMode();
    }
    _resetMode();
    _checkCurrentMode();
    print("===== changeToTargetMode end =====");
  }

  void _resetMode() {
    setState(() {
      switchToAddMode = false;
      switchToEditMode = false;
      switchToDeleteMode = false;
      switchToViewMode = false;
      currentMode = "";
      print("모드가 초기화되었습니다!");
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("===== home screen didChangeDependencies called =====");
    var args = ModalRoute.of(context)?.settings.arguments;
    print("args type: ${args.runtimeType}");
    print("args: $args");
    print("args is null : ${args == null}");
    _printCurrentData();
  }

  void _printCurrentData() {
    print("===== home screen loading data =====");
    print("title: ${schedule["title"]}");
    print("date: ${schedule["date"]}");
    print("description: ${schedule["description"]}");
    print("location: ${schedule["location"]}");
    print("isCompleted: ${schedule["isCompleted"]}");
    print("currentMode: $currentMode");
    print("selectedIndex: $selectedIndex");
    print("========================================");
  }

  void _checkCurrentData() {
    print("===== home screen check data =====");
    print("title: ${schedule["title"]}");
    print("date: ${schedule["date"]}");
    print("description: ${schedule["description"]}");
    print("location: ${schedule["location"]}");
    print("isCompleted: ${schedule["isCompleted"]}");
    print("currentMode: $currentMode");
    print("selectedIndex: $selectedIndex");
    print("========================================");
  }

  @override
  void initState() {
    super.initState();
    print("===== home screen initState called =====");
    scheduleList.add(schedule);
    for (var schedules in scheduleList) {
      print("===== home screen initState scheduleList =====");
      print("title: ${schedules["title"]}");
      print("date: ${schedules["date"]}");
      print("description: ${schedules["description"]}");
      print("location: ${schedules["location"]}");
      print("isCompleted: ${schedules["isCompleted"]}");
      print("========================================");
    }
  }

  Widget _modeResetBtn() {
    return FilledButton.tonal(
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("모드 초기화"),
            content: Text("정말로 모드를 초기화하시겠습니까?"),
            actions: [
              TextButton(
                child: Text("취소"),
                onPressed: () => Navigator.pop(context, false),
              ),
              FilledButton(
                child: Text("확인"),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        );
        if (confirm == true) {
          _resetMode();
        }
      },
      child: Text("모드 초기화"),
      style: FilledButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey[200],
        textStyle: TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _deleteAllScheduleData() {
    return FilledButton(
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("전체 삭제"),
            content: Text("모든 일정을 삭제하시겠습니까?"),
            actions: [
              TextButton(
                child: Text("취소"),
                onPressed: () => Navigator.pop(context, false),
              ),
              FilledButton(
                child: Text("삭제"),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        );
        if (confirm == true) {
          setState(() {
            scheduleList.clear();
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("모든 일정이 삭제되었습니다.")));
        }
      },
      child: Text("전체 삭제"),
      style: FilledButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _toggleMode() {
    print("===== __toggleMode called =====");
    setState(() {
      if (switchToEditMode) {
        switchToEditMode = false;
        switchToDeleteMode = true;
        switchToViewMode = false;
        currentMode = "delete";
      } else if (switchToDeleteMode) {
        switchToEditMode = false;
        switchToDeleteMode = false;
        switchToViewMode = true;
        currentMode = "view";
      } else if (switchToViewMode) {
        switchToEditMode = true;
        switchToDeleteMode = false;
        switchToViewMode = false;
        currentMode = "edit";
      } else {
        switchToEditMode = true;
        switchToDeleteMode = false;
        switchToViewMode = false;
        currentMode = "edit";
      }
    });
    _checkCurrentMode();
    print("===== __toggleMode end =====");
  }

  Widget _changeCurrentModeButton() {
    String buttonText;
    Color buttonColor;

    if (switchToEditMode) {
      buttonText = "수정";
      buttonColor = Colors.blue;
    } else if (switchToDeleteMode) {
      buttonText = "삭제";
      buttonColor = Colors.red;
    } else if (switchToViewMode) {
      buttonText = "상세";
      buttonColor = Colors.green;
    } else {
      buttonText = "모드";
      buttonColor = Colors.grey;
    }

    return OutlinedButton(
      onPressed: _toggleMode,
      style: OutlinedButton.styleFrom(
        foregroundColor: buttonColor,
        side: BorderSide(color: buttonColor, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      child: Text(buttonText),
    );
  }

  void _toggleCompletionStatus(int idx) {
    setState(() {
      scheduleList[idx]['isCompleted'] = !scheduleList[idx]['isCompleted'];
      print("일정 완료 상태가 변경되었습니다! 현재 상태: ${scheduleList[idx]['isCompleted']}");
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          scheduleList[idx]['isCompleted']
              ? "일정이 완료되었습니다!"
              : "일정이 미완료로 변경되었습니다!",
        ),
        backgroundColor: scheduleList[idx]['isCompleted']
            ? Colors.green
            : Colors.orange,
      ),
    );
  }

  Future<void> _MoveToAddScheduleScreenOnlyDataTransmission({
    Map<String, dynamic>? schedule,
    int? idx,
    String? mode,
  }) async {
    print("===== _MoveToAddScheduleScreenOnlyDataTransmission called =====");
    schedule ??= {
      "title": "새로운 일정",
      "date": DateTime.now(),
      "description": "일정 설명",
      "location": "장소",
      "isCompleted": false,
    };
    idx ??= scheduleList.length;
    mode ??= "add";

    if (mode == "add") {
      final result = await Navigator.pushNamed(
        context,
        "/schedule_add",
        arguments: {"data": schedule, "mode": "add", "selectedIndex": idx},
      );
      if (result != null && result is Map) {
        setState(() {
          scheduleList.add(result["data"]);
        });
      }
    } else if (mode == "edit") {
      final result = await Navigator.pushNamed(
        context,
        "/schedule_add",
        arguments: {"data": schedule, "mode": "edit", "selectedIndex": idx},
      );
      if (result != null && result is Map) {
        setState(() {
          scheduleList[idx!] = result["data"];
        });
      }
    }
    print("===== _MoveToAddScheduleScreenOnlyDataTransmission end =====");
  }

  Future<void> _MoveToViewScheduleScreenOnlyDataTransmission({
    Map<String, dynamic>? schedule,
    int? idx,
    String? mode = "view",
  }) async {
    print("===== _MoveToViewScheduleScreenOnlyDataTransmission called =====");
    schedule ??= {
      "title": "새로운 일정",
      "date": DateTime.now(),
      "description": "일정 설명",
      "location": "장소",
      "isCompleted": false,
    };
    idx ??= scheduleList.length;
    mode ??= "view";
    if (mode == "view") {
      await Navigator.pushNamed(
        context,
        "/schedule_content",
        arguments: {"data": schedule, "selectedIndex": idx},
      );
    } else if (mode == "delete") {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("일정 삭제"),
          content: Text("정말로 일정을 삭제하시겠습니까?"),
          actions: [
            TextButton(
              child: Text("취소"),
              onPressed: () => Navigator.pop(context, false),
            ),
            FilledButton(
              child: Text("삭제"),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );
      if (confirm == true) {
        setState(() {
          scheduleList.removeAt(idx!);
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("일정이 삭제되었습니다.")));
      }
    }
    print("===== _MoveToViewScheduleScreenOnlyDataTransmission end =====");
  }

  Widget _scheduleCard(Map<String, dynamic> schedule, int idx) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        leading: CircleAvatar(
          backgroundColor: schedule['isCompleted']
              ? Colors.green
              : Colors.grey[300],
          child: Icon(
            schedule['isCompleted'] ? Icons.check : Icons.event_note,
            color: Colors.white,
          ),
        ),
        title: Text(
          schedule['title'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: schedule['isCompleted'] ? Colors.green[800] : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              "${schedule['date'].toLocal()}",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 2),
            Text(
              schedule['description'],
              style: TextStyle(fontSize: 15, color: Colors.grey[800]),
            ),
            SizedBox(height: 2),
            Text(
              "위치: ${schedule['location']}",
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () => _toggleCompletionStatus(idx),
          icon: Icon(
            schedule['isCompleted']
                ? Icons.check_circle
                : Icons.check_circle_outline,
            color: schedule['isCompleted'] ? Colors.green : Colors.grey,
            size: 28,
          ),
          tooltip: "완료 토글",
        ),
        onTap: () {
          print("ListTile tapped! idx: $idx");
          _checkCurrentData();
          _switchToMode();
          _changeToTargetMode(idx: idx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "일정 관리",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 26,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              margin: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "내 일정 (${scheduleList.length}개)",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.green[800],
                    ),
                  ),
                  _changeCurrentModeButton(),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: scheduleList.isEmpty
                  ? Center(
                      child: Text(
                        "등록된 일정이 없습니다.",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: scheduleList.length,
                      itemBuilder: (context, idx) {
                        return _scheduleCard(scheduleList[idx], idx);
                      },
                    ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_modeResetBtn(), _deleteAllScheduleData()],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("일정 추가 화면으로 이동!")));
          _enableToMode(ScheduleMode.add);
          _changeToTargetMode();
        },
        icon: Icon(Icons.add, color: Colors.white),
        label: Text("일정 추가", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
