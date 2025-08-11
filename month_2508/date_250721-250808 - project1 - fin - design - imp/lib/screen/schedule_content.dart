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

  // 스타일 유틸
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
    // 앱 시작 시 저장된 데이터가 있다면 불러와서 미리 보여줄 수 있도록 시도 (비차단)
    unawaited(loadFromData());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initLoadScheduleData();
    _checkCurrentDataForScheduleContentUsedidChangeDependencies();
  }

  void _initLoadScheduleData() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      final data = args["data"];
      if (data is Map<String, dynamic>) {
        scheduleData = data;
        title = data['title'] ?? "제목 없음";

        final rawDate = data['date'];
        if (rawDate is DateTime) {
          date = rawDate;
        } else if (rawDate is String) {
          // ISO 문자열로 넘어오는 경우
          date = DateTime.tryParse(rawDate) ?? DateTime.now();
        } else {
          date = DateTime.now();
        }

        description = data['description'] ?? "설명 없음";
        location = data['location'] ?? "위치 없음";
        isCompleted = data['isCompleted'] ?? false;
        _dataLoaded = true;
        scheduleList = [scheduleData];
      }
    }
  }

  String _two(int v) => v.toString().padLeft(2, '0');
  String _formatDate(DateTime d) => "${d.year}-${_two(d.month)}-${_two(d.day)}";
  String _formatDateTime(DateTime d) =>
      "${_formatDate(d)} ${_two(d.hour)}:${_two(d.minute)}";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                child: Icon(Icons.visibility_rounded, color: _primary),
              ),
              const SizedBox(width: 10),
              Text(
                "일정 상세 보기",
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: _dataLoaded ? _content(context) : _emptyState(context),
        ),
      ),
      bottomNavigationBar: _dataLoaded ? _bottomActions(context) : null,
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        _headerCard(context),
        const SizedBox(height: 12),
        _detailCard(context),
        const SizedBox(height: 12),
        Expanded(child: _historyCard(context)),
      ],
    );
  }

  Widget _headerCard(BuildContext context) {
    final modeColor = isCompleted ? _primary : _warning;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.28 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: isDark ? const Color(0xFF252A33) : const Color(0xFFEFEFEF),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: modeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: modeColor.withOpacity(0.25)),
                ),
                child: Row(
                  children: [
                    Icon(
                      isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.timelapse_rounded,
                      size: 16,
                      color: modeColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isCompleted ? "완료" : "미완료",
                      style: TextStyle(
                        color: modeColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Icon(
                isCompleted ? Icons.check_rounded : Icons.event_note_rounded,
                color: isCompleted
                    ? _primary
                    : (isDark ? Colors.white70 : Colors.black45),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: _muted(context),
              ),
              const SizedBox(width: 6),
              Text(
                _formatDateTime(date.toLocal()),
                style: TextStyle(
                  fontSize: 14,
                  color: _muted(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF252A33) : const Color(0xFFEFEFEF),
        ),
      ),
      child: Column(
        children: [
          _infoRow(context, Icons.description_rounded, "설명", description),
          const SizedBox(height: 10),
          _infoRow(context, Icons.place_rounded, "위치", location),
        ],
      ),
    );
  }

  Widget _historyCard(BuildContext context) {
    // 간단히 현재 1건만 리스트로 표시 (저장/불러오기 후에도 리스트로 보여줄 수 있도록)
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (scheduleList.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: BoxDecoration(
          color: _cardColor(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? const Color(0xFF252A33) : const Color(0xFFEFEFEF),
          ),
        ),
        child: Center(
          child: Text(
            "저장된 내역이 없습니다.",
            style: TextStyle(
              color: _muted(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF252A33) : const Color(0xFFEFEFEF),
        ),
      ),
      child: ListView.separated(
        itemCount: scheduleList.length,
        separatorBuilder: (_, __) => Divider(
          height: 12,
          color: isDark ? const Color(0xFF2A2F39) : const Color(0xFFECEFF3),
        ),
        itemBuilder: (context, idx) {
          final item = scheduleList[idx];
          final rawDate = item['date'];
          final dt = rawDate is String
              ? DateTime.tryParse(rawDate)?.toLocal() ?? DateTime.now()
              : rawDate is DateTime
              ? rawDate.toLocal()
              : DateTime.now();
          final done = item['isCompleted'] == true;
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 6,
            ),
            leading: CircleAvatar(
              backgroundColor: (done ? _primary : _warning).withOpacity(0.15),
              child: Icon(
                done ? Icons.check_rounded : Icons.timelapse_rounded,
                color: done ? _primary : _warning,
              ),
            ),
            title: Text(
              item['title'] ?? '제목 없음',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text(
              _formatDateTime(dt),
              style: TextStyle(
                color: _muted(context),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            trailing: Icon(Icons.chevron_right_rounded, color: _muted(context)),
          );
        },
      ),
    );
  }

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _primary, size: 20),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              fontSize: 15,
              height: 1.3,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _emptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _cardColor(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? const Color(0xFF252A33) : const Color(0xFFEFEFEF),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded, color: _primary, size: 44),
            const SizedBox(height: 12),
            Text(
              "저장된 일정이 없습니다.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "홈 화면에서 일정을 선택하거나 저장된 데이터를 불러오세요.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: _muted(context)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomActions(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        decoration: BoxDecoration(
          color: _bgColor(context),
          border: Border(
            top: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF232936)
                  : const Color(0xFFE9EDF3),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: () => saveToData(),
                icon: Icon(Icons.save_rounded, color: _primary),
                label: const Text("일정 저장"),
                style: FilledButton.styleFrom(
                  backgroundColor: _primary.withOpacity(0.12),
                  foregroundColor: _primary,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: () async {
                  final loaded = await loadFromData();
                  if (loaded.isNotEmpty) {
                    setState(() {
                      scheduleList = loaded;
                      // 불러온 데이터로 헤더/내용 갱신
                      final m = loaded.first;
                      title = m['title'] ?? title;
                      final rawDate = m['date'];
                      if (rawDate is String) {
                        date = DateTime.tryParse(rawDate)?.toLocal() ?? date;
                      } else if (rawDate is DateTime) {
                        date = rawDate.toLocal();
                      }
                      description = m['description'] ?? description;
                      location = m['location'] ?? location;
                      isCompleted = m['isCompleted'] ?? isCompleted;
                      _dataLoaded = true;
                    });
                  }
                },
                icon: Icon(
                  Icons.download_rounded,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.blue,
                ),
                label: const Text("일정 불러오기"),
                style: FilledButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1F2530)
                      : const Color(0xFFEFF4FF),
                  foregroundColor:
                      Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.blue,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveToData() async {
    try {
      final dataToSave = {
        'title': title,
        'date': date.toIso8601String(),
        'description': description,
        'location': location,
        'isCompleted': isCompleted,
      };
      final pref = await SharedPreferences.getInstance();
      final scheduleToJson = jsonEncode(dataToSave);
      if (scheduleToJson.isNotEmpty) {
        await pref.setString('scheduleData', scheduleToJson);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("일정 데이터가 저장되었습니다."),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            backgroundColor: _primary,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("일정 데이터가 저장되었습니다. 홈화면으로 돌아갑니다"),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
        Navigator.pop(context, dataToSave);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("일정 데이터가 비어있습니다.")));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("저장 중 오류가 발생했습니다: $e"),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: _danger,
        ),
      );
    }
  }

  Future<List<Map<String, dynamic>>> loadFromData() async {
    final List<Map<String, dynamic>> loaded = [];
    try {
      final pref = await SharedPreferences.getInstance();
      final scheduleJson = pref.getString('scheduleData');
      if (scheduleJson != null && scheduleJson.isNotEmpty) {
        final Map<String, dynamic> scheduleMap = jsonDecode(scheduleJson);
        if (mounted) {
          setState(() {
            title = scheduleMap['title'] ?? "제목 없음";
            final rawDate = scheduleMap['date'];
            date = rawDate != null
                ? DateTime.tryParse(rawDate)?.toLocal() ?? DateTime.now()
                : DateTime.now();
            description = scheduleMap['description'] ?? "설명 없음";
            location = scheduleMap['location'] ?? "위치 없음";
            isCompleted = scheduleMap['isCompleted'] ?? false;
          });
        }
        loaded.add(scheduleMap);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("일정 데이터가 불러와졌습니다."),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("저장된 일정 데이터가 없습니다.")));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("데이터 로딩 중 오류가 발생했습니다: $e"),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            backgroundColor: _danger,
          ),
        );
      }
    }
    return loaded;
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
