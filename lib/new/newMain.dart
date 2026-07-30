import 'dart:math';

import 'package:better_quiz_game/chunithm%20data.dart';
import 'package:better_quiz_game/guessPage.dart';
import 'package:better_quiz_game/new/classes/ResponsiveLayout.dart';
import 'package:better_quiz_game/new/newFilter.dart';
import 'package:better_quiz_game/video%20player.dart';
import 'package:flutter/material.dart';

class NewMainPage extends StatefulWidget {
  const NewMainPage({super.key});

  @override
  State<NewMainPage> createState() => NewMainPageState();
}

class NewMainPageState extends State<NewMainPage> {
  String selected = "guess";

  @override
  Widget build(BuildContext context) {
    return Responsivelayout(
      builder: (context, responsive) {
        return Column(
          spacing: responsive.radius(40),
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(responsive.radius(40, min: 30, max: 50)),
                child: Image.asset(
                  "assets/images/chunithm logo.png",
                  height: responsive.height(100, min: 50, max: 200),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  responsive.radius(60, min: 40, max: 80),
                  responsive.radius(60),
                  responsive.radius(60, min: 40, max: 80),
                  responsive.radius(100, min: 80, max: 120)
                ),
                child: Container(
                  width: responsive.width(1000, min: 500, max: 1200),
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 206, 193, 78),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(85, 136, 94, 30),
                        offset: Offset(0, 10),
                        spreadRadius: 2,
                        blurRadius: 5,
                      )
                    ],
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        responsive.radius(20)
                      )
                    )
                  ),
                  child: Column(
                    children: [
                      RadioGroup<String>(
                        groupValue: selected,
                        onChanged: (value) {
                          setState(() {
                            selected = value!;
                          });
                        },
                        child: Row(
                          spacing: 50,
                          mainAxisSize: .min,
                          children: [
                            Row(
                              spacing: responsive.isMobile ? 4 : 10,
                              children: [
                                Text(
                                  "맞추기",
                                  style: TextStyle(
                                    fontSize: responsive.isMobile ? 20 : 40
                                  ),
                                ),
                                Transform.scale(
                                  scale: responsive.isMobile ? 1 : 1.5,
                                  child: Radio<String>(
                                    value: "guess",
                                  ),
                                )
                              ],
                            ),
                            Row(
                              spacing: responsive.isMobile ? 4 : 10,
                              children: [
                                Text(
                                  "재생기",
                                  style: TextStyle(
                                    fontSize: responsive.isMobile ? 20 : 40
                                  ),
                                ),
                                Transform.scale(
                                  scale: responsive.isMobile ? 1 : 1.5,
                                  child: Radio<String>(
                                    value: "player",
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: NewFilter(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: responsive.radius(20, min: 18, max: 22)
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 255, 249, 192)
                          ),
                          onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      filteringChunithm();
                                      final count = int.tryParse(textfieldController.text);
                                      if (selected == "guess")
                                      {
                                        return GuessPage(guessCount: min<int>(count ?? filteredCount.value, filteredCount.value));
                                      }
                                      else
                                      {
                                        return VideoPlayer();
                                      }
                                    },
                                  )
                                );
                              },
                          child: SizedBox(
                            width: responsive.width(100, min: 90, max: 110),
                            height: responsive.height(60, min: 50, max: 70),
                            child: Center(
                              child: Text(
                                "시작하기",
                                style: TextStyle(
                                  fontSize: 16
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      }
    );
  }
}