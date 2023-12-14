import 'dart:convert';
import 'dart:math';

import 'package:lecture_1_app/model/cat_model.dart';
import 'package:lecture_1_app/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AbstractStorage {
  Future<SharedPreferences> get prefs;

  Future<void> saveUser(User user);

  Future<void> saveCat(Cat cat);

  Future<void> saveCats(List<Cat> cats);

  Future<Cat?> getCat(String uri);

  Future<Cat?> getRandomCat();

  Future<User?> getUser(String name);

  Future<User?> getActiveUser();

  Future<void> setActiveUser(String login);

  Future<void> clearActiveUser();

  Future<bool> getNetworkStatus();

  Future<void> setNetworkStatus(bool status);
}

class Storage implements AbstractStorage {
  static final Storage _instance = Storage._internal();

  factory Storage() {
    return _instance;
  }

  Storage._internal();

  @override
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @override
  Future<void> saveUser(User user) async {
    final prefs = await this.prefs;
    prefs.setString(user.login, jsonEncode(user.toJson()));
  }

  @override
  Future<void> saveCat(Cat cat) async {
    final prefs = await this.prefs;
    final cats = prefs.getStringList('cats');
    if (cats == null) {
      prefs.setStringList('cats', [cat.url]);
    } else {
      cats.add(cat.url);
      prefs.setStringList('cats', cats);
    }

    prefs.setString(cat.url, jsonEncode(cat.toJson()));
  }

  @override
  Future<void> saveCats(List<Cat> cats) async {
    for (var cat in cats) {
      saveCat(cat);
    }
  }

  @override
  Future<Cat?> getCat(String uri) async {
    final prefs = await this.prefs;
    final catJson = prefs.getString(uri);
    if (catJson == null) {
      return null;
    }
    return Cat.fromJson(jsonDecode(catJson));
  }

  @override
  Future<Cat?> getRandomCat() async {
    final prefs = await this.prefs;
    final cats = prefs.getStringList('cats');
    if (cats == null) {
      return null;
    }
    final random = cats[Random().nextInt(cats.length)];
    return getCat(random);
  }

  @override
  Future<User?> getUser(String name) async {
    final prefs = await this.prefs;
    final userJson = prefs.getString(name);
    if (userJson == null) {
      return null;
    }
    return User.fromJson(jsonDecode(userJson));
  }

  @override
  Future<User?> getActiveUser() async {
    final prefs = await this.prefs;
    final login = prefs.getString('activeUser');
    if (login == null) {
      return null;
    }
    return getUser(login);
  }

  @override
  Future<void> setActiveUser(String login) async {
    final prefs = await this.prefs;
    prefs.setString('activeUser', login);
  }

  @override
  Future<void> clearActiveUser() async {
    final prefs = await this.prefs;
    prefs.remove('activeUser');
  }

  @override
  Future<bool> getNetworkStatus() async {
    final prefs = await this.prefs;
    return prefs.getBool('networkStatus') ?? false;
  }

  @override
  Future<void> setNetworkStatus(bool status) async {
    final prefs = await this.prefs;
    prefs.setBool('networkStatus', status);
  }
}