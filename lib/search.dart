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
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Column(
        children: [
          SearchBar(
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
          SearchResultUIList(query: query),
        ],
      ),
    );
  }
}
