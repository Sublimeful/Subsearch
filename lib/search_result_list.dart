import 'package:flutter/material.dart';
import 'package:subsearch/search_result.dart';
import 'package:subsearch/utils/youtube.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchResultUIList extends StatefulWidget {
  final String query;

  const SearchResultUIList({super.key, required this.query});

  @override
  State<SearchResultUIList> createState() => _SearchResultUIListState();
}

class _SearchResultUIListState extends State<SearchResultUIList> {
  final List<VideoSearchList> _searchResults = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SearchResultUIList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.query != widget.query) {
      _performSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<SearchResultUI> children = _getCurrentResultsChildren();
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }
    return Expanded(
      child: ListView.builder(
        itemCount: children.length,
        itemBuilder: (BuildContext context, int index) {
          return children[index];
        },
      ),
    );
  }

  void _performSearch() {
    // Reset everything
    _currentIndex = 0;
    _searchResults.clear();
    // Don't do squat if query is empty
    if (widget.query == "") {
      return;
    }
    // Add initial search results
    Youtube.search(widget.query).then((initialResults) {
      setState(() {
        _searchResults.add(initialResults);
      });
    });
  }

  List<SearchResultUI> _getCurrentResultsChildren() {
    if (_searchResults.isEmpty) return [];
    return _searchResults[_currentIndex]
        .map((result) => SearchResultUI(result: result))
        .toList();
  }
}
