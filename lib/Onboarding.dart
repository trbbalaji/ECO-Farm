import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'Login.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final controller = PageController();
  bool isLastPage = false;
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
              padding: const EdgeInsets.only(bottom: 80),
              child: PageView(
                controller: controller,
                onPageChanged: (index) {
                  setState(() => isLastPage = index == 2);
                },
                children: [
                  OnboardScreen(
                      color: HexColor("01937C"),
                      imageurl: "assets/images/clouds1.png",
                      title: "Weather",
                      content:
                          "It predicts future weather conditions with high accuracy"),
                  OnboardScreen(
                      color: HexColor("01937C"),
                      imageurl: "assets/images/slide-1.jpg",
                      title: "Weather",
                      content:
                          "It predicts future weather conditions with high accuracy"),
                  OnboardScreen(
                      color: HexColor("01937C"),
                      imageurl: "assets/images/slide-1.jpg",
                      title: "Weather",
                      content:
                          "It predicts future weather conditions with high accuracy"),
                ],
              ),
            ),
            bottomSheet: isLastPage
                ? TextButton(
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        minimumSize: const Size.fromHeight(80)),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool('showHome', true);

                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: const Text(
                      'Get Start',
                      style: TextStyle(fontSize: 28),
                    ))
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () => controller.jumpToPage(2),
                            child: const Text("Skip")),
                        Center(
                          child: SmoothPageIndicator(
                              controller: controller,
                              count: 3,
                              onDotClicked: (index) => controller.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeOut),
                              effect: const ExpandingDotsEffect()),
                        ),
                        TextButton(
                            onPressed: () => controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut),
                            child: const Text("Next"))
                      ],
                    ),
                  )));
  }
}

Widget OnboardScreen(
        {required Color color,
        required String imageurl,
        required String title,
        required String content}) =>
    Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imageurl,
            width: double.infinity,
          ),
          // ignore: prefer_const_constructors
          SizedBox(
            height: 20,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: color, fontSize: 31, fontFamily: 'Lexend'),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(color: HexColor("9196A5"), fontSize: 19),
            ),
          )
        ],
      ),
    );
