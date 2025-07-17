import 'package:flutter/material.dart';
import 'package:subsearch/player.dart';
import 'package:subsearch/search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final MaterialColor _seedColor = Colors.red;

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
      home: MainWrapper(currentPage: PlayerPage()),
    );
  }
}

class MainWrapper extends StatefulWidget {
  final Widget currentPage;

  const MainWrapper({super.key, required this.currentPage});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final List<Widget> _pages = [PlayerPage(), SearchPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: widget.currentPage,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: "Player",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        ],
        onTap: (index) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainWrapper(currentPage: _pages[index]),
            ),
          );
        },
      ),
    );
  }
}
