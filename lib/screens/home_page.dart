import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../all_constants.dart';
import '../ques_ans_file.dart';
import '../reusable_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndexNumber = 0;
  double _initial = 0.1;
  final myController =
      TextEditingController(); // Définir le contrôleur TextEditingController
  int scoreGood = 0;
  int scoreBad = 0;

  @override
  Widget build(BuildContext context) {
    String value = (_initial * 10).toStringAsFixed(0);
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
            centerTitle: true,
            title: Text("Quiz GPT", style: TextStyle(fontSize: 30)),
            backgroundColor: mainColor,
            toolbarHeight: 80,
            elevation: 5,
            shadowColor: mainColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Text("Question $value sur 10 complétée", style: otherTextStyle),
              SizedBox(height: 5),
              Text(
                  "$scoreGood  bonnes réponses et $scoreBad mauvaises réponses",
                  style: otherTextStyle),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                  minHeight: 5,
                  value: _initial,
                ),
              ),
              SizedBox(height: 25),
              SizedBox(
                  width: 300,
                  height: 245,
                  child: FlipCard(
                      direction: FlipDirection.VERTICAL,
                      front: ReusableCard(
                          text: quesAnsList[_currentIndexNumber].question),
                      back: ReusableCard(
                          text: quesAnsList[_currentIndexNumber].answer))),
              //Text("cliquer pour voir la réponse", style: otherTextStyle),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: myController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'saisissez votre réponse',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        // Récupérer la valeur du champ TextFormField
                        String value = myController.text;
                        // Utiliser la valeur récupérée pour valider ou invalider la réponse
                        if (value == quesAnsList[_currentIndexNumber].answer) {
                          scoreGood = scoreGood + 1;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Bravo! Bonne réponse!')),
                          );
                        } else {
                          scoreBad = scoreBad + 1;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Tu as saisi $value. Dommage. Essaye encore!')),
                          );
                        }
                        // Forcer la mise à jour de l'interface graphique
                        setState(() {});
                      },
                      child: const Text('valider'),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ElevatedButton.icon(
                        onPressed: () {
                          showPreviousCard();
                          updateToPrev();
                        },
                        icon: Icon(FontAwesomeIcons.handPointLeft, size: 30),
                        label: Text(""),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.only(
                                right: 20, left: 25, top: 15, bottom: 15))),
                    ElevatedButton.icon(
                        onPressed: () {
                          showNextCard();
                          updateToNext();
                        },
                        icon: Icon(FontAwesomeIcons.handPointRight, size: 30),
                        label: Text(""),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.only(
                                right: 20, left: 25, top: 15, bottom: 15)))
                  ])
            ])));
  }

  void updateToNext() {
    setState(() {
      _initial = _initial + 0.1;
      if (_initial > 1.0) {
        _initial = 0.1;
      }
    });
  }

  void updateToPrev() {
    setState(() {
      _initial = _initial - 0.1;
      if (_initial < 0.1) {
        _initial = 1.0;
      }
    });
  }

  void showNextCard() {
    setState(() {
      _currentIndexNumber = (_currentIndexNumber + 1 < quesAnsList.length)
          ? _currentIndexNumber + 1
          : 0;
    });
  }

  void showPreviousCard() {
    setState(() {
      _currentIndexNumber = (_currentIndexNumber - 1 >= 0)
          ? _currentIndexNumber - 1
          : quesAnsList.length - 1;
    });
  }
}
