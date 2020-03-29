import 'quiz_objects.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// OBJECTS FOR JSON PARSING
/// JsonQuiz with constructor creating a Jquiz object
/// used https://github.com/javiercbk/json_to_dart for help on parsing objects
class JsonQuiz {
  bool response;
  Jquiz quiz;

  JsonQuiz.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    quiz = json['quiz'] != null ? new Jquiz.fromJson(json['quiz']) : null;
  }
}

/// Jquiz with constructor creating multiple Jquestion objects
class Jquiz {
  String name;
  List<Jquestion> question;

  Jquiz({this.name, this.question});

  Jquiz.fromJson(Map<String, dynamic> json){
    name = json['name'];
    if (json['question'] != null) {
      question = new List<Jquestion>();
      json['question'].forEach((v) => question.add(new Jquestion.fromJson(v)));
    }
  }
}

/// Jquestion with constructor
/// based on question, option is going to be null (Fill-in) or not (MC)
class Jquestion {
  int type;
  String stem;
  dynamic answer;
  List<String> option;

  Jquestion({this.type, this.stem, this.answer, this.option});

  Jquestion.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    stem = json['stem'];
    answer = json['answer'];
    if(json['option'] != null) {
      option = json['option'].cast<String>();
    }
  }
}

/// NETWORKING METHODS ///
List<Question> qBank;
final String URL_BASE = 'http://www.cs.utep.edu/cheon/cs4381/homework/quiz/post.php';

/// getBank method calls the getConnection method to get all questions
/// and returns the list of questions (question bank)
Future<List<Question>> getBank(String username, String password) async {
  String quizName = '0';
  List<Question> temp = List<Question>();
  List<Question> real = List<Question>();

  for(int i = 1; i < 9; i++){
    String curr = i.toString();

    Future<List<Question>> list = getConnection(username, password, quizName+curr);
    await list.then((temp){
      if(real.isEmpty) {
        real = temp;
      }
      else {
        real = real + temp;
      }
    });
  }
  return real;
}

/// getConnection method establishes connection and receives json string
/// to parse and create Question objects.
/// Returns list of questions for the quiz being requested
Future<List<Question>> getConnection(String username, String password, String quizName) async {
  var url = URL_BASE;
  var body = '{"user" : "$username", "pin" : "$password", "quiz" : "quiz$quizName"}';
  var response = await http.post(url, body: body);
  var res = json.decode(response.body);

  var quiz = JsonQuiz.fromJson(res);

  //print('Response status: ${response.statusCode}');
  //print(quiz.quiz.question.elementAt(0).stem);
  qBank = new List<Question>();
  if(quiz.quiz != null) {
    quiz.quiz.question.forEach((f) => jsonToObject(f));
  }
  return qBank;
}

/// jsonToObject method creates the question objects from the json objects
/// based on if the question is MC or Fill-in
void jsonToObject(Jquestion q){
  if(q.type == 1) {
    MultipleChoiceQuestion mq = new MultipleChoiceQuestion(q.stem, q.answer, q.option);
    qBank.add(mq);
    //print(mq.question);
  }
  else if(q.type == 2) {
    FillInBlankQuestion fq = new FillInBlankQuestion(q.stem, q.answer);
    qBank.add(fq);
    //print(fq.question);
  }
}

////JSON STYLE
//response body: {response:, quiz: {name:, question: [{q1}, {q2}]}]
//
//q1:
//type: 1 (multiple choice)
//stem: question
//answer: int
//option: []
//
//q2
//type: 2 (fill-in blank)
//stem: question
//answer: []