/// Objects created from parsed json to simulate the quiz
class Quiz {
  List<Question> questions;
  int length;

  Quiz(this.questions, this.length);
}

class Question {
  String question;
  dynamic rightAnswer;
  dynamic providedAnswer;
  List<String> options;
  bool correct = false;
  bool answered = false;
  String figure;
  Question(this.question, this.rightAnswer, this.figure);

  void submitAnswer(dynamic answer){}
}

class MultipleChoiceQuestion extends Question {
  List<String> options;
  MultipleChoiceQuestion(String question, rightAnswer, figure, this.options) : super(question, rightAnswer, figure);

  @override
  void submitAnswer(dynamic answer){
    if(answer == rightAnswer)
      this.correct = true;
    else
      this.correct = false;

    this.answered = true;
    this.providedAnswer = answer;
  }

}

class FillInBlankQuestion extends Question {
  FillInBlankQuestion(String question, rightAnswer, figure) : super(question, rightAnswer, figure);

  @override
  void submitAnswer(dynamic answer){
    if(rightAnswer.any((f) => f == answer))
      this.correct = true;
    else
      this.correct = false;

    this.answered = true;
    this.providedAnswer = answer;
  }

}
