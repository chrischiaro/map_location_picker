import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:google_maps_webapi/geocoding.dart";
import 'package:google_maps_webapi/places.dart';
import 'package:http/http.dart';
import 'package:map_location_picker/src/searchnearby_view.dart';

import 'autocomplete_view.dart';
import 'logger.dart';

enum PlacesSearchType {
  autoComplete,
  nearby,
}

class MapLocationPicker extends StatefulWidget {
  /// Add your own custom markers
  final Map<String, LatLng>? additionalMarkers;

  /// API key for the map & places
  final String apiKey;

  /// TextDecoration object for the Search Autocomplete field
  final InputDecoration? autocompleteTextboxDecoration;

  /// Back button replacement when [showBackButton] is false and [backButton] is not null
  final Widget? backButton;

  /// Top card text field border radius
  final BorderRadius? borderRadius;

  /// Color of the "Tap to show more results" button that shows on the bottom-card chip.
  /// The chip is a component of the bottom card.
  final Color? bottomCardChipButtonColor;

  /// How much elevation to show for the "Tap to show more results" button that shows on the bottom-card chip.
  /// The chip is a component of the bottom card.
  final double? bottomCardChipButtonElevation;

  /// Padding around the text in the "Tap to show more results" chip.
  /// The chip is a component of the bottom card.
  final EdgeInsetsGeometry? bottomCardChipButtonLabelPadding;

  /// TextStyle for the "Tap to show more results" text in the chip.
  /// The chip is a component of the bottom card.
  final TextStyle? bottomCardChipButtonLabelStyle;

  /// Color of the shadow under the "Tap to show more results" button that shows on the bottom-card chip.
  /// The chip is a component of the bottom card.
  final Color? bottomCardChipButtonShadowColor;

  /// OutlinedBorder for the "Tap to show more results" button that shows on the bottom-card chip.
  /// The chip is a component of the bottom card.
  final OutlinedBorder? bottomCardChipButtonShape;

  /// SurfaceTintColor for the "Tap to show more results" button that shows on the bottom-card chip.
  /// The chip is a component of the bottom card.
  final Color? bottomCardChipButtonSurfaceTintColor;

  /// Color property for the Card widget that makes the bottom card.
  /// Doesn't seem to affect the look of the card. Use the bottomCardTileColor property instead.
  /// The bottom card tile shows the address of the place that has been clicked on the map.
  final Color? bottomCardColor;

  /// The icon that displays trailing the text in the bottom card tile.
  /// The bottom card tile shows the address of the place that has been clicked on the map.
  final Icon bottomCardIcon;

  /// Bottom card margin.
  /// The bottom card tile shows the address of the place that has been clicked on the map.
  final EdgeInsetsGeometry bottomCardMargin;

  /// BorderShape for the bottom card.
  /// The bottom card tile shows the address of the place that has been clicked on the map.
  final ShapeBorder bottomCardShape;

  /// Color for the tile in the bottom card.
  /// The bottom card tile shows the address of the place that has been clicked on the map.
  final Color? bottomCardTileColor;

  /// Content padding for the tile in the bottom card.
  /// The bottom card tile shows the address of the place that has been clicked on the map.
  final EdgeInsetsGeometry? bottomCardTileContentPadding;

  /// Title text alignment for the tile in the bottom card.
  /// The bottom card tile shows the address of the place that has been clicked on the map.
  final ListTileTitleAlignment? bottomCardTileTitleAlignment;

  /// Bottom card tooltip.
  /// The bottom card tile shows the address of the place that has been clicked on the map.
  final String bottomCardTooltip;

  /// ShapeBorder to apply to the tile in the bottom card.
  /// The bottom card tile shows the address of the place that has been clicked on the map.
  final ShapeBorder? bottomCardTileShape;

  /// Text style to apply to the subtitle text (second row of text) in the bottom-card tile.
  /// The bottom card tile shows the address of the place that has been clicked on the map.
  final TextStyle? bottomCardTileSubtitleTextStyle;

  /// Color of the text in the bottom-card tile.
  /// The bottom card tile shows the address of the place that has been clicked on the map.
  final Color? bottomCardTileTextColor;

  /// Text style to apply to the text in the bottom-card tile.
  /// The bottom card tile shows the address of the place that has been clicked on the map.
  final TextStyle? bottomCardTileTitleTextStyle;

  /// Compass for the map (default: true)
  final bool compassEnabled;

  /// Popup route on next press (default: false)
  final bool canPopOnNextButtonTaped;

  /// Components set results to be restricted to a specific area
  /// components: [Component(Component.country, "us")]
  final List<Component> components;

  /// currentLatLng init location for camera position
  /// currentLatLng: Location(lat: 37.6922400, lng: -97.3375400),
  final LatLng? currentLatLng;

  /// GPS accuracy for the map
  final LocationAccuracy desiredAccuracy;

  /// Dialog title
  final String dialogTitle;

  /// List of fields to be returned by the Google Maps Places API.
  /// Refer to the Google Documentation here for a list of valid values: https://developers.google.com/maps/documentation/places/web-service/details
  final List<String> fields;

  /// GeoCoding api headers
  final Map<String, String>? geoCodingApiHeaders;

  /// GeoCoding base url
  final String? geoCodingBaseUrl;

  /// GeoCoding http client
  final Client? geoCodingHttpClient;

  /// Hide Suggestions on keyboard hide
  final bool hideSuggestionsOnKeyboardHide;

  /// Language code for Places API results
  /// language: 'en',
  final String? language;

  /// Lite mode for the map (default: false)
  final bool liteModeEnabled;

  /// Location bounds for restricting results to a radius around a location
  /// location: Location(lat: -33.867, lng: 151.195)
  final Location? location;

  /// GeoCoding location type
  final List<String> locationType;

  /// Map type (default: MapType.normal)
  final MapType mapType;

  /// Map minimum zoom level & maximum zoom level
  final MinMaxZoomPreference minMaxZoomPreference;

  /// Offset for pagination of results
  /// offset: int,
  final num? offset;

  /// On Next Page callback
  final Function(GeocodingResult?) onNext;

  /// On Suggestion Selected callback
  final Function(PlacesDetailsResponse?)? onSuggestionSelected;

  /// Origin location for calculating distance from results
  /// origin: Location(lat: -33.852, lng: 151.211),
  final Location? origin;

  /// Padding around the map
  final EdgeInsets padding;

  /// apiHeader is used to add headers to the request.
  final Map<String, String>? placesApiHeaders;

  /// baseUrl is used to build the url for the request.
  final String? placesBaseUrl;

  /// httpClient is used to make network requests.
  final Client? placesHttpClient;

  /// PlacesSearchType enum indicates whether to show use
  /// an Autocomplete search box, or a Nearby Search
  final PlacesSearchType placesSearchType;

  /// Radius for restricting results to a radius around a location
  /// radius: Radius in meters
  final num? radius;

  /// Region for restricting results to a set of regions
  /// region: "us"
  final String? region;

  /// GeoCoding result type
  final List<String> resultType;

  /// Search text field controller
  final TextEditingController? searchController;

  /// Top card text field hint text
  final String searchHintText;

  /// Session token for Google Places API
  final String? sessionToken;

  /// Show back button (default: true)
  final bool showBackButton;

  /// Show more suggestions
  final bool showMoreOptions;

  /// Bounds for restricting results to a set of bounds
  final bool strictbounds;

  /// Top card color
  final Color? topCardColor;

  /// Top card margin
  final EdgeInsetsGeometry topCardMargin;

  /// Top card shape
  final ShapeBorder topCardShape;

  /// Types for restricting results to a set of place types
  final List<String> types;

  const MapLocationPicker({
    required this.apiKey,
    this.additionalMarkers,
    this.autocompleteTextboxDecoration,
    this.backButton,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.bottomCardChipButtonColor,
    this.bottomCardChipButtonElevation,
    this.bottomCardChipButtonLabelPadding,
    this.bottomCardChipButtonLabelStyle,
    this.bottomCardChipButtonShadowColor,
    this.bottomCardChipButtonShape,
    this.bottomCardChipButtonSurfaceTintColor,
    this.bottomCardColor,
    this.bottomCardIcon = const Icon(Icons.send),
    this.bottomCardMargin = const EdgeInsets.fromLTRB(8, 8, 8, 16),
    this.bottomCardShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    this.bottomCardTileColor,
    this.bottomCardTileContentPadding,
    this.bottomCardTileShape,
    this.bottomCardTileTextColor,
    this.bottomCardTileTitleAlignment,
    this.bottomCardTileTitleTextStyle,
    this.bottomCardTileSubtitleTextStyle,
    this.bottomCardTooltip = "Continue with this location",
    this.canPopOnNextButtonTaped = false,
    this.compassEnabled = true,
    this.components = const [],
    this.currentLatLng = const LatLng(37.6922400, -97.3375400),
    this.desiredAccuracy = LocationAccuracy.high,
    this.dialogTitle = 'You can also use the following options',
    this.fields = const [],
    this.geoCodingApiHeaders,
    this.geoCodingBaseUrl,
    this.geoCodingHttpClient,
    this.hideSuggestionsOnKeyboardHide = false,
    Key? key,
    this.language,
    this.liteModeEnabled = false,
    this.location,
    this.locationType = const [],
    this.mapType = MapType.normal,
    this.minMaxZoomPreference = const MinMaxZoomPreference(10, 20),
    this.offset,
    required this.onNext,
    this.onSuggestionSelected,
    this.origin,
    this.padding = const EdgeInsets.all(0),
    this.placesApiHeaders,
    this.placesBaseUrl,
    this.placesHttpClient,
    this.placesSearchType = PlacesSearchType.autoComplete,
    this.radius,
    this.region,
    this.resultType = const [],
    this.searchController,
    this.searchHintText = "Start typing to search",
    this.sessionToken,
    this.showBackButton = true,
    this.showMoreOptions = true,
    this.strictbounds = false,
    this.topCardColor,
    this.topCardMargin = const EdgeInsets.all(8),
    this.topCardShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    this.types = const [],
  }) : super(key: key);

  @override
  State<MapLocationPicker> createState() => _MapLocationPickerState();
}

class AddressDisplayInfo {
  AddressDisplayInfo({
    this.name,
    this.formattedAddress,
    this.addressParts,
  });

  final String? name;
  final String? formattedAddress;
  List<AddressComponent>? addressParts;
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  /// Map controller for movement & zoom
  final Completer<GoogleMapController> _controller = Completer();

  /// initial latitude & longitude
  late LatLng _initialPosition = const LatLng(37.6922400, -97.3375400);

  /// initial address text
  late AddressDisplayInfo _address =
      AddressDisplayInfo(name: 'Tap on map to get address');

  /// Map type (default: MapType.normal)
  late MapType _mapType = MapType.normal;

  /// initial zoom level
  late double _zoom = 18.0;

  /// GeoCoding result for further use
  GeocodingResult? _geocodingResult;

  /// GeoCoding results list for further use
  late List<GeocodingResult> _geocodingResultList = [];

  /// Search text field controller
  late TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final additionalMarkers = widget.additionalMarkers?.entries
            .map(
              (e) => Marker(
                markerId: MarkerId(e.key),
                position: e.value,
              ),
            )
            .toList() ??
        [];

    final markers = Set<Marker>.from(additionalMarkers);

    markers.add(Marker(
      markerId: const MarkerId("one"),
      position: _initialPosition,
    ));

    // logger.d('PlacesSearchType = ${widget.placesSearchType}');

    return Scaffold(
      body: Stack(
        children: [
          /// Google map view
          GoogleMap(
            minMaxZoomPreference: widget.minMaxZoomPreference,
            onCameraMove: (CameraPosition position) {
              /// set zoom level
              _zoom = position.zoom;
            },
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: _zoom,
            ),
            onTap: (LatLng position) async {
              _initialPosition = position;
              final controller = await _controller.future;
              controller.animateCamera(
                  CameraUpdate.newCameraPosition(cameraPosition()));
              _decodeAddress(
                  Location(lat: position.latitude, lng: position.longitude));
              setState(() {});
            },
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);
            },
            markers: {
              Marker(
                markerId: const MarkerId('one'),
                position: _initialPosition,
              ),
            },
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            padding: widget.padding,
            compassEnabled: widget.compassEnabled,
            liteModeEnabled: widget.liteModeEnabled,
            mapType: widget.mapType,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              widget.placesSearchType == PlacesSearchType.autoComplete
                  ? buildPlacesAutocomplete()
                  : buildPlacesNearbySearch(),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(360),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(4.5),
                    child: PopupMenuButton(
                      tooltip: 'Map Type',
                      initialValue: _mapType,
                      icon: Icon(
                        Icons.layers,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      onSelected: (MapType mapType) {
                        setState(() {
                          _mapType = mapType;
                        });
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: MapType.normal,
                          child: Text('Normal'),
                        ),
                        PopupMenuItem(
                          value: MapType.hybrid,
                          child: Text('Hybrid'),
                        ),
                        PopupMenuItem(
                          value: MapType.satellite,
                          child: Text('Satellite'),
                        ),
                        PopupMenuItem(
                          value: MapType.terrain,
                          child: Text('Terrain'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  tooltip: 'My Location',
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  onPressed: () async {
                    await Geolocator.requestPermission();
                    Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: widget.desiredAccuracy,
                    );
                    LatLng latLng =
                        LatLng(position.latitude, position.longitude);
                    _initialPosition = latLng;
                    final controller = await _controller.future;
                    controller.animateCamera(
                        CameraUpdate.newCameraPosition(cameraPosition()));
                    _decodeAddress(Location(
                        lat: position.latitude, lng: position.longitude));
                    setState(() {});
                  },
                  child: const Icon(Icons.my_location),
                ),
              ),
              Card(
                margin: widget.bottomCardMargin,
                shape: widget.bottomCardShape,
                color: widget.bottomCardColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      contentPadding: widget.bottomCardTileContentPadding,
                      shape: widget.bottomCardTileShape,
                      subtitle: _address.name != null
                          ? Text(_address.formattedAddress ?? '')
                          : null,
                      subtitleTextStyle: widget.bottomCardTileSubtitleTextStyle,
                      textColor: widget.bottomCardTileTextColor,
                      tileColor: widget.bottomCardTileColor,
                      title: Text(_address.name ??
                          _format2Lines(_address.addressParts ?? [])),
                      titleAlignment: widget.bottomCardTileTitleAlignment,
                      titleTextStyle: widget.bottomCardTileTitleTextStyle,
                      trailing: IconButton(
                        tooltip: widget.bottomCardTooltip,
                        icon: widget.bottomCardIcon,
                        onPressed: () async {
                          logger.d(
                              'onPressed fired;\nformattedAddress: ${_geocodingResult?.formattedAddress}\n'
                              'addressComponents: ${_geocodingResult?.addressComponents.map((e) => e.longName)}\n'
                              'postcodeLocalities: ${_geocodingResult?.postcodeLocalities}\n');
                          widget.onNext.call(_geocodingResult);
                          if (widget.canPopOnNextButtonTaped) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    if (widget.showMoreOptions &&
                        _geocodingResultList.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(widget.dialogTitle),
                              scrollable: true,
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: _geocodingResultList.map((element) {
                                  return ListTile(
                                    title: Text(element.formattedAddress ?? ""),
                                    onTap: () {
                                      _address = AddressDisplayInfo(
                                        formattedAddress:
                                            element.formattedAddress ?? '',
                                        addressParts: element.addressComponents,
                                      );
                                      _geocodingResult = element;
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                  );
                                }).toList(),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: Chip(
                          label: Text(
                            "Tap to show ${(_geocodingResultList.length - 1)} more result options",
                          ),
                          labelPadding: widget.bottomCardChipButtonLabelPadding,
                          labelStyle: widget.bottomCardChipButtonLabelStyle,
                          shape: widget.bottomCardChipButtonShape,
                          elevation: widget.bottomCardChipButtonElevation,
                          backgroundColor: widget.bottomCardChipButtonColor,
                          shadowColor: widget.bottomCardChipButtonShadowColor,
                          surfaceTintColor:
                              widget.bottomCardChipButtonSurfaceTintColor,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _format2Lines(List<AddressComponent> addressParts) {
    if (addressParts.isNotEmpty) {
      final String s1 =
          addressParts[0].longName.length + addressParts[1].longName.length > 20
              ? '${addressParts[0].longName} ${addressParts[1].shortName}\n'
              : '${addressParts[0].longName} ${addressParts[1].longName}\n';
      final String s2 =
          addressParts[2].longName.length + addressParts[3].longName.length > 20
              ? '${addressParts[2].longName}, ${addressParts[3].shortName}'
              : '${addressParts[2].longName}, ${addressParts[3].longName}';

      if ((addressParts[0].longName.length + addressParts[1].longName.length >
              20) ||
          (addressParts[2].longName.length + addressParts[3].longName.length >
              20)) {
        String debug1 = '# address parts: ${addressParts.length}\n'
            's1 test len: ${addressParts[0].longName.length + addressParts[1].longName.length}\n'
            's2 test len: ${addressParts[2].longName.length + addressParts[3].longName.length}\n';

        List<String> debug2;
        int i = 0;
        debug2 = addressParts
            .map((e) => '${i++}:L/S: ${e.longName} / ${e.shortName}')
            .toList();

        logger.d(debug1 + debug2.join('\n'));
      }
      return s1 + s2;
    }
    return '';
  }

  PlacesAutocomplete buildPlacesAutocomplete() {
    logger.d('Inside `buildPlacesAutocomplete`: '
        'ApiHeaders: ${widget.placesApiHeaders} \n'
        'BaseUrl: ${widget.placesBaseUrl} \n'
        'HttpClient: ${widget.placesHttpClient.toString()}');

    return PlacesAutocomplete(
      apiKey: widget.apiKey,
      backButton: widget.backButton,
      borderRadius: widget.borderRadius,
      components: widget.components,
      decoration: widget.autocompleteTextboxDecoration,
      fields: widget.fields,
      hideSuggestionsOnKeyboardHide: widget.hideSuggestionsOnKeyboardHide,
      language: widget.language,
      location: widget.location,
      mounted: mounted,
      offset: widget.offset,
      onGetDetailsByPlaceId: (placesDetails) async {
        if (placesDetails == null) {
          logger.e("placesDetails is null");
          return;
        }
        _initialPosition = LatLng(
          placesDetails.result.geometry?.location.lat ?? 0,
          placesDetails.result.geometry?.location.lng ?? 0,
        );
        final controller = await _controller.future;
        controller
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition()));
        _address = AddressDisplayInfo(
          name: placesDetails.result.name,
          formattedAddress: placesDetails.result.formattedAddress ?? '',
          addressParts: placesDetails.result.addressComponents,
        );
        widget.onSuggestionSelected?.call(placesDetails);
        setState(() {});
      },
      origin: widget.origin,
      placesApiHeaders: widget.placesApiHeaders,
      placesBaseUrl: widget.placesBaseUrl,
      placesHttpClient: widget.placesHttpClient,
      radius: widget.radius,
      region: widget.region,
      searchController: _searchController,
      searchHintText: widget.searchHintText,
      sessionToken: widget.sessionToken,
      showBackButton: widget.showBackButton,
      strictbounds: widget.strictbounds,
      topCardColor: widget.topCardColor,
      topCardMargin: widget.topCardMargin,
      topCardShape: widget.topCardShape,
      types: widget.types,
    );
  }

  PlacesSearchNearby buildPlacesNearbySearch() {
    return PlacesSearchNearby(
      apiKey: widget.apiKey,
      backButton: widget.backButton,
      borderRadius: widget.borderRadius,
      components: widget.components,
      decoration: widget.autocompleteTextboxDecoration,
      fields: widget.fields,
      hideSuggestionsOnKeyboardHide: widget.hideSuggestionsOnKeyboardHide,
      language: widget.language,
      location: widget.location,
      mounted: mounted,
      onGetDetailsByPlaceId: (placesDetails) async {
        if (placesDetails == null) {
          logger.e("placesDetails is null");
          return;
        }
        _initialPosition = LatLng(
          placesDetails.result.geometry?.location.lat ?? 0,
          placesDetails.result.geometry?.location.lng ?? 0,
        );
        final controller = await _controller.future;
        controller
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition()));
        _address = AddressDisplayInfo(
          name: placesDetails.result.name,
          formattedAddress: placesDetails.result.formattedAddress ?? '',
          addressParts: placesDetails.result.addressComponents,
        );
        widget.onSuggestionSelected?.call(placesDetails);
        setState(() {});
      },
      placesApiHeaders: widget.placesApiHeaders,
      placesBaseUrl: widget.placesBaseUrl,
      placesHttpClient: widget.placesHttpClient,
      searchController: _searchController,
      searchHintText: widget.searchHintText,
      sessionToken: widget.sessionToken,
      showBackButton: widget.showBackButton,
      topCardColor: widget.topCardColor,
      topCardMargin: widget.topCardMargin,
      topCardShape: widget.topCardShape,
      types: widget.types,
    );
  }

  /// Camera position moved to location
  CameraPosition cameraPosition() {
    return CameraPosition(
      target: _initialPosition,
      zoom: _zoom,
    );
  }

  @override
  void initState() {
    _initialPosition = widget.currentLatLng ?? _initialPosition;
    _mapType = widget.mapType;
    _searchController = widget.searchController ?? _searchController;
    super.initState();
  }

  /// Decode address from latitude & longitude
  void _decodeAddress(Location location) async {
    try {
      final geocoding = GoogleMapsGeocoding(
        apiKey: widget.apiKey,
        baseUrl: widget.geoCodingBaseUrl,
        apiHeaders: widget.geoCodingApiHeaders,
        httpClient: widget.geoCodingHttpClient,
      );
      final response = await geocoding.searchByLocation(
        location,
        language: widget.language,
        locationType: widget.locationType,
        resultType: widget.resultType,
      );

      /// When get any error from the API, show the error in the console.
      if (response.hasNoResults ||
          response.isDenied ||
          response.isInvalid ||
          response.isNotFound ||
          response.unknownError ||
          response.isOverQueryLimit) {
        logger.e(response.errorMessage);
        _address = AddressDisplayInfo(name: response.status);
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
      _address = AddressDisplayInfo(
        formattedAddress: response.results.first.formattedAddress ?? '',
        addressParts: response.results.first.addressComponents,
      );
      _geocodingResult = response.results.first;
      if (response.results.length > 1) {
        _geocodingResultList = response.results;
      }
      setState(() {});
    } catch (e) {
      logger.e(e);
    }
  }
}
