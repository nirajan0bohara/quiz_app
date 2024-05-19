import 'package:flutter/material.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/questions_screen.dart';
import 'package:quiz_app/result_screen.dart';
import 'package:quiz_app/start_screen.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});
  @override
  State<StatefulWidget> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  List<String> selectedAnswers = [];
  var activeScreen = 'start-screen';

  void switchScreen() {
    setState(() {
      if (selectedAnswers.length < questions.length) {
        activeScreen = 'questions-screen';
      } else {
        activeScreen = 'results-screen';
      }
    });
  }

  void chooseAnswer(String answer) {
    if (selectedAnswers.length < questions.length) {
      selectedAnswers.add(answer);
      // switchScreen();
      if (selectedAnswers.length == questions.length) {
        setState(() {
          activeScreen = 'results-screen';
        });
      } else {
        setState(() {
          activeScreen = 'questions-screen';
        });
      }
    }
  }

  void restartQuiz() {
    setState(() {
      selectedAnswers.clear();
      activeScreen = 'start-screen';
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screenWidget = StartScreen(switchScreen);

    if (activeScreen == 'questions-screen') {
      screenWidget = QuestionsScreen(
        onSelectAnswer: chooseAnswer,
      );
    }

    if (activeScreen == 'results-screen') {
      screenWidget = ResultScreen(
        chosenAnswers: selectedAnswers,
        onRestart: restartQuiz,
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 64, 20, 140),
                Color.fromARGB(255, 84, 20, 134),
              ],
            ),
          ),
          child: screenWidget,
        ),
      ),
    );
  }
}
