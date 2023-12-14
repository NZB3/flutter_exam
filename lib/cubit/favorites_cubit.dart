import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lecture_1_app/model/cat_model.dart';


enum FavoritesEvent { addToFavorites, removeFromFavorites }

class FavoritesCubit extends Cubit<List<CatsModel>> {
  FavoritesCubit(List<CatsModel> initialState) : super(initialState);

  void addToFavorites(CatsModel cat) {
    state.add(cat);
    emit(List.from(state));
  }

  void removeFromFavorites(CatsModel cat) {
    emit(List.from(state)..remove(cat));
  }
}