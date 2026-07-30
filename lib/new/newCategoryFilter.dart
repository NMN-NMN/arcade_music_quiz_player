import 'package:better_quiz_game/chunithm%20data.dart';
import 'package:better_quiz_game/new/classes/ResponsiveLayout.dart';
import 'package:flutter/material.dart';

class NewCategoryFilter extends StatefulWidget {
  const NewCategoryFilter({super.key});

  @override
  State<NewCategoryFilter> createState() => _NewCategoryFilterState();
}

class _NewCategoryFilterState extends State<NewCategoryFilter> {
  @override
  Widget build(BuildContext context) {
    return Responsivelayout(
      builder: (context, responsive) {
        final isMobile = responsive.size.width < 600;

        final categoriesWidget = isMobile
            ? Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 249, 192),
                  borderRadius: BorderRadius.circular(
                    responsive.radius(20)
                  )
                ),
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 5,
                      children: categories.map((category) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: checkedCategories[category],
                              onChanged: (value) {
                                setState(() {
                                  checkedCategories[category] = value ?? false;
                                });
                
                                filteringChunithm();
                              },
                              activeColor: const Color.fromARGB(255, 238, 138, 57),
                            ),
                            Text(category)
                          ],
                        );
                      }).toList(),
                    ),
                  ),
              ),
            )
            : Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 249, 192),
                  borderRadius: BorderRadius.circular(
                    responsive.radius(20)
                  )
                ),
                child: Wrap(
                    spacing: 10,
                    children: categories.map((category) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: checkedCategories[category],
                            onChanged: (value) {
                              setState(() {
                                checkedCategories[category] = value ?? false;
                              });
                
                              filteringChunithm();
                            },
                            activeColor: const Color.fromARGB(255, 238, 138, 57),
                          ),
                          Text(category),
                        ],
                      );
                    }).toList(),
                  ),
              ),
            );

        return Column(
          spacing: 10,
          children: [
            Text(
              "카테고리",
              style: TextStyle(
                fontSize: responsive.isMobile ? 20 : 30
              ),
            ),
            categoriesWidget
          ],
        );
      },
    );
  }
}