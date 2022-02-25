import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  late final String name;
  Timestamp dateTime;
  late int price;
  int paid;
  int deposit;

  Person(this.name, this.dateTime,
      {this.deposit = 0, this.paid = 0, this.price = 0});

  Person.fromJson(json)
      : name = json['name'],
        dateTime = json['datetime'],
        paid = json['paid'],
        deposit = json['deposit'],
        price = 0;
}
