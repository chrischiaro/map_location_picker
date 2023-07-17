import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart' hide ErrorBuilder;
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:http/http.dart';
import 'package:map_location_picker/src/searchnearby_service.dart';

import '../map_location_picker.dart';
import 'logger.dart';

ValueNotifier<T> useState<T>(T initialData) {
  return ValueNotifier<T>(initialData);
}

class PlacesSearchNearby extends StatelessWidget {
  /// The duration that [transitionBuilder] animation takes.
  ///
  /// This argument is best used with [transitionBuilder] and [animationStart]
  /// to fully control the animation.
  ///
  /// Defaults to 500 milliseconds.
  final Duration animationDuration;

  /// The value at which the [transitionBuilder] animation starts.
  ///
  /// This argument is best used with [transitionBuilder] and [animationDuration]
  /// to fully control the animation.
  ///
  /// Defaults to 0.25.
  final double animationStart;

  /// API key for the map & places
  final String apiKey;

  /// If set to true, in the case where the suggestions box has less than
  /// _SuggestionsBoxController.minOverlaySpace to grow in the desired [direction], the direction axis
  /// will be temporarily flipped if there's more room available in the opposite
  /// direction.
  ///
  /// Defaults to false
  final bool autoFlipDirection;

  /// Auto-validate mode for the text field
  final AutovalidateMode autovalidateMode;

  /// Top card text field border radius
  final BorderRadius? borderRadius;

  /// Back button replacement when [showBackButton] is false and [backButton] is not null
  final Widget? backButton;

  /// Components set results to be restricted to a specific area
  /// components: [Component(Component.country, "us")]
  final List<Component> components;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// The duration to wait after the user stops typing before calling
  /// [suggestionsCallback]
  ///
  /// This is useful, because, if not set, a request for suggestions will be
  /// sent for every character that the user types.
  ///
  /// This duration is set by default to 300 milliseconds
  final Duration debounceDuration;

  /// Input decoration for the text field
  final InputDecoration? decoration;

  /// Determine the [SuggestionBox]'s direction.
  ///
  /// If [AxisDirection.down], the [SuggestionBox] will be below the [TextField]
  /// and the [_SuggestionsList] will grow **down**.
  ///
  /// If [AxisDirection.up], the [SuggestionBox] will be above the [TextField]
  /// and the [_SuggestionsList] will grow **up**.
  ///
  /// [AxisDirection.left] and [AxisDirection.right] are not allowed.
  final AxisDirection direction;

  /// Text input enabler
  final bool enabled;

  /// Called when [suggestionsCallback] throws an exception.
  ///
  /// It is called with the error object, and expected to return a widget to
  /// display when an exception is thrown
  /// For example:
  /// ```dart
  /// (BuildContext context, error) {
  ///   return Text('$error');
  /// }
  /// ```
  ///
  /// If not specified, the error is shown in [ThemeData.errorColor](https://docs.flutter.io/flutter/material/ThemeData/errorColor.html)
  final Widget Function(BuildContext, Object?)? errorBuilder;

  /// fields
  final List<String> fields;

  /// Focus node for the text field
  final FocusNode? focusNode;

  /// If set to true, suggestions will be fetched immediately when the field is
  /// added to the view.
  ///
  /// But the suggestions box will only be shown when the field receives focus.
  /// To make the field receive focus immediately, you can set the `autofocus`
  /// property in the [textFieldConfiguration] to true
  ///
  /// Defaults to false
  final bool getImmediateSuggestions;

  /// Hide the keyboard when a suggestion is selected
  final bool hideKeyboard;

  /// If set to true, no loading box will be shown while suggestions are
  /// being fetched. [loadingBuilder] will also be ignored.
  ///
  /// Defaults to false.
  final bool hideOnLoading;

  /// If set to true, nothing will be shown if there are no results.
  /// [noItemsFoundBuilder] will also be ignored.
  ///
  /// Defaults to false.
  final bool hideOnEmpty;

  /// If set to true, nothing will be shown if there is an error.
  /// [errorBuilder] will also be ignored.
  ///
  /// Defaults to false.
  final bool hideOnError;

  /// If set to false, the suggestions box will stay opened after
  /// the keyboard is closed.
  ///
  /// Defaults to true.
  final bool hideSuggestionsOnKeyboardHide;

  /// Initial value for search text field (optional)
  /// [initialValue] not in use when [searchController] is not null.
  final PlacesSearchResult? initialValue;

  /// Called for each suggestion returned by [suggestionsCallback] to build the
  /// corresponding widget.
  ///
  /// This callback must not be null. It is called by the TypeAhead widget for
  /// each suggestion, and expected to build a widget to display this
  /// suggestion's info. For example:
  ///
  /// ```dart
  /// itemBuilder: (context, suggestion) {
  ///   return ListTile(
  ///     title: Text(suggestion['name']),
  ///     subtitle: Text('USD' + suggestion['price'].toString())
  ///   );
  /// }
  /// ```
  final Widget Function(BuildContext, PlacesSearchResult)? itemBuilder;

  /// If set to false, the suggestions box will show a circular
  /// progress indicator when retrieving suggestions.
  ///
  /// Defaults to true.
  final bool keepSuggestionsOnLoading;

  /// If set to true, the suggestions box will remain opened even after
  /// selecting a suggestion.
  ///
  /// Note that if this is enabled, the only way
  /// to close the suggestions box is either manually via the
  /// `SuggestionsBoxController` or when the user closes the software
  /// keyboard if `hideSuggestionsOnKeyboardHide` is set to true. Users
  /// with a physical keyboard will be unable to close the
  /// box without a manual way via `SuggestionsBoxController`.
  ///
  /// Defaults to false.
  final bool keepSuggestionsOnSuggestionSelected;

  /// Language code for Places API results
  /// language: 'en',
  final String? language;

  /// Called when waiting for [suggestionsCallback] to return.
  ///
  /// It is expected to return a widget to display while waiting.
  /// For example:
  /// ```dart
  /// (BuildContext context) {
  ///   return Text('Loading...');
  /// }
  /// ```
  ///
  /// If not specified, a [CircularProgressIndicator](https://docs.flutter.io/flutter/material/CircularProgressIndicator-class.html) is shown
  final WidgetBuilder? loadingBuilder;

  /// Location bounds for restricting results to a radius around a location
  /// location: Location(lat: -33.867, lng: 151.195)
  final Location? location;

  /// Is widget mounted
  final bool mounted;

  /// Called when [suggestionsCallback] returns an empty array.
  ///
  /// It is expected to return a widget to display when no suggestions are
  /// available.
  /// For example:
  /// ```dart
  /// (BuildContext context) {
  ///   return Text('No Items Found!');
  /// }
  /// ```
  ///
  /// If not specified, a simple text is shown
  final WidgetBuilder? noItemsFoundBuilder;

  /// on change callback
  final void Function(PlacesSearchResult?)? onChanged;

  /// On get details callback
  final void Function(PlacesDetailsResponse?)? onGetDetailsByPlaceId;

  /// on reset callback
  final void Function()? onReset;

  /// on form save callback
  final void Function(PlacesSearchResult?)? onSaved;

  /// On suggestion selected callback
  final void Function(PlacesSearchResult)? onSuggestionSelected;

  /// apiHeader is used to add headers to the request.
  final Map<String, String>? placesApiHeaders;

  /// baseUrl is used to build the url for the request.
  final String? placesBaseUrl;

  /// httpClient is used to make network requests.
  final Client? placesHttpClient;

  /// String value for restricting results to a set of regions
  /// e.g., region: "us"
  final String? region;

  /// The suggestions box controller
  final ScrollController? scrollController;

  /// Search text field controller
  ///
  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? searchController;

  /// Top card text field hint text
  final String searchHintText;

  /// Session token for Google Places API
  final String? sessionToken;

  /// Show back button (default: true)
  final bool showBackButton;

  /// Can show clear button on search text field
  final bool showClearButton;

  /// suffix icon for search text field. You can use [showClearButton] to show clear button or replace with suffix icon
  final Widget? suffixIcon;

  /// Used to control the `_SuggestionsBox`. Allows manual control to
  /// open, close, toggle, or resize the `_SuggestionsBox`.
  final SuggestionsBoxController? suggestionsBoxController;

  /// The decoration of the material sheet that contains the suggestions.
  /// If null, default decoration with an elevation of 4.0 is used
  final SuggestionsBoxDecoration suggestionsBoxDecoration;

  /// How far below the text field should the suggestions box be
  ///
  /// Defaults to 5.0
  final double suggestionsBoxVerticalOffset;

  /// The configuration of the [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
  /// that the TypeAhead widget displays
  final TextFieldConfiguration textFieldConfiguration;

  /// Top card color
  final Color? topCardColor;

  /// Top card margin
  final EdgeInsetsGeometry topCardMargin;

  /// Top card shape
  final ShapeBorder topCardShape;

  /// Called to display animations when [suggestionsCallback] returns suggestions
  ///
  /// It is provided with the suggestions box instance and the animation
  /// controller, and expected to return some animation that uses the controller
  /// to display the suggestion box.
  ///
  /// For example:
  /// ```dart
  /// transitionBuilder: (context, suggestionsBox, animationController) {
  ///   return FadeTransition(
  ///     child: suggestionsBox,
  ///     opacity: CurvedAnimation(
  ///       parent: animationController,
  ///       curve: Curves.fastOutSlowIn
  ///     ),
  ///   );
  /// }
  /// ```
  /// This argument is best used with [animationDuration] and [animationStart]
  /// to fully control the animation.
  ///
  /// To fully remove the animation, just return `suggestionsBox`
  ///
  /// If not specified, a [SizeTransition](https://docs.flutter.io/flutter/widgets/SizeTransition-class.html) is shown.
  final AnimationTransitionBuilder? transitionBuilder;

  /// Types for restricting results to a set of place types
  final List<String> types;

  /// Validator for search text field (optional)
  final String? Function(PlacesSearchResult?)? validator;

  /// value transformer
  final dynamic Function(PlacesSearchResult?)? valueTransformer;

  const PlacesSearchNearby({
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationStart = 0.25,
    required this.apiKey,
    this.autoFlipDirection = false,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.backButton,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.components = const [],
    this.controller,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.decoration,
    this.direction = AxisDirection.down,
    this.enabled = true,
    this.errorBuilder,
    this.fields = const [],
    this.focusNode,
    this.getImmediateSuggestions = false,
    this.hideKeyboard = false,
    this.hideOnEmpty = false,
    this.hideOnError = false,
    this.hideOnLoading = false,
    this.hideSuggestionsOnKeyboardHide = false,
    this.initialValue,
    this.itemBuilder,
    this.keepSuggestionsOnLoading = true,
    this.keepSuggestionsOnSuggestionSelected = false,
    Key? key,
    this.language,
    this.location,
    this.loadingBuilder,
    this.mounted = true,
    this.noItemsFoundBuilder,
    this.onChanged,
    this.onGetDetailsByPlaceId,
    this.onReset,
    this.onSaved,
    this.onSuggestionSelected,
    this.placesHttpClient,
    this.placesApiHeaders,
    this.placesBaseUrl,
    this.region,
    this.scrollController,
    this.searchHintText = "Start typing to search",
    this.searchController,
    this.sessionToken,
    this.showBackButton = true,
    this.showClearButton = true,
    this.suggestionsBoxController,
    this.suggestionsBoxDecoration = const SuggestionsBoxDecoration(),
    this.suggestionsBoxVerticalOffset = 5.0,
    this.suffixIcon,
    this.textFieldConfiguration = const TextFieldConfiguration(),
    this.topCardMargin = const EdgeInsets.all(8),
    this.topCardColor,
    this.topCardShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    this.transitionBuilder,
    this.types = const [],
    this.validator,
    this.valueTransformer,
  }) : super(key: key);

  /// Get [PlacesNearbySearchState] for [PlacesSearchTextField]
  PlacesNearbySearchState searchState() {
    return PlacesNearbySearchState(
      apiHeaders: placesApiHeaders,
      baseUrl: placesBaseUrl,
      httpClient: placesHttpClient,
    );
  }

  @override
  Widget build(BuildContext context) {
    // logger.d('Prior to build() call, apiKey = $apiKey');

    /// Get text controller from [searchController] or create new instance of [TextEditingController] if [searchController] is null or empty
    final textController = useState<TextEditingController>(
        searchController ?? TextEditingController());
    return SafeArea(
      child: Card(
        margin: topCardMargin,
        shape: topCardShape,
        color: topCardColor,
        child: ListTile(
          minVerticalPadding: 0,
          contentPadding: const EdgeInsets.only(right: 4, left: 4),
          leading: showBackButton ? const BackButton() : backButton,
          title: ClipRRect(
            borderRadius: borderRadius,
            child: FormBuilderTypeAhead<PlacesSearchResult>(
              animationDuration: animationDuration,
              animationStart: animationStart,
              autoFlipDirection: autoFlipDirection,
              autovalidateMode: autovalidateMode,
              controller: initialValue == null ? textController.value : null,
              debounceDuration: debounceDuration,
              direction: direction,
              decoration: decoration ??
                  InputDecoration(
                    hintText: searchHintText,
                    border: InputBorder.none,
                    filled: true,
                    suffixIcon: (showClearButton && initialValue == null)
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => textController.value.clear(),
                          )
                        : suffixIcon,
                  ),
              enabled: enabled,
              errorBuilder: errorBuilder,
              focusNode: focusNode,
              getImmediateSuggestions: getImmediateSuggestions,
              hideKeyboard: hideKeyboard,
              hideOnEmpty: hideOnEmpty,
              hideOnError: hideOnError,
              hideOnLoading: hideOnLoading,
              hideSuggestionsOnKeyboardHide: hideSuggestionsOnKeyboardHide,
              initialValue: initialValue,
              itemBuilder: itemBuilder ??
                  (context, content) {
                    return ListTile(
                      title: Text(content.name),
                      subtitle: Text(
                        '${content.vicinity}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  },
              keepSuggestionsOnLoading: keepSuggestionsOnLoading,
              keepSuggestionsOnSuggestionSelected:
                  keepSuggestionsOnSuggestionSelected,
              key: key,
              loadingBuilder: loadingBuilder,
              name: 'Search',
              noItemsFoundBuilder: noItemsFoundBuilder,
              onChanged: onChanged,
              onReset: onReset,
              onSaved: onSaved,
              onSuggestionSelected: (value) async {
                textController.value.selection = TextSelection.collapsed(
                    offset: textController.value.text.length);
                _getDetailsByPlaceId(value.placeId, context);
                onSuggestionSelected?.call(value);
              },
              scrollController: scrollController,
              selectionToTextTransformer: (result) {
                return result.name;
              },
              suggestionsBoxController: suggestionsBoxController,
              suggestionsBoxDecoration: suggestionsBoxDecoration,
              suggestionsBoxVerticalOffset: suggestionsBoxVerticalOffset,
              suggestionsCallback: (query) async {
                List<PlacesSearchResult> searchResults =
                    await searchState().search(
                  apiKey: apiKey,
                  query: query,
                  language: language,
                  location: location,
                  types: types,
                );
                return searchResults;
              },
              textFieldConfiguration: textFieldConfiguration,
              transitionBuilder: transitionBuilder,
              validator: validator,
              valueTransformer: valueTransformer,
            ),
          ),
        ),
      ),
    );
  }

  /// Get address details from place id
  void _getDetailsByPlaceId(String placeId, BuildContext context) async {
    try {
      final GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: apiKey,
        httpClient: placesHttpClient,
        apiHeaders: placesApiHeaders,
        baseUrl: placesBaseUrl,
      );
      final PlacesDetailsResponse response = await places.getDetailsByPlaceId(
        placeId,
        region: region,
        sessionToken: sessionToken,
        language: language,
        fields: fields,
      );

      /// When get any error from the API, show the error in the console.
      if (response.hasNoResults ||
          response.isDenied ||
          response.isInvalid ||
          response.isNotFound ||
          response.unknownError ||
          response.isOverQueryLimit) {
        logger.e(response.errorMessage);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.errorMessage ??
                  "Address not found, something went wrong!"),
            ),
          );
        }
        return;
      }
      onGetDetailsByPlaceId?.call(response);
    } catch (e) {
      logger.e(e);
    }
  }
}
