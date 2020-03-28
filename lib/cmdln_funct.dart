/// Homework 1: Dart (Quiz App)
/// Dr. Cheon - Cross-Platform App Development
/// Stefany Carrillo

import 'network.dart';
import 'quiz_objects.dart';
import 'dart:io';
import 'dart:math';

//void main() {
//  Future<List<Question>> b = getBank();
//  List<Question> questionBank = new List<Question>();
//  b.then((questionBank) {
//    stdout.write("${questionBank.length} questions retrieved");
//    Quiz q = quizLength(questionBank);
//    displayQuiz(q);
//  });
//}

/// quizLength returns Quiz object based on the length the user specified
Quiz quizLength(List<Question> questions) {
  List<Question> newList = new List<Question>();
  var r = new Random();
  bool invalid = true;

  while(invalid) {
    try {
      stdout.write("\n\nHow many questions in your quiz? [Default = 5]: ");
      String quizCount = stdin.readLineSync();

      if(quizCount == ""){
        questions.shuffle(r);
        for(int i = 0; i < 5; i++){
          newList.add(questions.elementAt(i));
        }
        invalid = false;
      }
      else {
        int intCount = int.parse(quizCount);
        invalid = false;
        questions.shuffle(r);
        for(int i = 0; i < intCount; i++){
          newList.add(questions.elementAt(i));
        }
      }
    } catch (e) {
      stdout.write("Invalid input. Try again");
      invalid = true;
    }
  }
  return createQuiz(newList);
}

/// createQuiz method makes Quiz object based on the questions
/// gotten from quizLength
Quiz createQuiz(List<Question> questions) {
  return Quiz(questions, questions.length);
}

/// Takes in Quiz object and calls respective print methods based on
/// type of question.
/// Prints out the Score of the quiz once all answers have been answered.
void displayQuiz(Quiz q){
  int quizLength = q.length;
  List<Question> quiz = q.questions;

  while(quiz.any((f) => !f.answered)){
    Iterable<Question> current = quiz.where((f) => !f.answered);
    stdout.write("\n${current.length} questions left to answer\n");
    current.forEach((f) {
      if(f is FillInBlankQuestion) {
        printFillInBlank(f);
      }
      else if(f is MultipleChoiceQuestion){
        printMultipleChoice(f);
      }
    });
  }

  int qc = quiz.fold(0, (qc, f) => qc + (f.correct ? 1 :0));
  double score = (qc / quizLength) * 100;
  stdout.write("\nQuiz Score: ${score}%");

  stdout.write("\n\nWould you like to review the wrong questions? [y/n]: ");
  dynamic response = stdin.readLineSync();

  if(response == "y"){
    review(q.questions);
  }

} //end display quiz

/// review method is to look at the questions that the user got wrong
void review(List<Question> q){
  Iterable<Question> wrongQ = q.where((f) => !f.correct);

  wrongQ.forEach((f) {
    stdout.write("\n${f.question}");
    if (f is MultipleChoiceQuestion){
      for(int n = 0; n < f.options.length; n++){
        stdout.write('\n\t${n+1}. ${f.options.elementAt(n)}');
      }
    }
    stdout.write("\nAnswer: ${f.rightAnswer}\nNext? ");
    stdin.readLineSync();
  });
}

/// printFillInBlank method prints and accepts answers
/// for current fill in question
/// may changes q.answered and q.correct
void printFillInBlank(FillInBlankQuestion q) {
  stdout.write(q.question);
  List<dynamic> answers = q.rightAnswer as List<dynamic>;
  stdout.write("\nEnter your answer: ");
  dynamic response = stdin.readLineSync();
  if(answers.any((f) => f == response)){
    print("correct");
    q.correct = true;
    q.answered = true;
  }
  else if(response == ""){
    q.answered = false;
  }
  else {
    q.answered = true;
  }

} //end print fill in blank

/// printMultipleChoice method prints and accepts answers
/// for current multiple choice question
/// may changes q.answered and q.correct
void printMultipleChoice(MultipleChoiceQuestion q) {
  stdout.write(q.question);
  int numAnswers = q.options.length;

  for(int n = 0; n < numAnswers; n++){
    stdout.write('\n\t${n+1}. ${q.options.elementAt(n)}');
  }

  stdout.write("\nEnter your answer (1-${numAnswers}): ");
  bool invalid = true;

  while(invalid) {
    try {
      dynamic response = stdin.readLineSync();
      if (response == "") {
        q.answered = false;
        invalid = false;
      }
      else {
        int intResponse = int.parse(response);
        if (intResponse == q.rightAnswer) {
          q.correct = true;
        }
        invalid = false;
        q.answered = true;
      }
    } catch (e) {
      stdout.write("Invalid option: Try again");
      invalid = true;
    }
  }

} //end print multiple choice