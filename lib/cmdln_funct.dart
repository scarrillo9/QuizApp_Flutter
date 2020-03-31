/// Homework 1: Dart (Quiz App)
/// Dr. Cheon - Cross-Platform App Development
/// Stefany Carrillo

import 'quiz_objects.dart';
import 'dart:io';
import 'dart:math';


/// quizLength returns Quiz object based on the length the user specified
Quiz quizLength(List<Question> questions, [int numberOfQuestions = 5]) {

  print(questions.length);
  List<Question> newList = new List<Question>();
  var r = new Random();
  print(questions.elementAt(0).question);
  questions.shuffle(r);
  for(int i = 0; i < numberOfQuestions; i++){
    print(i);
    newList.add(questions.elementAt(i));
      }

  return createQuiz(newList);
}

/// createQuiz method makes Quiz object based on the questions
/// gotten from quizLength
Quiz createQuiz(List<Question> questions) {
  return Quiz(questions, questions.length);
}