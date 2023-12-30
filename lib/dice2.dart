import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class DiceAppA extends StatefulWidget {
  const DiceAppA({super.key});

  @override
  State<DiceAppA> createState() => _DiceAppAState();
}

class _DiceAppAState extends State<DiceAppA> {
  late int diceAmmount;
  int minDiceAmmount = 1;
  int maxDiceAmmount = 3;
  late List currDice = List.filled(maxDiceAmmount, 0);
  int maxIter = 10;
  int delayFac = 1;
  int multi = 2;
  bool isRolling = false;

  @override
  void initState() {
    super.initState();
    diceAmmount = minDiceAmmount;

    for(int i = 0; i < diceAmmount; i++) {
      currDice[i] = Random().nextInt(6) + 1;
    }
  }

  int? RollDice(int curr){
    int? next;
    List choices;

    if (curr == 1 || curr == 6) {
      choices = [2,3,4,5];
      next = choices[Random().nextInt(choices.length)];
    } else if (curr == 2 || curr == 5) {
      choices = [1,3,4,6];
      next = choices[Random().nextInt(choices.length)];
    } else if (curr == 3 || curr == 4) {
      choices = [1,2,5,6];
      next = choices[Random().nextInt(choices.length)];
    } else {
      next = Random().nextInt(6) + 1;
    }

    return next;
  }

  Future<void> RoundDice() async {
    for (int iter = 0; iter < maxIter; iter++) {
      await Future.delayed(Duration(milliseconds: delayFac * multi));

      setState(() {
        for(int i = 0; i < diceAmmount; i++) {
          currDice[i] = RollDice(currDice[i])!;
        }
      });

      multi *= 2;
    }
    setState(() {
      isRolling = false;
      multi = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for(int i = 0; i < diceAmmount; i++)
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Image(
                    width: 75,
                    image: AssetImage('assets/img/dice_${currDice[i]}.png')
                  ),
                ),
              // Image(
              //   width: 75,
              //   image: AssetImage('assets/img/dice_$currDice_1.png')
              // ),
              // SizedBox(width: 10),
              // Image(
              //   width: 75,
              //   image: AssetImage('assets/img/dice_$currDice_2.png')
              // ),
              // SizedBox(width: 10),
              // Image(
              //   width: 75,
              //   image: AssetImage('assets/img/dice_$currDice_3.png')
              // )
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: (isRolling == true) ? null: (){
              setState(() {
                isRolling = true;
              });
              RoundDice();
              }, 
            child: Text("Roll")
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: (diceAmmount >= maxDiceAmmount) ? null: (){
                  setState(() {
                    diceAmmount++;
                  });
                  }, 
                child: Icon(Icons.add)
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: (diceAmmount <= minDiceAmmount) ? null: (){
                  setState(() {
                    currDice[diceAmmount - 1] = 0;
                    diceAmmount--;
                  });
                  }, 
                child: Icon(Icons.remove)
              ),
            ],
          )
        ],
      ),
    );
  }
}