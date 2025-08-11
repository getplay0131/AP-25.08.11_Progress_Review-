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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State createState() => _HomeScreenState();
}

enum ScheduleMode { add, edit, delete, view }

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // 데이터
  Map<String, dynamic> schedule = {
    "title": "일정 1",
    "date": DateTime.now(),
    "description": "일정 1 설명",
    "location": "장소 1",
    "isCompleted": false,
  };
  List<Map<String, dynamic>> scheduleList = [];

  // 모드 상태
  String currentMode = "";
  bool switchToEditMode = false;
  bool switchToDeleteMode = false;
  bool switchToAddMode = false;
  bool switchToViewMode = false;
  int selectedIndex = 0;

  // 애니메이션 컨트롤러 (FAB/헤더 등)
  late final AnimationController _headerController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  late final Animation<double> _headerFade = CurvedAnimation(
    parent: _headerController,
    curve: Curves.easeOutCubic,
  );

  void _checkCurrentMode() {
    print("===== 현재 모드 확인 =====");
    print("현재 모드: $currentMode");
    print("추가 모드: $switchToAddMode");
    print("수정 모드: $switchToEditMode");
    print("삭제 모드: $switchToDeleteMode");
    print("상세 보기 모드: $switchToViewMode");
  }

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
      }
    });
    print("모드 전환 완료! 현재 모드: $Mode");
    _checkCurrentMode();
    print("===== _enableToMode end =====");
    _switchToMode();
  }

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
    _checkCurrentMode();
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
      ).showSnackBar(const SnackBar(content: Text("일정 추가 화면으로 이동!")));
      _MoveToAddScheduleScreenOnlyDataTransmission(
        schedule: scheduleList.isNotEmpty ? scheduleList[selectedIndex] : null,
        idx: selectedIndex,
        mode: "add",
      );
    } else if (currentMode == "edit") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("일정 수정 화면으로 이동!")));
      if (scheduleList.isNotEmpty) {
        _MoveToAddScheduleScreenOnlyDataTransmission(
          schedule: scheduleList[selectedIndex],
          idx: selectedIndex,
          mode: "edit",
        );
      }
    } else if (currentMode == "delete") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("일정 삭제 화면으로 이동!")));
      if (scheduleList.isNotEmpty) {
        _MoveToViewScheduleScreenOnlyDataTransmission(
          schedule: scheduleList[selectedIndex],
          idx: selectedIndex,
          mode: "delete",
        );
      }
    } else if (currentMode == "view") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("일정 상세보기 화면으로 이동!")));
      if (scheduleList.isNotEmpty) {
        _MoveToViewScheduleScreenOnlyDataTransmission(
          schedule: scheduleList[selectedIndex],
          idx: selectedIndex,
          mode: "view",
        );
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("잘못된 모드가 선택되었습니다!")));
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
    _headerController.forward();
  }

  // 공통 UI 요소: 색상/스타일
  Color get _bgColor => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF0F1115)
      : const Color(0xFFF6F7F9);
  Color get _cardColor => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF161A20)
      : Colors.white;
  Color get _primary => const Color(0xFF22C55E);
  Color get _warning => const Color(0xFFFFB020);
  Color get _danger => const Color(0xFFEF4444);
  Color get _info => const Color(0xFF3B82F6);
  Color get _muted => Theme.of(context).brightness == Brightness.dark
      ? Colors.white70
      : Colors.black87;

  ButtonStyle get _tonalButtonStyle => FilledButton.styleFrom(
    foregroundColor: Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black,
    backgroundColor: Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF20242C)
        : Colors.grey,
    textStyle: const TextStyle(fontWeight: FontWeight.w600),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  ButtonStyle _modeChipStyle(Color color) => OutlinedButton.styleFrom(
    foregroundColor: color,
    side: BorderSide(color: color.withOpacity(0.6), width: 1.2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    textStyle: const TextStyle(fontWeight: FontWeight.bold),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );

  // 모드 토글 로직은 유지하되, UI 피드백 개선
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
    HapticFeedback.selectionClick();
    _checkCurrentMode();
    print("===== __toggleMode end =====");
  }

  // 액션: 완료 토글
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
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: scheduleList[idx]['isCompleted'] ? _primary : _warning,
      ),
    );
  }

  Future _MoveToAddScheduleScreenOnlyDataTransmission({
    Map? schedule,
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

  Future _MoveToViewScheduleScreenOnlyDataTransmission({
    Map? schedule,
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
      final confirm = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("일정 삭제"),
          content: const Text("정말로 일정을 삭제하시겠습니까?"),
          actions: [
            TextButton(
              child: const Text("취소"),
              onPressed: () => Navigator.pop(context, false),
            ),
            FilledButton(
              child: const Text("삭제"),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );
      if (confirm == true) {
        setState(() {
          scheduleList.removeAt(idx!);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("일정이 삭제되었습니다."),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            backgroundColor: _danger,
          ),
        );
      }
    }
    print("===== _MoveToViewScheduleScreenOnlyDataTransmission end =====");
  }

  // 상단 헤더: 통계/필터/모드 상태 표시
  Widget _headerCard() {
    final total = scheduleList.length;
    final done = scheduleList.where((e) => e['isCompleted'] == true).length;
    final progress = total == 0 ? 0.0 : done / total;

    String modeLabel;
    Color modeColor;
    IconData modeIcon;
    if (switchToEditMode) {
      modeLabel = "수정 모드";
      modeColor = _info;
      modeIcon = Icons.edit_rounded;
    } else if (switchToDeleteMode) {
      modeLabel = "삭제 모드";
      modeColor = _danger;
      modeIcon = Icons.delete_rounded;
    } else if (switchToViewMode) {
      modeLabel = "상세 모드";
      modeColor = _primary;
      modeIcon = Icons.visibility_rounded;
    } else {
      modeLabel = "기본 모드";
      modeColor = _muted;
      modeIcon = Icons.dashboard_customize_rounded;
    }

    return FadeTransition(
      opacity: _headerFade,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Theme.of(context).brightness == Brightness.dark
                ? [const Color(0xFF17202A), const Color(0xFF151A22)]
                : [Colors.white, const Color(0xFFF9FBFF)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.06,
              ),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF252A33)
                : const Color(0xFFEFEFEF),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(modeIcon, color: modeColor, size: 22),
                const SizedBox(width: 8),
                Text(
                  "일정 관리",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    letterSpacing: 0.5,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                const Spacer(),
                _modeSegmented(),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.list_alt, color: _info, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        "$total개",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: _primary, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        "$done개",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.percent, color: _warning, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        "${((progress) * 100).toStringAsFixed(0)}%",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(modeIcon, color: modeColor, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        modeLabel,
                        style: TextStyle(
                          color: modeColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                color: _primary,
                backgroundColor: _primary.withOpacity(0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statPill(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1D222B)
            : const Color(0xFFF2F5F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF2A2F39)
              : const Color(0xFFE6EAF0),
        ),
      ),
      child: Row(
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: _muted, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // 모드 변경 버튼을 세그먼트로 리디자인
  Widget _modeSegmented() {
    final items = [
      ("수정", Icons.edit_rounded, _info, switchToEditMode),
      ("삭제", Icons.delete_rounded, _danger, switchToDeleteMode),
      ("상세", Icons.visibility_rounded, _primary, switchToViewMode),
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1A1F27)
            : const Color(0xFFF5F7FA),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF2A303A)
              : const Color(0xFFE7ECF3),
        ),
      ),
      child: Expanded(
        child: Row(
          children: items.map((e) {
            final isActive = e.$4;
            return InkWell(
              onTap: () {
                setState(() {
                  switchToEditMode = e.$1 == "수정";
                  switchToDeleteMode = e.$1 == "삭제";
                  switchToViewMode = e.$1 == "상세";
                  currentMode = switchToEditMode
                      ? "edit"
                      : switchToDeleteMode
                      ? "delete"
                      : switchToViewMode
                      ? "view"
                      : "";
                });
                HapticFeedback.lightImpact();
              },
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? e.$3.withOpacity(0.12) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(e.$2, size: 18, color: isActive ? e.$3 : _muted),
                    const SizedBox(width: 4),
                    Text(
                      e.$1,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: isActive ? e.$3 : _muted,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // 기존 _changeCurrentModeButton 대체 (호출부 유지하려면 래핑)
  Widget _changeCurrentModeButton() {
    // 기존 시그니처 유지 위해 모드 토글 버튼도 제공
    String buttonText;
    Color buttonColor;

    if (switchToEditMode) {
      buttonText = "수정";
      buttonColor = _info;
    } else if (switchToDeleteMode) {
      buttonText = "삭제";
      buttonColor = _danger;
    } else if (switchToViewMode) {
      buttonText = "상세";
      buttonColor = _primary;
    } else {
      buttonText = "모드";
      buttonColor = _muted;
    }

    return OutlinedButton.icon(
      onPressed: _toggleMode,
      icon: Icon(Icons.tune_rounded, size: 18, color: buttonColor),
      label: Text(buttonText),
      style: _modeChipStyle(buttonColor),
    );
  }

  Widget _modeResetBtn() {
    return FilledButton.tonal(
      onPressed: () async {
        final confirm = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("모드 초기화"),
            content: const Text("정말로 모드를 초기화하시겠습니까?"),
            actions: [
              TextButton(
                child: const Text("취소"),
                onPressed: () => Navigator.pop(context, false),
              ),
              FilledButton(
                child: const Text("확인"),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        );
        if (confirm == true) {
          _resetMode();
          HapticFeedback.selectionClick();
        }
      },
      style: _tonalButtonStyle,
      child: const Text("모드 초기화"),
    );
  }

  Widget _deleteAllScheduleData() {
    return FilledButton(
      onPressed: () async {
        final confirm = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("전체 삭제"),
            content: const Text("모든 일정을 삭제하시겠습니까?"),
            actions: [
              TextButton(
                child: const Text("취소"),
                onPressed: () => Navigator.pop(context, false),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: _danger),
                child: const Text("삭제"),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        );
        if (confirm == true) {
          setState(() {
            scheduleList.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("모든 일정이 삭제되었습니다."),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              backgroundColor: _danger,
            ),
          );
        }
      },
      style: FilledButton.styleFrom(
        backgroundColor: _danger,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text("전체 삭제"),
    );
  }

  // 일정 카드: 모던 글래스/네오모피즘 느낌
  Widget _scheduleCard(Map schedule, int idx) {
    final isDone = schedule['isCompleted'] == true;
    final accent = isDone ? _primary : _muted;
    final iconBg = isDone
        ? _primary.withOpacity(0.15)
        : (_info.withOpacity(0.12));
    final iconColor = isDone ? _primary : _info;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Card(
        key: ValueKey("${schedule['title']}_$idx${schedule['isCompleted']}"),
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: _cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            print("ListTile tapped! idx: $idx");
            _checkCurrentData();
            _switchToMode();
            _changeToTargetMode(idx: idx);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: iconColor.withOpacity(0.2)),
                  ),
                  child: Icon(
                    isDone ? Icons.check_rounded : Icons.event_note_rounded,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              schedule['title'] ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isDone
                                  ? _primary.withOpacity(0.12)
                                  : _warning.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: (isDone ? _primary : _warning)
                                    .withOpacity(0.25),
                              ),
                            ),
                            child: Text(
                              isDone ? "완료" : "진행중",
                              style: TextStyle(
                                color: isDone ? _primary : _warning,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.schedule_rounded, size: 16, color: _muted),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _formatDate(schedule['date']),
                              style: TextStyle(fontSize: 13, color: _muted),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.place_rounded, size: 16, color: _muted),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              schedule['location'] ?? "",
                              style: TextStyle(fontSize: 13, color: _muted),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        schedule['description'] ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _quickActionChip(
                            icon: Icons.visibility_rounded,
                            label: "보기",
                            color: _primary,
                            onTap: () {
                              _enableToMode(ScheduleMode.view);
                              _changeToTargetMode(idx: idx);
                            },
                          ),
                          const SizedBox(width: 8),
                          _quickActionChip(
                            icon: Icons.edit_rounded,
                            label: "수정",
                            color: _info,
                            onTap: () {
                              _enableToMode(ScheduleMode.edit);
                              _changeToTargetMode(idx: idx);
                            },
                          ),
                          const SizedBox(width: 8),
                          _quickActionChip(
                            icon: Icons.delete_rounded,
                            label: "삭제",
                            color: _danger,
                            onTap: () {
                              _enableToMode(ScheduleMode.delete);
                              _changeToTargetMode(idx: idx);
                            },
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => _toggleCompletionStatus(idx),
                            tooltip: "완료 토글",
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                key: ValueKey(isDone),
                                isDone
                                    ? Icons.check_circle_rounded
                                    : Icons.check_circle_outline_rounded,
                                color: isDone ? _primary : _muted,
                                size: 26,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _quickActionChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date is DateTime) {
      final d = date.toLocal();
      return "${d.year}-${_two(d.month)}-${_two(d.day)} ${_two(d.hour)}:${_two(d.minute)}";
    }
    return "$date";
  }

  String _two(int v) => v.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _bgColor,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            children: [
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: _primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.calendar_month_rounded, color: _primary),
              ),
              const SizedBox(width: 10),
              Text(
                "일정 관리",
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            tooltip: "모드 순환",
            onPressed: _toggleMode,
            icon: Icon(
              Icons.tune_rounded,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _headerCard(),
            const SizedBox(height: 8),
            Expanded(
              child: scheduleList.isEmpty
                  ? _emptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 140),
                      itemCount: scheduleList.length,
                      itemBuilder: (context, idx) {
                        return _scheduleCard(scheduleList[idx], idx);
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _bgColor,
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? const Color(0xFF232936)
                        : const Color(0xFFE9EDF3),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_modeResetBtn(), _deleteAllScheduleData()],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _animatedFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _animatedFAB() {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("일정 추가 화면으로 이동!"),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16),
            ),
          );
          _enableToMode(ScheduleMode.add);
          _changeToTargetMode();
        },
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          "일정 추가",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _primary,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 96,
              width: 96,
              decoration: BoxDecoration(
                color: _primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.inbox_rounded, color: _primary, size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              "등록된 일정이 없습니다.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "오른쪽 아래의 ‘일정 추가’ 버튼을 눌러 첫 일정을 만들어 보세요!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: _muted),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                _enableToMode(ScheduleMode.add);
                _changeToTargetMode();
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text("일정 추가"),
              style: FilledButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
