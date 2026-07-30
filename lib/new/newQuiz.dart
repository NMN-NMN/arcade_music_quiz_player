import 'package:better_quiz_game/chunithm%20data.dart';
import 'package:better_quiz_game/new/classes/ResponsiveLayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewQuiz extends StatefulWidget {
  const NewQuiz({super.key});

  @override
  State<NewQuiz> createState() => _NewQuizState();
}

class _NewQuizState extends State<NewQuiz> {
  @override
  Widget build(BuildContext context) {
    return Responsivelayout(
      builder: (context, responsive) {
        final QuizWidget =
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            width: 120,
            height: 50,
            child: TextField(
              controller: textfieldController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9]*'),
                ),
              ],
              decoration: InputDecoration(
                hintText: "ex) 10, 20, 30...",
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 249, 192),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent
                  ),
                  borderRadius: BorderRadius.circular(10)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent
                  ),
                  borderRadius: BorderRadius.circular(10)
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent
                  ),
                  borderRadius: BorderRadius.circular(10)
                )
              ),
            ),
          ),
        );

        return Row(
          spacing: 20,
          mainAxisSize: .min,
          children: [
            Column(
              children: [
                Text(
                  "맞출 문제 갯수",
                  style: TextStyle(
                    fontSize: responsive.isMobile ? 18 : 26
                  ),
                ),
                QuizWidget,
              ],
            ),
            Column(
              children: [
                Text(
                  "필터링된 노래 갯수",
                  style: TextStyle(
                    fontSize: responsive.isMobile ? 18 : 26
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ValueListenableBuilder(
                    valueListenable: filteredCount,
                    builder: (context, value, child) {
                      return SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            value.toString(),
                            style: TextStyle(
                              fontSize: responsive.isMobile ? 20 : 30
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}