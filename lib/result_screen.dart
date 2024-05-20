import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/questions_summary.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.chosenAnswers,
    required this.onRestart,
  });

  final void Function() onRestart;
  final List<String> chosenAnswers;

  void shareOnMessenger(String text) async {
    // Encode the text to ensure it's safe to include in a URL
    final String encodedText = Uri.encodeComponent(text);
    // Create the URL for Messenger
    final Uri uri = Uri.parse("fb-messenger://share?text=$encodedText");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Handle the case where the URL could not be launched
      throw 'Could not launch $uri';
    }
  }

  void shareOnWhatsApp(String text) async {
    final String encodedText = Uri.encodeComponent(text);
    final Uri uri = Uri.parse("https://wa.me/?text=$encodedText");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {}
  }

  void shareOnTelegram(String text) async {
    Uri.encodeComponent(text);
    final Uri uri = Uri.parse(
        "https://telegram.me/share/url?url=urlEncodedText&text=urlEncodedText");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {}
  }

  void shareGeneral(String text) {
    Share.share(text);
  }

  List<Map<String, Object>> get summaryData {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < chosenAnswers.length; i++) {
      summary.add(
        {
          'question_index': i,
          'question': questions[i].text,
          'correct_answer': questions[i].answers[0],
          'user_answer': chosenAnswers[i],
        },
      );
    }

    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final numTotalQuestions = questions.length;
    final numCorrectQuestions = summaryData.where((data) {
      return data['user_answer'] == data['correct_answer'];
    }).length;

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You answered $numCorrectQuestions out of $numTotalQuestions questions correctly!',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            QuestionsSummary(summaryData),
            const SizedBox(height: 30),
            TextButton.icon(
              onPressed: onRestart,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Restart Quiz'),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShareButton(
                  ontap: () => shareOnMessenger('Your quiz results text here'),
                  icon: Icons.facebook,
                  backgroundcolor: Colors.blue,
                ),
                ShareButton(
                  ontap: () => shareOnWhatsApp('Your quiz results text here'),
                  icon: Icons.call,
                  backgroundcolor: Colors.green,
                ),
                ShareButton(
                  ontap: () => shareOnTelegram('Your quiz results text here'),
                  icon: Icons.telegram,
                  backgroundcolor: Colors.blue.shade200,
                ),
                ShareButton(
                  ontap: () => shareGeneral(
                      'I answered $numCorrectQuestions out of ${questions.length} questions correctly!'),
                  icon: Icons.share,
                  backgroundcolor: Colors.greenAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({
    super.key,
    required this.icon,
    required this.backgroundcolor,
    required this.ontap,
  });
  final IconData icon;
  final Color backgroundcolor;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: backgroundcolor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
