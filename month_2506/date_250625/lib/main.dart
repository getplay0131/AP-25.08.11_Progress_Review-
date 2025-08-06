import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
  BoxFit.
}

class AutoSlideWidget extends StatefulWidget {
  @override
  _AutoSlideWidgetState createState() => _AutoSlideWidgetState();

}



class _AutoSlideWidgetState extends State<AutoSlideWidget> {

  Timer? timer;
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    // 2초마다 다음 페이지로 이동하는 타이머 구현
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      int current = controller.page!.toInt();
      int next = (current + 1) % 5; // 5개 페이지 순환
      controller.animateToPage(
        next,
        duration: Duration(milliseconds: 500),
        curve: Curves.linear,
      );
    });
  }

  @override
  void dispose() {
    // 메모리 누수 방지 코드 작성
    controller.dispose();
    timer?.cancel();
    super.dispose();
  }
}
class LikeButton extends StatefulWidget {
  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  int likeCount = 0;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          likeCount++;
        });
      },
      child: Text('좋아요 $likeCount'),
    );
  }
}
class PostUploader {
  Future<void> uploadPost(String content) async {
    // 서버에 저장할 때 시간대 문제 해결을 위한 코드 작성
    DateTime uploadTime = DateTime.now();

    Map<String, dynamic> postData = {
      'content': content,
      'upload_time': uploadTime.millisecondsSinceEpoch, // 타임스탬프로 저장
      'user_id': getCurrentUserId(),
    };

    await ApiService.post('/posts', postData);
  }

  String formatUploadTime(DateTime serverTime) {
    // 서버에서 받은 UTC 시간을 로컬 시간으로 변환
    DateTime localTime = serverTime.toLocal();
    return DateFormat('yyyy-MM-dd HH:mm').format(localTime);
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String? backgroundMusic;

  @override
  void initState() {
    super.initState();
    loadAssets();
  }

  void loadAssets() async {
    // 틀린 부분 찾아서 수정하기
    // 루트번들.로드는 바이트 데이터 타입이고, 로드스트링은 문자열 타입이다.
    final musicData = await rootBundle.load("assets/audio/bgm/main_theme.mp3");
    final configData = await rootBundle.loadString("assets/data.txt");

    setState(() {
      backgroundMusic = configData;
    });
  }
}

class UserDataProcessor {
  Future<void> processUserData(String userId) async {
    try {
      // 1단계: 사용자 ID로 기본 정보 가져오기
      final userInfo = await fetchUserInfo(userId);

      // 2단계: 사용자 정보로 상세 데이터 가져오기
      final detailData = await fetchDetailData(userInfo.id);

      // 3단계: 상세 데이터로 포스트 목록 가져오기
      final posts = await fetchUserPosts(detailData.id);

      // 4단계: 화면에 표시
      displayPosts(posts);

    } catch (e) {
      print('데이터 처리 오류: $e');
    }
  }

  Future<UserInfo> fetchUserInfo(String userId) async {
    // API 호출 시뮬레이션
    await Future.delayed(Duration(milliseconds: 500));
    return UserInfo(id: userId, name: "사용자");
  }

  Future<DetailData> fetchDetailData(String userId) async {
    await Future.delayed(Duration(milliseconds: 300));
    return DetailData(id: userId, profile: "상세정보");
  }

  Future<List<Post>> fetchUserPosts(String userId) async {
    await Future.delayed(Duration(milliseconds: 200));
    return [Post(title: "게시글1"), Post(title: "게시글2")];
  }

  void displayPosts(List<Post> posts) {
    posts.forEach((post) => print(post.title));
  }
}

class ProblematicLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Column(
          children: [
            Container(height: 200, color: Colors.blue),
            Expanded(
              child: ListView(  // 여기서 오류 발생!
                children: [
                  ListTile(title: Text("항목 1")),
                  ListTile(title: Text("항목 2")),
                  ListTile(title: Text("항목 3")),
                ],
              ),
            ),
            Container(height: 200, color: Colors.green),
          ],
        ),
      ),
    );
  }
}
class NavigationController {
  void navigateToSettings(BuildContext context, int maxNumber) async {
    // 설정 화면으로 이동하고 결과 받기
    var result = await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => SettingsScreen(maxNumber: maxNumber)
        )
    );

    // 결과가 있으면 처리
    if (result != null) {
      print('설정 변경됨: $result');
    }
  }

  void goBack(BuildContext context, int newMaxNumber) {
    // 이전 화면으로 돌아가면서 데이터 전달
    Navigator.of(context).pop(newMaxNumber);
  }
}


class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;  // 콜백 타입 정의

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,  // 콜백 실행
      child: Text(text),
    );
  }
}

// 사용 예시 완성하기
class HomeScreen extends StatelessWidget {
  void generateNumbers() {
    print("숫자 생성!");
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: "숫자 생성",
      onPressed: generateNumbers,  // 함수 전달
    );
  }
}

class TimerManager {
  void setupTimers() {
    // 2시간 30분을 나타내는 Duration 객체 생성
    Duration longBreak = Duration(hours: 2,minutes: 30);

    // 5일을 나타내는 Duration 객체 생성
    Duration workWeek = Duration(days: 5);

    // 500밀리초를 나타내는 Duration 객체 생성
    Duration animationDuration = Duration(milliseconds: 500);

    // 현재 시간에서 longBreak만큼 뒤의 시간 계산
    DateTime futureTime = DateTime.now().add(longBreak);

    print('긴 휴식 후 시간: $futureTime');
  }
}
class ProfilePhotoWidget extends StatelessWidget {
  final String photoUrl;
  final double size;

  ProfilePhotoWidget({required this.photoUrl, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2), // 원형
        child: Image.network(
          photoUrl,
          fit: BoxFit.cover, // 프로필 사진에 적합한 BoxFit
        ),
      ),
    );
  }
}

// 갤러리 썸네일 위젯도 구현하세요
class GalleryThumbnail extends StatelessWidget {
  final String imageUrl;

  GalleryThumbnail({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 150,
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain, // 전체 이미지를 다 보여주는 BoxFit
      ),
    );
  }
}
class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int counter = 0;

  void incrementCounter() {
    // ❌ 틀린 코드 - 화면이 업데이트되지 않음

    setState(() {
      counter++;
    });
  }

  void decrementCounter() {
    // ❌ 틀린 코드 - 화면이 업데이트되지 않음
    setState(() {
      counter--;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('카운터: $counter'),
        Row(
          children: [
            ElevatedButton(
              onPressed: incrementCounter,
              child: Text('+'),
            ),
            ElevatedButton(
              onPressed: decrementCounter,
              child: Text('-'),
            ),
          ],
        ),
      ],
    );
  }
}
class AutoSlideGallery extends StatefulWidget {
  final List<String> imageUrls;

  AutoSlideGallery({required this.imageUrls});

  @override
  _AutoSlideGalleryState createState() => _AutoSlideGalleryState();
}

class _AutoSlideGalleryState extends State<AutoSlideGallery> {
  Timer? _timer;
  PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentPage = (_currentPage + 1) % widget.imageUrls.length;
        _controller.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.imageUrls[index],
                fit: BoxFit.cover, // 컨테이너를 꽉 채우는 fit
              ),
            ),
          );
        },
      ),
    );
  }
}
