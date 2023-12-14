import 'dart:math';

import 'package:lecture_1_app/model/cat_model.dart';

class User {
  final String login;
  String? password;
  List<Cat> likedCats = [];

  User({required this.login, this.password, this.likedCats = const []});

  void likeCat(Cat cat) {
    likedCats.add(cat);
  }

  void unlikeCat(Cat cat) {
    likedCats.remove(cat);
  }

  bool isLiked(Cat cat) {
    return likedCats.contains(cat);
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
    login: json['login'],
    password: json['password'],
    likedCats: List.from(
      json['likedCats'],
    ),
  );

  Map<String, dynamic> toJson() => {
    'login': login,
    'password': password,
  };
}