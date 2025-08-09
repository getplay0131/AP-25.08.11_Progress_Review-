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
// TODO : 일정 상세보기 데이터 전달 문제 발견 ! > 해당 스케줄을 전달할수 있도록 수정하기 > 완료! 버튼 수정하기! > 프로젝트 완료!
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum ScheduleMode {
  // 일정 모드를 안정성을 위해 이넘으로 관리
  add, // 일정 추가 모드
  edit, // 일정 수정 모드
  delete, // 일정 삭제 모드
  view, // 일정 상세 보기 모드
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> schedule = {
    "title": "일정 1",
    "date": DateTime.now(),
    "description": "일정 1 설명",
    "location": "장소 1",
    "isCompleted": false,
  };
  List<Map<String, dynamic>> scheduleList = []; // 일정 데이터를 저장할 리스트

  String currentMode =
      ""; // add > 일정 추가 모드, edit > 일정 수정 모드, delete > 일정 삭제 모드,

  bool switchToEditMode = false; // false > 비활성화, true > 일정 수정 모드

  bool switchToDeleteMode = false; // false > 비활성화, true > 일정 삭제 모드

  bool switchToAddMode = false; // false > 비활성화, true > 일정 상세 보기 모드

  bool switchToViewMode = false; // false > 비활성화, true > 일정 상세 보기 모드

  int selectedIndex = 0; // 현재 선택된 인덱스

  void _checkCurrentMode() {
    // 현재 모드 확인 함수
    print("===== 현재 모드 확인 =====");
    print("현재 모드: $currentMode");
    print("추가 모드: $switchToAddMode");
    print("수정 모드: $switchToEditMode");
    print("삭제 모드: $switchToDeleteMode");
    print("상세 보기 모드: $switchToViewMode");
  }

  void _enableToMode(ScheduleMode Mode) {
    print("===== _enableToMode called =====");
    // 현재 모드에 따라 버튼의 텍스트를 변경
    print("모드 전환 시작! 현재 모드: $Mode");
    setState(() {
      switch (Mode) {
        case ScheduleMode.add:
          switchToAddMode = true;
          switchToEditMode = false;
          switchToDeleteMode = false;
          switchToViewMode = false;
          print("추가 모드로 전환되었습니다!");
          break;
        case ScheduleMode.edit:
          switchToAddMode = false;
          switchToEditMode = true;
          switchToDeleteMode = false;
          switchToViewMode = false;
          print("수정 모드로 전환되었습니다!");
          break;
        case ScheduleMode.delete:
          switchToAddMode = false;
          switchToEditMode = false;
          switchToDeleteMode = true;
          switchToViewMode = false;
          print("삭제 모드로 전환되었습니다!");
          break;
        case ScheduleMode.view:
          switchToAddMode = false;
          switchToEditMode = false;
          switchToDeleteMode = false;
          switchToViewMode = true;
          print("상세 보기 모드로 전환되었습니다!");
          break;
        default:
          print("잘못된 모드가 선택되었습니다!");
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("잘못된 모드가 선택되었습니다!")));
          return; // 잘못된 모드가 선택된 경우 함수 종료
      }
    });
    print("모드 전환 완료! 현재 모드: $Mode");
    _checkCurrentMode(); // 현재 모드 확인 함수 호출
    print("===== _enableToMode end =====");
    _switchToMode();
  }

  // 커런트 모드에 모드 값 입력
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

  // 해당 모드로 전환하는 함수
  void _changeToTargetMode({int? idx = 0}) {
    print("===== changeToTargetMode called =====");
    if (idx == null) {
      // 선택된 인덱스가 null인 경우
      print("선택된 인덱스가 null입니다. 기본값 0으로 설정합니다.");
    } else {
      setState(() {
        selectedIndex = idx; // 선택된 인덱스 저장
        print("선택된 인덱스: $selectedIndex");
      });
    }

    if (currentMode == "add") {
      // 추가 모드 또는 수정 모드일 때
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("일정 추가 화면으로 이동합니다!")));
      _MoveToAddScheduleScreenOnlyDataTransmission(
        schedule: schedule,
        idx: selectedIndex,
        mode: currentMode, // 추가 모드임을 알리기 위한 인자
      );
    } else if (currentMode == "edit") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("일정 수정 화면으로 이동합니다!")));
      _MoveToAddScheduleScreenOnlyDataTransmission(
        schedule: schedule[selectedIndex],
        idx: selectedIndex,
        mode: currentMode, // 추가 모드임을 알리기 위한 인자
      );
    } else if (currentMode == "delete") {
      // 삭제 모드일 때
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("일정 삭제 화면으로 이동합니다!")));
      _MoveToViewScheduleScreenOnlyDataTransmission(
        schedule: schedule,
        idx: selectedIndex,
        mode: currentMode, // 상세 보기 모드임을 알리기 위한 인자
      );
    } else if (currentMode == "view") {
      // 상세 보기 모드일 때
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("상세 보기 모드로 전환!")));
      _MoveToViewScheduleScreenOnlyDataTransmission(
        schedule: schedule,
        idx: selectedIndex,
        mode: currentMode, // 상세 보기 모드임을 알리기 위한 인자
      );
    } else {
      // 잘못된 모드가 선택된 경우
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("잘못된 모드가 선택되었습니다!")));
      print("잘못된 모드가 선택되었습니다!");
      _resetMode(); // 모드 초기화
    }
    _resetMode(); // 모드 초기화 함수 호출 > 안정성 위해 모드 초기화
    _checkCurrentMode(); // 현재 모드 확인 함수 호출
    print("===== changeToTargetMode end =====");
  }

  void _resetMode() {
    // 모드 초기화 함수
    setState(() {
      switchToAddMode = false;
      switchToEditMode = false;
      switchToDeleteMode = false;
      switchToViewMode = false;
      currentMode = ""; // 초기 모드 설정
      print("모드가 초기화되었습니다!");
    });
  }

  // 화면 생성시 호출되는 메서드
  // 위젯이 처음 생성될 때 호출되며, 상태를 초기화하는 데 사용됩니다.
  // 이 메서드는 위젯이 처음 빌드될 때 호출되며, 상태를 초기화하는 데 사용됩니다.
  // 위젯이 처음 생성될 때 호출되며, 상태를 초기화하는 데 사용됩니다.
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("===== home screen didChangeDependencies called =====");
    var args = ModalRoute.of(context)?.settings.arguments;
    print("args type: ${args.runtimeType}");
    print("args: $args");
    print("args is null : ${args == null}");
    // scheduleList.add(schedule);
    _printCurrentData(); // 데이터 출력 함수 호출
  }

  // 디버깅용 메서드
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

  // 현재 데이터 확인
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

  // 스테이트 초기화 메서드
  // 화면이 생성될 때 한 번만 호출되며, 위젯이 처음 생성될 때 실행됩니다.
  // 이 메서드는 위젯이 처음 빌드될 때 호출되며, 상태를 초기화하는 데 사용됩니다.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("===== home screen initState called =====");
    // 초기 일정 데이터 추가
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

  // 모드 초기화 버튼
  Widget _modeResetBtn() {
    return ElevatedButton(
      onPressed: () async {
        final confirm = await showDialog<bool>(
          // 다이얼로그로 확인 받기
          context: context,
          builder: (context) => AlertDialog(
            title: Text("모드 초기화 하기!"),
            content: Text("정말로 모드를 초기화 하시겠습니까?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("취소"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("확인"),
              ),
            ],
          ),
        );
        if (confirm == true) {
          // 확인 버튼을 누른 경우
          _resetMode();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("모드가 초기화 되었습니다!")));
          print("모드가 초기화 되었습니다!");
        }
      },
      child: Text("모드 초기화 하기!"),
    );
  }

  // 모든 일정 데이터 삭제 버튼
  Widget _deleteAllScheduleData() {
    // 현재 모드에 따라 버튼을 표시
    return ElevatedButton(
      onPressed: () async {
        final confirm = await showDialog<bool>(
          // 다이얼로그로 확인 받기
          context: context,
          builder: (context) => AlertDialog(
            title: Text("일정 데이터 삭제"),
            content: Text("모든 일정을 삭제하시겠습니까?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("취소"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("확인"),
              ),
            ],
          ),
        );
        if (confirm == true) {
          // 확인 버튼을 누른 경우
          setState(() {
            scheduleList.clear(); // 모든 일정 데이터 삭제
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("모든 일정이 삭제되었습니다.")));
          print("모든 일정이 삭제되었습니다.");
        }
      },
      child: Text("모든 일정 삭제"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // 버튼 색상 변경
      ),
    );
  }

  // 모드 토글 함수
  void _toggleMode() {
    //   그 과정에서 해당 모드 활성화와 비활성화 상태를 변경함
    print("===== __toggleMode called =====");
    setState(() {
      if (switchToEditMode) {
        _resetMode();
        switchToDeleteMode = true;
        print("삭제 모드가 활성화 되었습니다!");
      } else if (switchToDeleteMode) {
        _resetMode();
        switchToViewMode = true; // 상세 보기 모드로 전환
        print("상세 보기 모드가 활성화되었습니다!");
      } else if (switchToViewMode) {
        _resetMode();
        switchToEditMode = true;
        print("수정 모드가 활성화되었습니다!");
      } else {
        _resetMode();
        switchToEditMode = true; // 수정 모드로 전환
        print("수정 모드가 활성화되었습니다!");
      }
    });
    _checkCurrentMode(); // 현재 모드 확인 함수 호출
    print("===== __toggleMode end =====");
  }

  Widget _changeCurrentModeButton() {
    // 현재 모드에 따라 버튼 텍스트, 색상, 동작을 동적으로 변경
    String buttonText;
    Color buttonColor;

    if (switchToEditMode) {
      buttonText = "수정 모드";
      buttonColor = Colors.blue;
    } else if (switchToDeleteMode) {
      buttonText = "삭제 모드";
      buttonColor = Colors.red;
    } else if (switchToViewMode) {
      buttonText = "상세 보기 모드";
      buttonColor = Colors.green;
    } else {
      buttonText = "모드 선택";
      buttonColor = Colors.grey;
    }

    return ElevatedButton(
      onPressed: () {
        _toggleMode();
      },
      child: Text(buttonText, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
    );
  }

  // 완료 토글 함수
  // 사용자가 리스트 타일의 trailing의 아이콘을 터치시 완료 상태를 토글하며, 현재 스케줄에 반영한다.
  void _toggleCompletionStatus(int idx) {
    setState(() {
      scheduleList[idx]['isCompleted'] =
          !scheduleList[idx]['isCompleted']; // 완료 상태 토글
      print("일정 완료 상태가 변경되었습니다! 현재 상태: ${scheduleList[idx]['isCompleted']}");
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "일정 완료 상태가 변경되었습니다! 현재 상태: ${scheduleList[idx]['isCompleted']}",
        ),
      ),
    );
  }

  // 일정 추가 화면으로 이동하는 메서드
  Future<void> _MoveToAddScheduleScreenOnlyDataTransmission({
    Map<String, dynamic>? schedule,
    int? idx,
    String? mode, // 기본값은 "add"로 설정
  }) async {
    // 메서드 시작 구분선
    print("===== _MoveToAddScheduleScreenOnlyDataTransmission called =====");
    schedule ??= {
      // 널일때를 대비해 기본값 설정
      "title": "새로운 일정",
      "date": DateTime.now(),
      "description": "일정 설명",
      "location": "장소",
      "isCompleted": false,
      // "isEditMode": false, // 수정 모드 여부 추가
    };
    idx ??= scheduleList.length; // 현재 인덱스는 리스트의 길이
    mode ??= "add"; // 기본 모드는 "add"

    print("일정 추가 버튼이 눌렸습니다! mode: $mode, idx: $idx");
    print("일정 추가 데이터: $schedule");
    print("일정 추가 인덱스: $idx");
    print("일정 추가 모드: $mode");
    print("일정 추가 scheduleList: $scheduleList");

    // 모드가 애드라면 일정 추가 화면으로 이동, 에딧이라면 네비게이터 푸쉬네임드로 아규먼트를 전달함. 이 과정에서 스캐폴드메신저와 프린트로 디버깅 진행
    if (mode == "add") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("일정 추가 버튼이 눌렸습니다!")));
      _checkCurrentData();
      // 데이터 받아서 scheduleList에 추가 > 반영 필요
      var result = await Navigator.pushNamed(
        context,
        '/schedule_add',
        arguments: {
          "mode": mode, // 애드 모드임을 알리기 위한 인자
          "selectedIndex": idx, // 현재 인덱스 전달
          "data": schedule, // 현재 일정 데이터 전달
        },
      );
      if (result == null || result is! Map<String, dynamic>) {
        // result가 null이거나 Map<String, dynamic> 타입이 아닐 경우
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("일정 추가에 실패했습니다!")));
        print("일정 추가에 실패했습니다. result: $result");
      } else {
        // result가 Map<String, dynamic> 타입인 경우
        scheduleList.add(result["data"]); // 추가된 데이터를 리스트에 반영
        print("일정 추가 성공! 현재 일정 리스트: $scheduleList");
      }
    } else if (mode == "edit") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("일정 수정 버튼이 눌렸습니다!")));
      _checkCurrentData();
      // 데이터 받아서 scheduleList에 추가 > 반영 필요
      var result = await Navigator.pushNamed(
        context,
        '/schedule_add',
        arguments: {
          "mode": mode, // 애드 모드임을 알리기 위한 인자
          "selectedIndex": idx, // 현재 인덱스 전달
          "data": scheduleList[selectedIndex], // 현재 일정 데이터 전달
        },
      );
      if (result == null || result is! Map<String, dynamic>) {
        // result가 null이거나 Map<String, dynamic> 타입이 아닐 경우
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("일정 수정에 실패했습니다!")));
        print("일정 수정에 실패했습니다. result: $result");
      } else {
        scheduleList[idx] = result["data"]; // 수정된 데이터를 리스트에 반영
        print("일정 수정 성공! 현재 일정 리스트: $scheduleList");
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("잘못된 값이 입력되었습니다!")));
      print("잘못된 값이 입력되었습니다. mode: $mode");
    }
    // 메서드 끝 구분선
    print("===== _MoveToAddScheduleScreenOnlyDataTransmission end =====");
  }

  // 상세보기 화면으로 이동하는 메서드
  Future<void> _MoveToViewScheduleScreenOnlyDataTransmission({
    Map<String, dynamic>? schedule,
    int? idx,
    String? mode = "view", // 기본값은 "add"로 설정
  }) async {
    // 메서드 시작 구분선
    print("===== _MoveToViewScheduleScreenOnlyDataTransmission called =====");
    schedule ??= {
      "title": "새로운 일정",
      "date": DateTime.now(),
      "description": "일정 설명",
      "location": "장소",
      "isCompleted": false,
    };
    idx ??= scheduleList.length; // 현재 인덱스는 리스트의 길이
    mode ??= "view"; // 기본 모드는 "view"
    if (mode == "view") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("일정 상세 보기 버튼이 눌렸습니다!")));
      _checkCurrentData();
      // 데이터 받아서 scheduleList에 추가 > 반영 필요
      var result = await Navigator.pushNamed(
        context,
        '/schedule_content',
        arguments: {
          "mode": mode, // 상세 보기 모드임을 알리기 위한 인자
          "selectedIndex": idx, // 현재 인덱스 전달
          "data": scheduleList[selectedIndex], // 현재 일정 데이터 전달
        },
      );
      if (result == null || result is! Map<String, dynamic>) {
        // result가 null이거나 Map<String, dynamic> 타입이 아닐 경우
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("일정 상세 보기에 실패했습니다!")));
        print("일정 상세 보기에 실패했습니다. result: $result");
      }
    } else if (mode == "delete") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("일정 삭제 버튼이 눌렸습니다!")));
      _checkCurrentData();
      // 다이어로그로 확인이나 취소를 선택받으며 데이터 삭제할지 여부를 결정함
      // 확인이면 트루, 취소면 펄스
      // 확인시 삭제된 데이터를 리스트에서 제거
      // 취소시 아무 동작도 하지 않음
      // 이 과정에서 스캐폴드메신저와 프린트로 디버깅 진행
      // 다이어로그로 확인이나 취소를 선택받으며 데이터 삭제할지 여부를 결정함
      bool? confirmDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("일정 삭제"),
          content: Text("정말로 이 일정을 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("취소"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("확인"),
            ),
          ],
        ),
      );
      if (confirmDelete == true) {
        // 확인시 삭제된 데이터를 리스트에서 제거
        scheduleList.removeAt(idx);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("일정이 삭제되었습니다.")));
        print("일정 삭제 성공! 현재 일정 리스트: $scheduleList");
      } else {
        // 취소시 아무 동작도 하지 않음
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("일정 삭제가 취소되었습니다.")));
        print("일정 삭제가 취소되었습니다.");
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("잘못된 값이 입력되었습니다!")));
      print("잘못된 값이 입력되었습니다. mode: $mode");
    }
    // 메서드 끝 구분선
    print("===== _MoveToViewScheduleScreenOnlyDataTransmission end =====");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "개인 일정 관리 앱!",
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: ListView.builder(
                // ListView.builder를 사용하여 동적으로 리스트 생성
                itemCount: scheduleList.length,
                itemBuilder: (context, idx) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      // 위젯 트리 빌드 후 상태 변경
                      // 상태 변경
                      selectedIndex = idx; // 현재 선택된 인덱스 저장
                    });
                  });
                  // print("selectedIndex: $selectedIndex");
                  var schedule = scheduleList[idx];
                  // _addSchedule(schedule, idx);
                  return ListTile(
                    // 각 일정 항목을 표시하는 ListTile 위젯
                    title: Text(schedule['title']),
                    subtitle: Text(
                      "${schedule['date'].toLocal()} - ${schedule['description']}",
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        _toggleCompletionStatus(idx);
                      },
                      icon: Icon(
                        schedule['isCompleted']
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: schedule['isCompleted']
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ),
                    onTap: () {
                      print("ListTile tapped! idx: $idx");
                      _checkCurrentData();
                      _switchToMode();
                      _changeToTargetMode(idx: idx);
                      // 엘리베이티드 버튼으로 삭제 기능 구현 > isDeleteMode가 true일 때만 삭제 다이어 로그로 선택받고 이 과정이 비동기기므로 await로 처리하며 삭제 선택시 상세 보기 모드로 이동하여 저장된 데이터 삭제 후 삭제 완료 다이어 로그 표현
                    },
                    leading: _changeCurrentModeButton(),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_modeResetBtn(), _deleteAllScheduleData()],
            ), // 현재 모드에 따라 버튼을 표시)
            SizedBox(height: 50),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("일정 추가 화면으로 이동!")));
          _enableToMode(ScheduleMode.add);
          _changeToTargetMode(); // 현재 모드에 따라 일정 추가 화면으로 이동
        },

        // 수정 모드시에는 수정 화면으로 이동, 추가 모드시에는 추가 화면으로 이동
        child: Icon(Icons.add),
        tooltip: "일정 추가",
        backgroundColor: Colors.green,
      ),
    );
  }
}
