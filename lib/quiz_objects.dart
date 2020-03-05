/// Objects created from parsed json to simulate the quiz
class Quiz {
  List<Question> questions;
  int length;

  Quiz(this.questions, this.length);
}

class Question {
  String question;
  dynamic rightAnswer;
  bool correct = false;
  bool answered = false;
  Question(this.question, this.rightAnswer);
}

class MultipleChoiceQuestion extends Question {
  List<String> options;
  MultipleChoiceQuestion(String question, rightAnswer, this.options) : super(question, rightAnswer);

}

class FillInBlankQuestion extends Question {
  FillInBlankQuestion(String question, rightAnswer) : super(question, rightAnswer);

}
