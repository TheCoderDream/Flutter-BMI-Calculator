import 'package:flutter/material.dart';

enum Gender {
  male,
  female
}

void main() {
  runApp(App());
}

class App extends StatelessWidget {

  @override
  Widget build(context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('BMI Calculator'),
          leading: const Icon(
            Icons.calculate_outlined
          ),
        ),
        body: SafeArea(
          child: BIMCalculatorScreen(),
        ),
      ),
    );
  }
}

class BIMCalculatorScreen extends StatefulWidget {
  @override
  _BIMCalculatorScreen createState() => _BIMCalculatorScreen();
}

class _BIMCalculatorScreen extends State<BIMCalculatorScreen> {
  double height = 150;
  double weight = 60;
  Gender gender = Gender.male;
  double bmi = 0;

  List<Widget> buildHeightSlider() {
    return [
      createHeading('Height'),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          createText(height.toString()),
          SizedBox(width: 3,),
          const Text(
            'cm',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          )
        ],
      ),
      Slider(
        value: height,
        min: 120,
        max: 220,
        divisions: 100,
        onChanged: (newHeight) {
          setState(() {
            height = newHeight;
          });
        },
      )
    ];
  }

  Widget createMaleAndFemaleOptions() {
    return  Row(
      children: [
        Expanded(
          child: GestureDetector(
            child: Card(
              color: gender == Gender.male ? Colors.pink : null,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.male, size: 30,),
                    Text(
                      'Male',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                      ),
                    )
                  ],
                ),
              ),
            ),
            onTap: () {
              setState(() {
                setState(() {
                  gender = Gender.male;
                });
              });
            },
          )
        ),
        Expanded(
          child: GestureDetector(
            child: Card(
              color: gender == Gender.female ? Colors.pink : null,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.female, size: 30,),
                    Text(
                      'Female',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                      ),
                    )
                  ],
                ),
              ),
            ),
            onTap: () {
              setState(() {
                gender = Gender.female;
              });
            },
          ),
        )
      ],
    );
  }

  List<Widget> buildWeight() {
    return [
      createHeading('Weight'),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          createText(weight.toString()),
          SizedBox(width: 3,),
          const Text(
            'kg',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          )
        ],
      ),
      SizedBox(height: 20,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                weight--;
              });
            },
            backgroundColor: Colors.grey,
            child: const Icon(Icons.remove),
          ),
          SizedBox(width: 10,),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                weight++;
              });
            },
            backgroundColor: Colors.grey,
            child: const Icon(Icons.add),
          ),
        ],
      ),
      SizedBox(height: 20,),
      Container(
        width: double.infinity,
        height: 80,
        child: ElevatedButton(
          child: Text('Calculate', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
          onPressed: () {
            Navigator.push(
              context,
                MaterialPageRoute(
                    builder: (context) => ResultPage(height: height, weight: weight, gender: gender)
                )
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
          ),
        ),
      )
    ];
  }


  @override build(context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          createMaleAndFemaleOptions(),
          SizedBox(height: 20,),
          ...buildHeightSlider(),
          ...buildWeight()
        ],
      ),
    );
  }
}

Widget createHeading(String title) {
  return Text(
    title,
    style: const TextStyle(
        fontSize: 18,
        color: Colors.white70
    ),
  );
}

Widget createText(String text) {
  return Text(
    text,
    style: const TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.w900
    ),
  );
}

class ResultPage extends StatelessWidget {
  final double height;
  final double weight;
  final Gender gender;

  ResultPage({required this.height, required this.weight, required this.gender, super.key});

  @override
  Widget build(context) {
    final double bmi = calculateBMI();
    final String bmiType = categorizeBMI(bmi);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  'Your BMI',
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold
                  )
              ),
              Text(
                bmi.toStringAsFixed(2),
                style: const TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'You are $bmiType',
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70
                ),
              )
            ],
          ),
        )
    );
  }

  double calculateBMI() {
    double bmi = weight / ((height / 100) * height /100);

    if (gender == Gender.male) {
      bmi *= 0.9;
    } else if(gender == Gender.female) {
      bmi *= 1.1;
    }

    return bmi;
  }

  String categorizeBMI(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if ( bmi >= 18.5 && bmi < 25) {
      return 'Normal Weight';
    } else if (bmi >=25 && bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }
}