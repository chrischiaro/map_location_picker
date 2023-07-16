import "package:google_maps_webapi/places.dart";
import 'package:http/http.dart';

import 'logger.dart';

enum SearchNearbyRankOption implements Comparable<SearchNearbyRankOption> {
  prominence(textValue: 'prominence'),
  distance(textValue: 'distance');

  const SearchNearbyRankOption({
    required this.textValue,
  });

  final String textValue;

  @override
  int compareTo(SearchNearbyRankOption option) =>
      textValue.compareTo(option.textValue);

  @override
  String toString() => textValue;
}

class PlacesNearbySearchState {
  /// apiHeader is used to add headers to the request.
  final Map<String, String>? apiHeaders;

  /// baseUrl is used to build the url for the request.
  final String? baseUrl;

  /// httpClient is used to make network requests.
  final Client? httpClient;

  /// The current state of the autocomplete.
  List<PlacesSearchResult> results = [];

  PlacesNearbySearchState({
    this.httpClient,
    this.apiHeaders,
    this.baseUrl,
  });

  /// void future function to get the autocomplete results.
  Future<List<PlacesSearchResult>> search({
    /// API key for Google Places API
    required String apiKey,

    /// final String input,
    required String query,

    /// language: 'en',
    String? language,

    /// Location bounds for restricting results to a radius around a location
    /// location: Location(lat: 37.6922400, lng: -97.3375400)
    Location? location,

    /// Language code for Places API results
    /// How to rank the results. Default is by 'distance'.
    SearchNearbyRankOption rankResultsBy = SearchNearbyRankOption.distance,

    /// Types for restricting results to a set of place types
    List<String> types = const [],
  }) async {
    if (types.length > 1) {
      throw ArgumentError(
          'When calling `search` with a `types` value for a Nearby Search, '
          'you can only include one type. This is because Google Map\'s Nearby Search API only '
          'accepts a single type, so only the first value would be used anyway.');
    }

    try {
      logger.d('apiKey = $apiKey');

      final places = GoogleMapsPlaces(
        apiKey: apiKey,
        httpClient: httpClient,
        apiHeaders: apiHeaders,
        baseUrl: baseUrl,
      );
      final PlacesSearchResponse response = await places.searchNearbyWithRankBy(
        location ?? Location(lat: 37.6922400, lng: -97.3375400),
        rankResultsBy.toString(),
        keyword: query,
        language: language,
        type: types.isNotEmpty ? types[0] : '',
      );

      /// When get any error from the API, show the error in the console.
      if (response.hasNoResults ||
          response.isDenied ||
          response.isInvalid ||
          response.isNotFound ||
          response.unknownError ||
          response.isOverQueryLimit) {
        if (query.isNotEmpty) {
          logger.e(response.errorMessage);
        }
        return [];
      }

      /// Update the results with the new results.
      results = response.results;

      logger.d(results.map((e) => e.toJson()).toList());

      /// Return the results.
      return results;
    } catch (err) {
      /// Log the error
      logger.e(err);
      return [];
    }
  }
}
