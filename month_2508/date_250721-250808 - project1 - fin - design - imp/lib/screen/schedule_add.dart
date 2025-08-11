import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ScheduleAdd extends StatefulWidget {
  const ScheduleAdd({Key? key}) : super(key: key);

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

  String currentMode = "add"; // "add" | "edit"
  int _selectedIndex = 0;
  Map<String, dynamic> scheduleData = {};

  // 색상/스타일 유틸
  Color get _primary => const Color(0xFF22C55E);
  Color get _warning => const Color(0xFFFFB020);
  Color get _danger => const Color(0xFFEF4444);
  Color _bgColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF0F1115)
      : const Color(0xFFF6F7F9);
  Color _cardColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF161A20)
      : Colors.white;
  Color _muted(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? Colors.white70
      : Colors.black87;
  OutlineInputBorder _inputBorder(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: c, width: 1),
  );

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    print("ScheduleAdd initState called");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initScheduleData();
    print("ScheduleAdd didChangeDependencies called");
    _checkCurrentDataForAddScreenUsedidChangeDependencies();
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
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args["mode"] == "edit") {
      // 홈에서 넘겨준 포맷: {"data": ..., "mode": "edit", "selectedIndex": idx}
      final data = args["data"];
      final idx = args["selectedIndex"];
      if (data is Map<String, dynamic>) {
        scheduleData = data;
        title = data["title"] ?? "";
        date = (data["date"] is DateTime)
            ? data["date"] as DateTime
            : DateTime.now();
        description = data["description"] ?? "";
        location = data["location"] ?? "";
        isCompleted = data["isCompleted"] ?? false;
        _selectedIndex = (idx is int) ? idx : 0;
        currentMode = "edit";
        _titleController.text = title;
        _descriptionController.text = description;
        _locationController.text = location;
        print("수정 모드로 데이터 설정됨");
      } else {
        // 비정상 데이터 보호
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
        print("args 데이터 형식이 올바르지 않아 추가 모드로 전환");
      }
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
      print("초기값 설정됨 (추가 모드)");
    }
    print("===== _initScheduleData end =====");
  }

  Future<void> _showDatePicker(BuildContext context) async {
    DateTime tempPicked = date;
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (BuildContext builder) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          height: 360,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_calendar_rounded,
                      color: _primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      currentMode == "edit" ? "날짜/시간 수정" : "날짜/시간 선택",
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 220,
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      date = tempPicked;
                    });
                    Navigator.of(context).pop();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "확인",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  String _two(int v) => v.toString().padLeft(2, '0');
  String _formatDateTime(DateTime d) =>
      "${d.year}-${_two(d.month)}-${_two(d.day)} ${_two(d.hour)}:${_two(d.minute)}";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    print("===== ScheduleAdd build called =====");
    return Scaffold(
      backgroundColor: _bgColor(context),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _bgColor(context),
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
                child: Icon(
                  currentMode == "edit"
                      ? Icons.edit_calendar_rounded
                      : Icons.add_circle_rounded,
                  color: _primary,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                currentMode == "edit" ? "일정 수정하기" : "일정 추가하기",
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
            tooltip: "홈으로",
            onPressed: () {
              if (Navigator.canPop(context)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("홈 버튼이 눌렸습니다!"),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(16),
                  ),
                );
                Navigator.maybePop(context);
              }
            },
            icon: Icon(
              Icons.home_rounded,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _headerCard(context),
              const SizedBox(height: 12),
              _inputSectionCard(context),
              const SizedBox(height: 12),
              _metaSectionCard(context),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _collectAndValidateData,
                icon: const Icon(Icons.check_rounded),
                label: Text(currentMode == "edit" ? "일정 수정하기" : "일정 추가하기"),
                style: FilledButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  "현재 모드: ${currentMode == "edit" ? "수정 모드" : "추가 모드"}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _muted(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 상단 헤더 카드 (모드/요약)
  Widget _headerCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              Theme.of(context).brightness == Brightness.dark ? 0.28 : 0.06,
            ),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF252A33)
              : const Color(0xFFEFEFEF),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _primary.withOpacity(0.25)),
            ),
            child: Icon(
              currentMode == "edit"
                  ? Icons.mode_edit_rounded
                  : Icons.add_rounded,
              color: _primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentMode == "edit" ? "수정 모드" : "추가 모드",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentMode == "edit"
                      ? "기존 일정을 안전하게 수정하고 저장합니다."
                      : "새로운 일정을 빠르게 추가해 보세요.",
                  style: TextStyle(fontSize: 13, color: _muted(context)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 입력 폼 카드
  Widget _inputSectionCard(BuildContext context) {
    final baseFill = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF1C222B)
        : const Color(0xFFF6FAF7);
    final borderColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2A2F39)
        : const Color(0xFFE6EAEF);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 2),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "제목",
                prefixIcon: Icon(Icons.title_rounded, color: _primary),
                filled: true,
                fillColor: baseFill,
                border: _inputBorder(borderColor),
                enabledBorder: _inputBorder(borderColor),
                focusedBorder: _inputBorder(_primary),
              ),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return '제목을 입력해주세요.';
                if (value.trim().length > 20) return '제목은 20자 이내로 입력해주세요.';
                if (value.trim().length < 2) return '제목은 2자 이상 입력해주세요.';
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "설명",
                prefixIcon: Icon(Icons.description_rounded, color: _primary),
                filled: true,
                fillColor: baseFill,
                border: _inputBorder(borderColor),
                enabledBorder: _inputBorder(borderColor),
                focusedBorder: _inputBorder(_primary),
              ),
              maxLines: 3,
              minLines: 2,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return '설명을 입력해주세요.';
                if (value.trim().length < 2) return '설명은 2자 이상 입력해주세요.';
                if (value.trim().length > 100) return '설명은 100자 이내로 입력해주세요.';
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: "위치",
                prefixIcon: Icon(Icons.place_rounded, color: _primary),
                filled: true,
                fillColor: baseFill,
                border: _inputBorder(borderColor),
                enabledBorder: _inputBorder(borderColor),
                focusedBorder: _inputBorder(_primary),
              ),
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return '위치를 입력해주세요.';
                if (value.trim().length < 1) return '위치는 1자 이상 입력해주세요.';
                return null;
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // 날짜/완료여부 섹션 카드
  Widget _metaSectionCard(BuildContext context) {
    final borderColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2A2F39)
        : const Color(0xFFE6EAEF);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, color: _primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "선택된 날짜/시간: ${_formatDateTime(date)}",
                  style: TextStyle(
                    fontSize: 14,
                    color: _muted(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => _showDatePicker(context),
                icon: Icon(Icons.edit_calendar_rounded, color: _primary),
                label: Text(currentMode == "edit" ? "수정" : "선택"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primary,
                  side: BorderSide(color: _primary, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Transform.scale(
                scale: 1.05,
                child: Checkbox(
                  value: isCompleted,
                  activeColor: _primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  onChanged: (value) {
                    setState(() {
                      isCompleted = value ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "완료 여부",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _muted(context),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: (isCompleted ? _primary : _warning).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: (isCompleted ? _primary : _warning).withOpacity(
                      0.25,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.timelapse_rounded,
                      size: 16,
                      color: isCompleted ? _primary : _warning,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isCompleted ? "완료" : "진행중",
                      style: TextStyle(
                        color: isCompleted ? _primary : _warning,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _collectAndValidateData() {
    print("제목: ${_titleController.text.trim()}");
    print("설명: ${_descriptionController.text.trim()}");
    print("위치: ${_locationController.text.trim()}");

    final form = _formKey.currentState;
    if (form != null && form.validate()) {
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

      print("===== _collectAndValidateData : checkData ===========");
      _checkCurrentDataForAddScreen();

      if (!mounted) return;

      _moveToHomeScheduleScreenOnlyDataTransmission(
        schedule: scheduleData,
        idx: _selectedIndex,
        mode: currentMode,
      );

      // 입력값 초기화는 화면 유지 선호 시 제거 가능. 기존 로직 유지.
      _titleController.clear();
      _descriptionController.clear();
      _locationController.clear();

      _selectedIndex++;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("입력한 데이터를 확인해주세요."),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: _danger,
        ),
      );
    }
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

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mode == "edit" ? "일정을 수정했습니다." : "일정을 추가하였습니다."),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: mode == "edit" ? _primary : _primary,
      ),
    );

    Navigator.pop(context, {
      "data": scheduleData,
      "mode": currentMode,
      "selectedIndex": _selectedIndex,
    });

    print("schedule: $schedule");
    if (schedule.isEmpty || schedule is! Map<String, dynamic>) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("일정 추가에 실패했습니다!"),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: _danger,
        ),
      );
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
