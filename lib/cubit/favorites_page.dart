import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lecture_1_app/model/cat_model.dart';
import 'package:lecture_1_app/storage/storage.dart';
import 'package:lecture_1_app/api/api.dart';
import 'package:lecture_1_app/service/service.dart';

import 'favorites_cubit.dart';



class FavoritesPage extends StatelessWidget {
  final List<Cat> favoriteCats;
  final AbstractService service;

  const FavoritesPage({Key? key, required this.favoriteCats, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Избранные котики'),
      ),
      backgroundColor: Colors.pink.shade200,
      body: BlocBuilder<FavoritesCubit, List<Cat>>(
        builder: (context, state) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: favoriteCats.length,
            itemBuilder: (context, index) {
              return FavoritesCard(cat: favoriteCats[index]);
            },
          );
        },
      ),
    );
  }
}

class FavoritesCard extends StatelessWidget {
  final Cat cat;
  final AbstractService service;
  const FavoritesCard(this.service, {Key? key, required this.cat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              cat.url,
              fit: BoxFit.cover,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              service.unlikeCat(cat);
            },
          ),
        ],
      ),
    );
  }
}