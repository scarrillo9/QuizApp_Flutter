import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homework_2/quiz_objects.dart';
import 'network.dart';
import 'cmdln_funct.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Quiz App'),
    );
  }
}

class LoginData {
  String username = "";
  String password = "";
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LoginData _loginData = new LoginData();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  int _numberOfQuestions = 5;
  List<Question> _questionBank = new List<Question>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            padding: EdgeInsets.all(50.0),
            child: Form(
                key: this._formKey,
                child: Column(children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    validator: (String inValue) {
                      if (inValue.length == 0) {
                        return "Please enter username";
                      }
                      return null;
                    },
                    onSaved: (String inValue) {
                      this._loginData.username = inValue;
                    },
                    decoration: InputDecoration(
                        // hintText: "guest",
                        labelText: "Username"),
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (String inValue) {},
                    onSaved: (String inValue) {
                      this._loginData.password = inValue;
                    },
                    decoration: InputDecoration(
                        hintText: "Password", labelText: "Password"),
                  ),
                  RaisedButton(
                      child: Text("Log in!"),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();

                          //connectionhere
                          Future<List<Question>> connectedF =
                              getBank(_loginData.username, _loginData.password);
                          List<Question> questionBank = new List<Question>();
                          connectedF.then((questionBank) {
                            this._questionBank = questionBank;
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => landingPage()));
                          });
                        }
                      })
                ]))));
  }

  Scaffold landingPage() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Text("QuizApp"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  'Welcome to QuizApp.',
                  style: TextStyle(fontSize: 27),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Please Select a quiz from the list or generate a new one at random',
                style: TextStyle(fontSize: 18),
              ),
              Container(
                child: TextField(
                    decoration:
                        InputDecoration(labelText: 'Number of Questions'),
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp('[0-9]*'))
                    ],
                    onChanged: (value) {
                      _numberOfQuestions = int.parse(value);
                      print(value);
                    }),
              ),
              const SizedBox(height: 10),
              RaisedButton(
                onPressed: (() {
                  print(
                      "Generating new Quiz with $_numberOfQuestions questions");
                  Quiz quiz =
                      quizLength(this._questionBank, this._numberOfQuestions);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TakeQuiz(
                          quiz: quiz, quizLength: quiz.questions.length)));
                }),
                child: Text("Start Quiz"),
              )
            ],
          ),
        ),
      ),
    );
  }

//____________ Here we will write other stateful widgets

}

class TakeQuiz extends StatefulWidget {
  final Quiz quiz;
  final int quizLength;

  const TakeQuiz({Key key, this.quiz, this.quizLength}) : super(key: key);

  @override
  _TakeQuiz createState() => _TakeQuiz();
}

class _TakeQuiz extends State<TakeQuiz> {
  int currentQuestion = 0;
  dynamic answerGiven;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        if (currentQuestion != 0)
          setState(() {
            currentQuestion--;
            answerGiven = "";
          });
        break;
      case 1:
        if (widget.quiz.questions.any((f) => !f.answered)) print("Submit");

        break;
      case 2:
        if (currentQuestion != widget.quizLength - 1)
          setState(() {
            currentQuestion++;
            answerGiven = "";
          });
        //print(widget.quiz.questions[currentQuestion].runtimeType.toString());
        break;
    }
  }

  void _submitAnswer() {
    widget.quiz.questions[currentQuestion].submitAnswer(answerGiven);
    //print(selectedAnswer);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${currentQuestion + 1} / ${widget.quizLength}'),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child:   _buildQuestion()
            ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              title: Text("Previous"), icon: Icon(Icons.keyboard_arrow_left)),
          BottomNavigationBarItem(
              title: Text("Submit Quiz"), icon: Icon(Icons.cloud_upload)),
          BottomNavigationBarItem(
              title: Text("Next"), icon: Icon(Icons.keyboard_arrow_right)),
        ],
        currentIndex: 1,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildQuestion(){
    if(widget.quiz.questions[currentQuestion] is FillInBlankQuestion)
      return fillTheBlank();
    else if(widget.quiz.questions[currentQuestion] is MultipleChoiceQuestion)
      return multipleChoice();
  }

  Container multipleChoice() {
    return Container(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(widget.quiz.questions[currentQuestion].question),
          ),
          Column(
            children: _buildAnswers(
                widget.quiz.questions[currentQuestion].options),
          ),
          const SizedBox(height: 10,),
          RaisedButton(
            onPressed: () {
              print(answerGiven);
              _submitAnswer();
            },
            child: const Text(
                'Submit Answer',
                style: TextStyle(fontSize: 20)
            ),

          )
        ],
      ),
    );
  }

  List<Widget> _buildAnswers(List<dynamic> options) {
    return options.asMap().entries.map((entry) {
      return CheckboxListTile(
        title: Text(entry.value),
        value: answerGiven == entry.key,
        onChanged: (newValue) => setState(() => answerGiven = entry.key),
        controlAffinity: ListTileControlAffinity.leading,
      );
    }).toList();
  }

  Container fillTheBlank() {
    return Container(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(widget.quiz.questions[currentQuestion].question),
          ),
          TextField(
              decoration: InputDecoration(
                  labelText: 'Your Answer: ${widget.quiz.questions[currentQuestion].providedAnswer}',
                  hintText: 'Write Your Answer Here'
              ),
              onChanged: (value) {
                answerGiven = value;
              }),
          const SizedBox(height: 10,),
          RaisedButton(
            onPressed: () {
              print(answerGiven);
              _submitAnswer();
              },
            child: const Text(
                'Submit Answer',
                style: TextStyle(fontSize: 20)
            ),

          )
        ],
      ),
    );
  }
}

class reviewSession extends StatefulWidget {
  final Quiz quiz;
  final int quizLength;

  const reviewSession({Key key, this.quiz, this.quizLength}) : super(key: key);

  @override
  _reviewSession createState() => _reviewSession();
}


class _reviewSession extends State<reviewSession>{
  int currentQuestion = 0;
  dynamic answerGiven;

  List<Widget> _buildAnswers(List<dynamic> options) {
    return options.asMap().entries.map((entry) {
      return CheckboxListTile(
        title: Text(entry.value),
        value: widget.quiz.questions[currentQuestion].rightAnswer,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: null,
      );
    }).toList();
  }

  Container fillTheBlank() {
    return Container(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(widget.quiz.questions[currentQuestion].question),
          ),
          Text(
            'Given Answer: ${widget.quiz.questions[currentQuestion].providedAnswer}'
          ),
          const SizedBox(height: 10,),
          Text('Actual Answer: ${widget.quiz.questions[currentQuestion].rightAnswer}')
        ],
      ),
    );
  }

  Container multipleChoice() {
    return Container(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(widget.quiz.questions[currentQuestion].question),
          ),
          Column(
            children: _buildAnswers(
                widget.quiz.questions[currentQuestion].options),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        if (currentQuestion != 0)
          setState(() {
            currentQuestion--;
            answerGiven = "";
          });
        break;
      case 1:
        _returnToLanding(context);
        break;
      case 2:
        if (currentQuestion != widget.quizLength - 1)
          setState(() {
            currentQuestion++;
            answerGiven = "";
          });
        //print(widget.quiz.questions[currentQuestion].runtimeType.toString());
        break;
    }
  }

  Widget _buildQuestion(){
    if(widget.quiz.questions[currentQuestion] is FillInBlankQuestion)
      return fillTheBlank();
    else if(widget.quiz.questions[currentQuestion] is MultipleChoiceQuestion)
      return multipleChoice();
  }
  
   _returnToLanding(BuildContext context){
    Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('${currentQuestion + 1} / ${widget.quizLength}'),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child:   _buildQuestion()
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              title: Text("Previous"), icon: Icon(Icons.keyboard_arrow_left)),
          BottomNavigationBarItem(
              title: Text("Exit"), icon: Icon(Icons.exit_to_app)),
          BottomNavigationBarItem(
              title: Text("Next"), icon: Icon(Icons.keyboard_arrow_right)),
        ],
        currentIndex: 1,
        onTap: _onItemTapped,
      ),
    );
  }




}


