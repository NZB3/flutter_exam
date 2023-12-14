import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:lecture_1_app/api/api.dart';
import 'package:lecture_1_app/model/cat_model.dart';
import 'package:lecture_1_app/model/user_model.dart';
import 'package:lecture_1_app/storage/storage.dart';

const path = 'assets/cats_imgs.json';

abstract class AbstractService {
  Future<void> login(String login, String password);

  Future<bool> isLogged();

  Future<void> logout();

  Future<void> likeCat(Cat cat);

  Future<List<Cat>> getLikedCats();

  Future<void> unlikeCat(Cat cat);

  Future<bool> isLiked(Cat cat);

  Future<List<Cat>> loadCats({int limit = 10});

  Future<Cat?> getRandomCat();
}

class Service implements AbstractService {
  final Storage storage;
  final API api;

  Service(this.storage, this.api);

  @override
  Future<void> login(String login, String password) async {
    final user = await storage.getUser(login);
    if (user == null) {
      var user = User(login: login, password: password);
      storage.saveUser(user);
      storage.setActiveUser(login);
    }

    if (user?.password == password) {
      storage.setActiveUser(login);
    }

    throw Exception('Wrong password');
  }

  @override
  Future<bool> isLogged() async {
    final user = await storage.getActiveUser();
    return user != null;
  }

  @override
  Future<void> logout() async {
    storage.clearActiveUser();
  }

  @override
  Future<void> likeCat(Cat cat) async {
    final user = await storage.getActiveUser();
    if (user == null) {
      throw Exception('User is not logged in');
    }

    user.likeCat(cat);

    storage.saveUser(user);
  }

  @override
  Future<List<Cat>> getLikedCats() async {
    final user = await storage.getActiveUser();
    if (user == null) {
      throw Exception('User is not logged in');
    }

    return user.likedCats;
  }

  @override
  Future<void> unlikeCat(Cat cat) async {
    final user = await storage.getActiveUser();
    if (user == null) {
      throw Exception('User is not logged in');
    }

    user.unlikeCat(cat);

    storage.saveUser(user);
  }

  @override
  Future<bool> isLiked(Cat cat) async {
    final user = await storage.getActiveUser();
    if (user == null) {
      throw Exception('User is not logged in');
    }

    return user.isLiked(cat);
  }

  @override
  Future<List<Cat>> loadCats({int limit = 10}) async {
    final List<Cat> cats = [];
    for (int i = 0; i < limit; i++) {
      try {
        final cat = await getRandomCat();
        cats.add(cat!);
      } catch (e) {
        print(e);
      }
    }
    return cats;
  }

  @override
  Future<Cat?> getRandomCat() async {
    final internetAvailable = await storage.getNetworkStatus();
    if (internetAvailable) {
      final cat = await api.getCat();
      storage.saveCat(cat);
      return cat;
    }

    final cat = storage.getRandomCat();
    if (cat == null) {
      throw Exception('No cats available');
    }

    return cat;
  }

  Future<Cat> getCats() async {
    final source = await rootBundle.loadString(path, cache: false);
    final json = jsonDecode(source);
    await Future.delayed(const Duration(seconds: 1));
    return Cat.fromJson(json);
  }
}