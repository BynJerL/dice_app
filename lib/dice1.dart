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
  int CurrDice = Random().nextInt(6) + 1;
  print("Current Number: $CurrDice");

  int? NextDice = RollDice(CurrDice);
  print("Next Number: $NextDice");
}