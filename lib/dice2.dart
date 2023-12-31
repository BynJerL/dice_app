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
  int maxDiceAmmount = 4;
  late List currDice = List.filled(maxDiceAmmount, 0);
  int maxIter = 10;
  int delayFac = 1;
  int multi = 2;
  int sum = 0;
  bool isRolling = false;
  bool isEqual = false;

  @override
  void initState() {
    super.initState();
    diceAmmount = minDiceAmmount;

    for(int i = 0; i < diceAmmount; i++) {
      currDice[i] = Random().nextInt(6) + 1;
      sum += int.parse(currDice[i].toString());
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
        sum = 0;
        for(int i = 0; i < diceAmmount; i++) {
          currDice[i] = RollDice(currDice[i])!;
          sum += int.parse(currDice[i].toString());
        }
      });

      multi *= 2;
    }
    setState(() {
      isRolling = false;
      multi = 2;
    });
    equalChecker();
  }

  void equalChecker(){
    bool isInequal = false;
    for (int iter = 0; iter < diceAmmount; iter++){
      if (currDice[iter] != currDice[0]){
        setState(() {
          isEqual = false;
          isInequal = true;
        });
      }
    }
    if (isInequal == false && 
        diceAmmount != 1) {
      setState(() {
        isEqual = true;
      });
    }
    print(isEqual);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Text(
            "Dice App",
            style: TextStyle(
              fontSize: 30
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              (isEqual == false)? "": "Lucky",
              style: TextStyle(
                fontSize: 36
              ),
            ),
            Text(
              (isRolling == true)?"":"$sum",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 128,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 240,
              height: 240,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for(int i = 0; i < (diceAmmount/2).ceil(); i++) Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for(int j = 0; j < ((diceAmmount - 2*i != 1)? 2: 1); j++) Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Image(
                              width: 100,
                              image: AssetImage('assets/img/dice_${currDice[i*2+j]}.png')
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
      
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     for(int i = 0; i < diceAmmount; i++)
            //       Padding(
            //         padding: const EdgeInsets.only(left: 5, right: 5),
            //         child: Image(
            //           width: 75,
            //           image: AssetImage('assets/img/dice_${currDice[i]}.png')
            //         ),
            //       ),
            //   ],
            // ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (isRolling == true) ? null: (){
                setState(() {
                  isRolling = true;
                  isEqual = false;
                });
                RoundDice();
                }, 
              child: Container(
                width: 150,
                height: 50,
                child: Center(
                  child: Text(
                    "Roll",
                    style: TextStyle(
                      fontSize: 25
                    ),
                  )
                )
              )
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
                  child: Container(
                    height: 64,
                    child: Icon(Icons.add, size: 36))
                ),
                SizedBox(width: 45),
                ElevatedButton(
                  onPressed: (diceAmmount <= minDiceAmmount) ? null: (){
                    setState(() {
                      currDice[diceAmmount - 1] = 0;
                      diceAmmount--;
                    });
                    }, 
                  child: Container(
                    height: 64,
                    child: Icon(Icons.remove, size: 36)
                  )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}