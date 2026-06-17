import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const QuizPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map<String, Object>> _questions = const [
    // Questions 1-10
    {'questionText': 'What is the capital city of Tamil Nadu?', 'answers': ['Madurai', 'Coimbatore', 'Chennai', 'Trichy'], 'correctAnswer': 'Chennai'},
    {'questionText': 'Which is the official state fruit of Tamil Nadu?', 'answers': ['Mango', 'Jackfruit', 'Banana', 'Papaya'], 'correctAnswer': 'Jackfruit'},
    {'questionText': 'What is the classical dance form of Tamil Nadu?', 'answers': ['Kathakali', 'Bharatanatyam', 'Kathak', 'Kuchipudi'], 'correctAnswer': 'Bharatanatyam'},
    {'questionText': 'Which river is known as the lifeline of Tamil Nadu?', 'answers': ['Ganga', 'Cauvery', 'Godavari', 'Krishna'], 'correctAnswer': 'Cauvery'},
    {'questionText': 'What is the state animal of Tamil Nadu?', 'answers': ['Bengal Tiger', 'Indian Elephant', 'Nilgiri Tahr', 'Gaur'], 'correctAnswer': 'Nilgiri Tahr'},
    {'questionText': 'Who was the first President of India?', 'answers': ['Dr. Rajendra Prasad', 'Dr. B.R. Ambedkar', 'Jawaharlal Nehru', 'Mahatma Gandhi'], 'correctAnswer': 'Dr. Rajendra Prasad'},
    {'questionText': 'Which city is known as the "Manchester of South India"?', 'answers': ['Salem', 'Coimbatore', 'Erode', 'Tiruppur'], 'correctAnswer': 'Coimbatore'},
    {'questionText': 'What is the national currency of India?', 'answers': ['Dollar', 'Yen', 'Indian Rupee', 'Taka'], 'correctAnswer': 'Indian Rupee'},
    {'questionText': 'Which festival is celebrated as the Tamil New Year?', 'answers': ['Pongal', 'Puthandu', 'Deepavali', 'Karthigai Deepam'], 'correctAnswer': 'Puthandu'},
    {'questionText': 'Which is the highest mountain peak in Tamil Nadu?', 'answers': ['Doddabetta', 'Anamudi', 'Velliangiri', 'Mahendragiri'], 'correctAnswer': 'Doddabetta'},
    // Questions 11-20
    {'questionText': 'What is the state flower of Tamil Nadu?', 'answers': ['Lotus', 'Jasmine', 'Gloriosa Lily', 'Rose'], 'correctAnswer': 'Gloriosa Lily'},
    {'questionText': 'Which bird is the official state bird of Tamil Nadu?', 'answers': ['Peacock', 'Emerald Dove', 'Kingfisher', 'Parrot'], 'correctAnswer': 'Emerald Dove'},
    {'questionText': 'What is the official state tree of Tamil Nadu?', 'answers': ['Neem Tree', 'Banyan Tree', 'Palmyra Palm', 'Teak Tree'], 'correctAnswer': 'Palmyra Palm'},
    {'questionText': 'Which animal is the National Aquatic Animal of India?', 'answers': ['Blue Whale', 'Ganges River Dolphin', 'Dugong', 'Sea Turtle'], 'correctAnswer': 'Ganges River Dolphin'},
    {'questionText': 'Which is the largest temple complex in India?', 'answers': ['Meenakshi Amman Temple', 'Brihadeeswarar Temple', 'Srirangam Ranganathaswamy Temple', 'Shore Temple'], 'correctAnswer': 'Srirangam Ranganathaswamy Temple'},
    {'questionText': 'Who was the first woman Chief Minister of Tamil Nadu?', 'answers': ['J. Jayalalithaa', 'Janaki Ramachandran', 'Sushma Swaraj', 'Mayawati'], 'correctAnswer': 'Janaki Ramachandran'},
    {'questionText': 'Which is the longest beach in India?', 'answers': ['Juhu Beach', 'Kovalam Beach', 'Marina Beach', 'Puri Beach'], 'correctAnswer': 'Marina Beach'},
    {'questionText': 'Which animal replaced the Lion as the National Animal of India in 1972?', 'answers': ['Indian Elephant', 'Royal Bengal Tiger', 'Leopard', 'Snow Leopard'], 'correctAnswer': 'Royal Bengal Tiger'},
    {'questionText': 'In which town is the famous 8th-century Shore Temple located?', 'answers': ['Kanchipuram', 'Mahabalipuram', 'Thanjavur', 'Rameshwaram'], 'correctAnswer': 'Mahabalipuram'},
    {'questionText': 'What is the official state butterfly of Tamil Nadu?', 'answers': ['Common Jezebel', 'Tamil Yeoman', 'Blue Mormon', 'Southern Birdwing'], 'correctAnswer': 'Tamil Yeoman'},
  ];

  int _questionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  String _selectedAnswer = '';

  // Timer variables
  Timer? _timer;
  int _secondsRemaining = 20;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = 20;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
          _nextQuestion(); // Auto-move to next question on timeout
        }
      });
    });
  }

  void _answerQuestion(String selectedAnswer) {
    if (_isAnswered) return;

    _timer?.cancel(); // Stop timer when user answers
    setState(() {
      _isAnswered = true;
      _selectedAnswer = selectedAnswer;
      if (selectedAnswer == _questions[_questionIndex]['correctAnswer']) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _isAnswered = false;
      _selectedAnswer = '';
      if (_questionIndex < _questions.length - 1) {
        _questionIndex++;
        _startTimer(); // Restart timer for new question
      } else {
        _showResultsDialog();
      }
    });
  }

  void _showResultsDialog() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Quiz Over!'),
        content: Text('Your Final Score: $_score / ${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _questionIndex = 0;
                _score = 0;
                _isAnswered = false;
                _selectedAnswer = '';
              });
              _startTimer();
              Navigator.of(ctx).pop();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  Color _getButtonColor(String answer) {
    if (!_isAnswered) return Colors.indigo.shade50;
    String correct = _questions[_questionIndex]['correctAnswer'] as String;
    if (answer == correct) return Colors.green.shade400;
    if (answer == _selectedAnswer && _selectedAnswer != correct) return Colors.red.shade400;
    return Colors.grey.shade200;
  }

  @override
  Widget build(BuildContext context) {
    final answers = _questions[_questionIndex]['answers'] as List<String>;

    return Scaffold(
      appBar: AppBar(title: const Text('India & TN Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Time: $_secondsRemaining s",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _secondsRemaining <= 5 ? Colors.red : Colors.black
                    )
                ),
                Text("Score: $_score", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: _secondsRemaining / 20,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(_secondsRemaining <= 5 ? Colors.red : Colors.indigo),
            ),
            const SizedBox(height: 20),
            Text("Question ${_questionIndex + 1}/${_questions.length}", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Text(_questions[_questionIndex]['questionText'] as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 30),
            ...answers.map((answer) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ElevatedButton(
                onPressed: () => _answerQuestion(answer),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getButtonColor(answer),
                  foregroundColor: _isAnswered ? Colors.white : Colors.black87,
                  padding: const EdgeInsets.all(16),
                ),
                child: Text(answer),
              ),
            )),
            const Spacer(),
            if (_isAnswered)
              ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.all(16)),
                child: Text(_questionIndex < _questions.length - 1 ? 'Next Question' : 'View Results'),
              ),
          ],
        ),
      ),
    );
  }
}
