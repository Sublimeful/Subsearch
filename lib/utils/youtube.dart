import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Youtube {
  static final YoutubeExplode _explode = YoutubeExplode();

  static VideoSearchList? _searchResults;

  static Future<VideoSearchList> search(String query) async {
    VideoSearchList results = await _explode.search.search(query);
    _searchResults = results;
    return results;
  }

  static Future<VideoSearchList?> searchGetNext() async {
    if (_searchResults == null) return null;
    _searchResults = await _searchResults!.nextPage();
    return _searchResults;
  }
}
