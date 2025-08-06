import 'dart:io';
import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Widget 코드
class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1) 캐릭터 이미지 - 150x150, BoxFit.cover
        Container(
          width: 150,
          height: 150,
          child: Image.asset(
            "assets/game/characters/hero.png",
            fit: BoxFit.cover,
          ),
        ),

        // 2) 게임 제목 - PixelFont, 24px, 흰색
        Text(
          'HERO QUEST',
          style: TextStyle(
            fontFamily: FontLoader("PixelFont").family,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// 3) 배경음악 파일 읽기 (async 함수 내부)
Future<void> loadBackgroundMusic() async {
  final musicData = await File("assets/audio/bgm/main_theme.mp3");
  // 음악 재생 로직...
}

class ChatController {
  late StreamController<String> _messageController;

  ChatController() {
    // 1) StreamController 초기화 (생성-종료-연결 3요소)
    _messageController = StreamController();
  }

  // 2) 메시지 추가 (정상 메시지)
  void sendMessage(String message) {
    _messageController.add(message);
  }

  // 3) 에러 추가 (네트워크 오류 등)
  void sendError(String error) {
    _messageController.addError(error); // addError 사용
  }

  // 4) 스트림 가져오기
  Stream<String> get messageStream => _messageController.stream;

  // 5) 리소스 해제
  void dispose() {
    _messageController.close();
  }
}

// 6) UI에서 StreamBuilder 사용
class ChatWidget extends StatelessWidget {
  final ChatController controller;

  ChatWidget(this.controller);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: controller.messageStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('에러: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          return Text(snapshot.toString());
        }
        return Text('메시지 없음');
      },
    );
  }
}

class third{
  // 원본: then 체이닝
  Future<void> loadUserProfile() {
    return fetchUserId()
        .then((userId) => fetchUserData(userId))
        .then((userData) => fetchUserPosts(userData.id))
        .then((posts) => displayUserPosts(posts))
        .catchError((error) => showErrorDialog(error));
  }

// 변환: async/await (동일한 동작)
  Future<void> loadUserProfile() async {
    try {
      final userId = await fetchUserData(userId);
      final userData = await fetchUserPosts(userData.id);
      final posts = await displayUserPosts(posts);
      throw ; // 모르겠네..
    } catch (error) {
      showErrorDialog(error);
    }
  }
}

// 1) 기본 동물 클래스
abstract class Animal {
  void move();
  String getSpecies();
}

// 2) 능력 Mixin들
mixin CanFly {
  void fly() => print('날아간다');
}

mixin CanSwim {
  void swim() => print('수영한다');
}

// 3) 오리 클래스 (동물이면서 날고 수영할 수 있음)
class Duck extends Animal with CanFly, CanSwim {
@override
void move() => print("오리가 움직입니다!");

@override
String getSpecies() => "오리가 자리를 옮겼습니다.";
}

// 4) 인터페이스 분리 설계
abstract class AnimalFeeder {
  void feedAnimal(Animal animal);
}

abstract class AnimalTrainer {
  void trainAnimal(Animal animal);
}

abstract class AnimalCaretaker {
  void cleanHabitat(Animal animal);
}

// 5) 사육사 클래스 (모든 역할 수행)
class Zookeeper implements feedAnimal, trainAnimal, cleanHabitat {
  @override
  void feedAnimal(Animal animal) => print("먹이주기");

  @override
  void trainAnimal(Animal animal) => print("훈련하기");

  @override
  void cleanHabitat(Animal animal) => print("청소하기");
}

class five{
  // 1) 상품 정보 Map (상품ID → 가격)
  Map<String, int> productPrices = {};

// 2) 사용자별 장바구니 (사용자ID → 상품 목록)
  Map<String, List<Product>> userCarts = {};

// 3) 카테고리별 상품 리스트 (카테고리 → 상품ID 리스트)
  Map<String, List<String>> categoryProducts = {};

// 4) 데이터 추가 함수
  void addToCart(String userId, String productId) {
    // 사용자가 처음이면 빈 리스트 생성, 아니면 기존 리스트에 추가
    userCarts[userId] = userCarts.putIfAbsent(userId, () => []);
    userCarts[userId]!.add(productId);
  }

// 5) if-case-when을 사용한 상품 정보 처리
  void processProduct(Record productInfo) {
    if (productInfo case (String name, int price, String category)
      when price > 10000) {
    print('고가 상품: $name');
    }
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1) 상단 프로필 섹션 (고정 크기)
        Container(
          height: 200,
          child: Row(
            children: [
              // 프로필 이미지 (고정 크기)
              Container(
                width: 100,
                height: 100,
                child: Image.asset(
                  'assets/profile/default_avatar.png',
                  fit: BoxFit.contain, // 적절한 BoxFit
                ),
              ),
              // 사용자 정보 (남은 공간 모두 사용)
              Expanded(
                child: Column(
                  children: [
                    Text('사용자 이름'),
                    Text('사용자 소개'),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 2) 메뉴 리스트 (스크롤 가능한 남은 공간 모두 사용)
        SingleChildScrollView(
          child: ListView(
            children: [
              ListTile(title: Text('설정')),
              ListTile(title: Text('도움말')),
              ListTile(title: Text('로그아웃')),
            ],
          ),
        ),
      ],
    );
  }
}

class AutoBanner extends StatefulWidget {
  @override
  _AutoBannerState createState() => _AutoBannerState();
}

class _AutoBannerState extends State<AutoBanner> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;
  final int _totalPages = 5;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      // 마지막 페이지면 첫 페이지로, 아니면 다음 페이지로
      _currentPage = (_currentPage + 1) % _totalPages;

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.linear,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: _totalPages,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.primaries[index % Colors.primaries.length],
          child: Center(child: Text('배너 ${index + 1}')),
        );
      },
    );
  }
}