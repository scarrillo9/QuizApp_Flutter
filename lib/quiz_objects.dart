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
  Question(this.question, this.rightAnswer);

  void submitAnswer(dynamic answer){}
}

class MultipleChoiceQuestion extends Question {
  List<String> options;
  MultipleChoiceQuestion(String question, rightAnswer, this.options) : super(question, rightAnswer);

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
  FillInBlankQuestion(String question, rightAnswer) : super(question, rightAnswer);

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
