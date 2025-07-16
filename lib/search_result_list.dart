import 'package:cached_network_image/cached_network_image.dart';
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

    return Column(
      children: [
        Expanded(
          flex: 12,
          child: ListView.builder(
            itemCount: children.length,
            itemBuilder: (BuildContext context, int index) {
              return children[index];
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _currentIndex == 0
                    ? null
                    : () {
                        setState(() {
                          _currentIndex -= 1;
                        });
                      },
                child: Text("Previous"),
              ),
              ElevatedButton(
                onPressed: _currentIndex == _searchResults.length - 1
                    ? null
                    : () {
                        _currentIndex += 1;
                        if (_currentIndex == _searchResults.length - 1) {
                          _prefetchNextResults();
                        }
                        setState(() {});
                      },
                child: Text("Next"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _prefetchNextResults() {
    Youtube.searchGetNext().then((nextResults) {
      if (nextResults == null) return;
      setState(() {
        _searchResults.add(nextResults);
      });
    });
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
      // Prefetch next results
      _prefetchNextResults();
    });
  }

  List<SearchResultUI> _getCurrentResultsChildren() {
    if (_searchResults.isEmpty) return [];
    return _searchResults[_currentIndex]
        .map((result) => SearchResultUI(result: result))
        .toList();
  }
}
