import 'package:better_quiz_game/CustomShapClipper.dart';
import 'package:better_quiz_game/chunithm%20data.dart';
import 'package:better_quiz_game/filter.dart';
import 'package:better_quiz_game/guessPage.dart';
import 'package:better_quiz_game/video%20player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> with SingleTickerProviderStateMixin {
  //  Animated Controller
  late AnimationController animationController;

  //  Animation Curve
  late Animation<double> offsetAnimation;
  late Animation<Color?> colorAnimation;
  late Animation<Color?> shadowColorAnimation;

  //  Tween
  late Tween<double> offsetTween;
  late ColorTween colorTween;
  late ColorTween shadowColorTween;

  //  Offset
  final double leftPosition = -160;
  final double rightPosition = 160;

  //  Fonts
  final titleFont = GoogleFonts.nanumGothic(
    fontSize: 40
  );
  final buttonFont = GoogleFonts.nanumGothic(
    color: Colors.black,
    fontSize: 22
  );

  //  Button Styles
  final typeButtonStyle = ElevatedButton.styleFrom(
    elevation: 0,
    overlayColor: Colors.transparent,
    foregroundColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    surfaceTintColor: Colors.transparent
  );

  //  Container Color
  final guessColor = const Color.fromARGB(255, 146, 206, 255);
  final playerColor = const Color.fromARGB(255, 231, 182, 182);

  //  Shadow Color
  final guessShadowColor = const Color.fromARGB(255, 72, 134, 185);
  final playerShadowColor = const Color.fromARGB(255, 190, 122, 122);

  //  Selected Button Index
  int selectedIndex = 0;

  bool isGuess = true;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000)
    );

    offsetTween = Tween<double>(
      begin: leftPosition,
      end: rightPosition
    );
    colorTween = ColorTween(
      begin: guessColor,
      end: playerColor
    );
    shadowColorTween = ColorTween(
      begin: guessShadowColor,
      end: playerShadowColor
    );
    
    offsetAnimation = offsetTween.animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutQuint
    ));
    colorAnimation = colorTween.animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutQuint
    ));
    shadowColorAnimation = shadowColorTween.animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutQuint
    ));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void moveTo(int index, double targetX, Color targetColor, Color targetShadowColor) {
    if (selectedIndex == index) return;

    setState(() {
      selectedIndex = index;
      
      // 현재 애니메이션이 위치한 지점을 begin으로, 목적지를 end로 재설정
      offsetTween.begin = offsetAnimation.value;
      offsetTween.end = targetX;

      colorTween.begin = colorAnimation.value ?? guessColor;
      colorTween.end = targetColor;

      shadowColorTween.begin = shadowColorAnimation.value ?? guessShadowColor;
      shadowColorTween.end = targetShadowColor;
    });

    // 컨트롤러 리셋 후 시작
    animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
          child: Text("Chunithm 맞추기 / 재생기", style: titleFont),
        ),
        Expanded(
          child: Stack(
            children: [
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedBuilder(
                  animation: colorAnimation,
                  builder: (context, child) {
                    return ColoredBox(
                      color: colorAnimation.value!,
                      child: Column(
                        children: [
                          FilterWidget(shadowColorAnimation: shadowColorAnimation),
                          ElevatedButton(
                            onPressed: () async {
                              await filteringChunithm();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    if (!isGuess)
                                    {
                                      return VideoPlayer();
                                    }
                                    else
                                    {
                                      return GuessPage();
                                    }
                                  },
                                )
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shadowColor: colorAnimation.value!.withAlpha(150),
                              overlayColor: colorAnimation.value!,
                              elevation: 5,
                              shape:RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(10)
                              )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "시작하기",
                                style: buttonFont,
                              ),
                            )
                          )
                        ],
                      )
                    );
                  }
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: AnimatedBuilder(
                  animation: offsetAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(offsetAnimation.value, 0),
                      child: child!
                    );
                  },
                  child: ClipPath(
                    clipper: CustomShapeClipper(),
                    child: AnimatedBuilder(
                      animation: colorAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 180,
                          height: 60,
                          color: colorAnimation.value,
                        );
                      }
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Row(
                  spacing: 200,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 125,
                      height: 60,
                      child: ElevatedButton(
                        style: typeButtonStyle,
                        onPressed: () {
                          moveTo(0, leftPosition, guessColor, guessShadowColor);
                          isGuess = true;
                        },
                        child: Text("맞추기", style: buttonFont),
                      ),
                    ),
                    SizedBox(
                      width: 125,
                      height: 60,
                      child: ElevatedButton(
                        style: typeButtonStyle,
                        onPressed: () {
                          moveTo(1, rightPosition, playerColor, playerShadowColor);
                          isGuess = false;
                        },
                        child: Text("재생기", style: buttonFont),
                      ),
                    ),
                  ],
                ),
              )
            ]
          )
        )
      ],
    );
  }
}