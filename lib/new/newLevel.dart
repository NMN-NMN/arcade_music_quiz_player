import 'package:better_quiz_game/chunithm%20data.dart';
import 'package:better_quiz_game/new/classes/ResponsiveLayout.dart';
import 'package:flutter/material.dart';

class NewLevel extends StatefulWidget {
  const NewLevel({super.key});

  @override
  State<NewLevel> createState() => _NewLevelState();
}

class _NewLevelState extends State<NewLevel> {
  @override
  Widget build(BuildContext context) {
    return Responsivelayout(
      builder: (context, responsive) {
        final levelWidget = 
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            width: 500,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 249, 192),
              borderRadius: BorderRadius.circular(
                responsive.radius(20)
              )
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                spacing: 5,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: levels.map((level) {
                        return Row(
                          mainAxisSize: .min,
                          children: [
                            Checkbox(
                              value: checkedLevels[level],
                              onChanged: (value) {
                                setState(() {
                                  checkedLevels[level] = value ?? false;
                                });
                            
                                filteringChunithm();
                              },
                              activeColor: const Color.fromARGB(255, 238, 138, 57),
                            ),
                            Text(level)
                          ],
                        );
                      }).toList()
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        child: Text(
                          rangeValues.start.toStringAsFixed(1),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Text(
                        " ~ "
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          rangeValues.end.toStringAsFixed(1),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: responsive.width(300, min: 240, max: 380),
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        showValueIndicator: ShowValueIndicator.never,
                        inactiveTrackColor: const Color.fromARGB(255, 238, 138, 57).withAlpha(70),
                        overlayColor: const Color.fromARGB(255, 238, 138, 57).withAlpha(20),
                        thumbColor: const Color.fromARGB(255, 238, 138, 57),
                        activeTrackColor: const Color.fromARGB(255, 238, 138, 57),
                      ),
                      child: RangeSlider(
                        values: rangeValues,
                        min: 1,
                        max: 16,
                        divisions: 150,
                        onChanged: (value) {
                          setState(() {
                            rangeValues = RangeValues(
                              (value.start * 10).round() / 10,
                              (value.end * 10).round() / 10
                            );
                          });
              
                          filteringChunithm();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );

        return Column(
          spacing: 10,
          children: [
            Text(
              "보면상수",
              style: TextStyle(
                fontSize: responsive.isMobile ? 20 : 30
              ),
            ),
            levelWidget
          ],
        );
      },
    );
  }
}