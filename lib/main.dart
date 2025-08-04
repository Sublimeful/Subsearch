import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsearch/main_state.dart';
import 'package:subsearch/player.dart';
import 'package:subsearch/player_state.dart';
import 'package:subsearch/search.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainState()),
        ChangeNotifierProvider(create: (context) => PlayerPageState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final MaterialColor _seedColor = Colors.blueGrey;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
        searchBarTheme: SearchBarThemeData(
          backgroundColor: WidgetStateProperty.all(_seedColor[100]),
          textStyle: WidgetStateProperty.all(TextStyle(color: _seedColor[800])),
          hintStyle: WidgetStateProperty.all(TextStyle(color: _seedColor[300])),
        ),
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(_seedColor[300]),
        ),
      ),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final List<Widget> _pages = [
    PlayerPage(key: UniqueKey()), // UniqueKey preserves state
    SearchPage(key: UniqueKey()),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainState>(
      builder: (context, state, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          body: SafeArea(
            child: IndexedStack(index: state.pageIndex, children: _pages),
          ),
          bottomNavigationBar: state.navigationBarVisible
              ? BottomNavigationBar(
                  currentIndex: state.pageIndex,
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.play_arrow),
                      label: "Player",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search),
                      label: "Search",
                    ),
                  ],
                  onTap: (index) {
                    state.updatePageIndex(index);
                  },
                )
              : null,
        );
      },
    );
  }
}
