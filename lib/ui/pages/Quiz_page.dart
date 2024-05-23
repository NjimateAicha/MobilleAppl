import 'package:flutter/material.dart';
import 'package:moroccan_explorer/model/db_connect.dart';
import 'package:moroccan_explorer/ui/widgets/home.button.dart';


class QuizPage extends StatefulWidget {
  final Ville selectedCity;

  const QuizPage({Key? key, required this.selectedCity}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<Question> questions;
  int score = 0;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    questions = widget.selectedCity.questions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Score: $score'),
      ),
      body: _buildQuizBody(),
      bottomNavigationBar: HomeBottomBar(),
    );
  }

  Widget _buildQuizBody() {
    if (questions.isEmpty) {
      return Center(child: Text('Aucune question disponible'));
    } else if (currentIndex >= questions.length) {
      return _buildQuizEnd(); // Afficher la fin du quiz
    } else {
      return _buildQuestionWidget(questions[currentIndex]);
    }
  }

  Widget _buildQuestionWidget(Question question) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${currentIndex + 1} / ${questions.length}', // Afficher le numéro de la question
                  style: TextStyle(fontSize: 16),
                ),
                        
                Image.asset(
                  "images/${question.url}",
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                Text(
                  question.title,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _checkAnswer(true, question);
                      },
                      child: Text('Vrai'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _checkAnswer(false, question);
                      },
                      child: Text('Faux'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizEnd() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Quiz terminé. Score: $score / ${questions.length}',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: () {
              // Réinitialiser le quiz pour une nouvelle partie
              setState(() {
                currentIndex = 0;
                score = 0;
              });
            },
            child: Text('Recommencer'),
          ),
        ],
      ),
    );
  }

  void _checkAnswer(bool selectedAnswer, Question question) {
    bool correctAnswer = question.reponse;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(selectedAnswer == correctAnswer ? 'Correct' : 'Incorrect'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                selectedAnswer == correctAnswer ? 'images/true.jpeg' : 'images/false.jpeg',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10),
              Text(
                question.description,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  if (selectedAnswer == correctAnswer) {
                    score++;
                  }
                  currentIndex++; // Passer à la question suivante
                });
                Navigator.of(context).pop(); // Ferme le AlertDialog
              },
              child: Text('Suivant'),
            ),
          ],
        );
      },
    );
  }
}