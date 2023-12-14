import 'package:flutter/material.dart';
import 'package:lecture_1_app/api/api.dart';
import 'package:lecture_1_app/model/cat_model.dart';
import 'package:lecture_1_app/service/service.dart';
import 'package:lecture_1_app/storage/storage.dart';
import 'package:lecture_1_app/splash.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lecture_1_app/cubit/favorites_page.dart';
import 'package:lecture_1_app/cubit/favorites_cubit.dart';

void main() {
  final storage = Storage();
  final api = API();

  final service = Service(storage, api);

  runApp(
    BlocProvider(
      create: (context) => FavoritesCubit([]),
      child: MyApp(service),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AbstractService service;

  const MyApp(this.service, {Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SplashScreen(service),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final service = Service();
  Cat? cats;
  String? randomCat;

  late FavoritesCubit favoritesCubit;

  List<Cat> favoriteCats = [];

  @override
  void initState() {
    super.initState();
    favoritesCubit = BlocProvider.of<FavoritesCubit>(context);
    service.getCats().then((value) {
      cats = value;
      getRandomCat();
    });
  }

  void _navigateToFavorites(BuildContext context, List<Cat> cats) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesPage(favoriteCats: cats),
      ),
    );
  }

  void addToFavorites(Cat cat) {
    setState(() {
      favoriteCats.add(cat);
      favoritesCubit.addToFavorites(cat);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Котики'),
      ),
      backgroundColor: Colors.pink.shade200,
      body: Column(
        children: [
          Flexible(
            flex: 4,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(imageUrl: randomCat),
                  ),
                );
              },
              child: Hero(
                tag: 'imageHero',
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  elevation: 14,
                  child: SizedBox.square(
                    dimension: 300,
                    child: Builder(
                      builder: (context) {
                        if (randomCat == null) {
                          return Center(
                            child: CircularProgressIndicator(color: Colors.pink.shade200),
                          );
                        }

                        return Image.network(
                          randomCat!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(color: Colors.pink.shade200),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton.large(
                    onPressed: () {
                      getRandomCat();
                    },
                    backgroundColor: Colors.red,
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  FloatingActionButton.large(
                    onPressed: () {
                      getRandomCat();
                      if (randomCat != null) {
                        final cat = Cat(imgUrls: [randomCat!]);
                        addToFavorites(cat);
                      }
                    },
                    backgroundColor: Colors.green,
                    child: const Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                ),
                icon: const Icon(
                  Icons.favorite_outline,
                  size: 24,
                  color: Colors.white,
                ),
                label: const Text(
                  'Check favorites',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  if (randomCat != null) {
                    _navigateToFavorites(context, favoriteCats);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getRandomCat() {
    setState(() {
      cats!.imgUrls.shuffle();
      randomCat = cats!.imgUrls.first;
    });
  }
}

class DetailScreen extends StatelessWidget {
  final String? imageUrl;

  const DetailScreen({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'imageHero',
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).orientation == Orientation.landscape
                      ? MediaQuery.of(context).size.height
                      : null,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Возвращает на предыдущий экран
                },
                child: Text('Назад'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

