import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(Calculator());
}

class Calculator extends StatelessWidget {
  const Calculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SimpleCalculator(),
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  const SimpleCalculator({super.key});

  @override
  State<SimpleCalculator> createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  String equations = "0";
  String resault = "0";
  String tempEquations = "";
  double equationsFonts = 48.0;
  double resaultFonts = 38.0;
  void buttonPressed(String text) {
    if (text == "C") {
      setState(() {
        equationsFonts = 38.0;
        resaultFonts = 48.0;
      });
      setState(() {
        equations = "0";
        resault = "0";
      });
    } else if (text == "⌫") {
      setState(() {
        equationsFonts = 48.0;
        resaultFonts = 38.0;
        equations = equations.substring(0, equations.length - 1);
      });
    } else if (text == "=") {
      setState(() {
        equationsFonts = 38.0;
        resaultFonts = 48.0;
      });
      tempEquations = equations;
      tempEquations = tempEquations.replaceAll("x", "*");
      tempEquations = tempEquations.replaceAll("÷", "/");

      try {
        Parser p = Parser();
        Expression exp = p.parse(tempEquations);
        ContextModel cm = ContextModel();
        setState(() {
          resault = "=" + "${exp.evaluate(EvaluationType.REAL, cm)}";
        });
      } catch (e) {
        print("Hata var");
        print(e);
        resault = "Error";
      }
    } else {
      setState(() {
        equationsFonts = 48.0;
        resaultFonts = 38.0;
        if (equations == "0") {
          setState(() {
            equations = text;
          });
        } else {
          equations = equations + text;
        }
      });
    }
  }

  Widget buidButton(String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
                side: BorderSide(
                    color: Colors.black, width: 1, style: BorderStyle.solid)),
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.normal, color: Colors.white),
        ),
        onPressed: () {
          buttonPressed(buttonText);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hesap Makinesi",
        ),
        centerTitle: true,
      ),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.30,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: Text(
                        equations,
                        style: TextStyle(fontSize: equationsFonts),
                      )),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: Text(
                        resault,
                        style: TextStyle(fontSize: resaultFonts),
                      )),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.55,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Table(
                      children: [
                        TableRow(children: [
                          buidButton("C", 1, Colors.redAccent),
                          buidButton("⌫", 1, Colors.blue),
                          buidButton("÷", 1, Colors.blue),
                        ]),
                        TableRow(children: [
                          buidButton("7", 1, Colors.black54),
                          buidButton("8", 1, Colors.black54),
                          buidButton("9", 1, Colors.black54),
                        ]),
                        TableRow(children: [
                          buidButton("4", 1, Colors.black54),
                          buidButton("5", 1, Colors.black54),
                          buidButton("6", 1, Colors.black54),
                        ]),
                        TableRow(children: [
                          buidButton("1", 1, Colors.black54),
                          buidButton("2", 1, Colors.black54),
                          buidButton("3", 1, Colors.black54),
                        ]),
                        TableRow(
                          children: [
                            buidButton(".", 1, Colors.black54),
                            buidButton("0", 1, Colors.black54),
                            buidButton("00", 1, Colors.black54),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Table(
                      children: [
                        TableRow(children: [
                          buidButton("x", 1, Colors.blue),
                        ]),
                        TableRow(children: [
                          buidButton("+", 1, Colors.blue),
                        ]),
                        TableRow(children: [
                          buidButton("-", 1, Colors.blue),
                        ]),
                        TableRow(children: [
                          buidButton("=", 2, Colors.redAccent),
                        ]),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }
}
