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
          child: Image.asset("assets/game/characters/hero.png", Boxfit),
        ),

        // 2) 게임 제목 - PixelFont, 24px, 흰색
        Text(
          'HERO QUEST',
          style: TextStyle(
            fontFamily: ________________________________,
            fontSize: ________________________________,
            color: ________________________________,
          ),
        ),
      ],
    );
  }
}

// 3) 배경음악 파일 읽기 (async 함수 내부)
Future<void> loadBackgroundMusic() async {
  final musicData = await ________________________________;
  // 음악 재생 로직...
}
