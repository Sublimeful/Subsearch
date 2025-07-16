import 'package:flutter/material.dart';
import 'package:subsearch/search_result_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SearchBar(
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
            leading: Icon(Icons.search),
            onSubmitted: (query) {
              setState(() {
                this.query = query;
              });
            },
          ),
        ),
        Expanded(child: SearchResultUIList(query: query)),
      ],
    );
  }
}
