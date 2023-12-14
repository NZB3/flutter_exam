import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lecture_1_app/model/cat_model.dart';

import 'favorites_cubit.dart';

class FavoritesPage extends StatelessWidget {
  final List<CatsModel> favoriteCats;

  const FavoritesPage({Key? key, required this.favoriteCats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text('Избранные котики'),
        ),
        backgroundColor: Colors.pink.shade200,
        body: BlocBuilder<FavoritesCubit, List<CatsModel>>(
          builder: (context, state) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: state.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          state[index].imgUrls.first,
                          fit: BoxFit.cover,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          BlocProvider.of<FavoritesCubit>(context).removeFromFavorites(state[index]);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        )
    );
  }
}