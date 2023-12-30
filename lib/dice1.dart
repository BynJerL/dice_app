import 'dart:async';
import 'dart:io';
import 'dart:math';

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
  }

  return next;
}

void main(){
  int maxIter = 11;
  int delayFac = 1;
  int multi = 2; 
  int CurrDice = Random().nextInt(6) + 1;
  for (int iter = 0; iter < maxIter; iter++) {
    sleep(Duration(milliseconds: delayFac * multi));
    print("Current Number: $CurrDice");

    CurrDice = RollDice(CurrDice)!;
    print("Next Number: $CurrDice");
    multi *= 2;
  }
}