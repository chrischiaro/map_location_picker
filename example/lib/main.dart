import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_location_picker/map_location_picker.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String address = "null";
  String autocompletePlace = "null";
  Prediction? initialValue;

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('location picker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.90,
                  width: MediaQuery.of(context).size.width * 0.99,
                  child: MapLocationPicker(
                    apiKey: '',
                    autocompleteTextboxDecoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(
                        16.0,
                        8.0,
                        16.0,
                        8.0,
                      ),
                      fillColor: Theme.of(context).colorScheme.primary,
                      hintText: 'Start typing to search...',
                      hintStyle: Theme.of(context)
                          .inputDecorationTheme
                          .hintStyle
                          ?.copyWith(fontSize: 16),
                    ),
                    bottomCardColor: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    currentLatLng: const LatLng(37.6922400, -97.3375400),
                    onNext: (p0) {},
                    topCardMargin: const EdgeInsets.only(top: 15.0),
                    strictbounds: true,
                  ),
                ),
              ],
            ),
          ),
          // PlacesAutocomplete(
          //   searchController: _controller,
          //   apiKey: "AIzaSyBYVPrbYFBv3mJTECxK0n-BqFr9IlRrTgs",
          //   // placesBaseUrl:
          //   //     'https://maps.googleapis.com/maps/api/place/nearbysearch/json?',
          //   mounted: mounted,
          //   showBackButton: false,
          //   onGetDetailsByPlaceId: (PlacesDetailsResponse? result) {
          //     if (result != null) {
          //       setState(() {
          //         autocompletePlace = result.result.formattedAddress ?? "";
          //       });
          //     }
          //   },
          // ),
          // OutlinedButton(
          //   child: Text('show dialog'.toUpperCase()),
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       builder: (context) {
          //         return AlertDialog(
          //           title: const Text('Example'),
          //           content: PlacesAutocomplete(
          //             apiKey: "AIzaSyBYVPrbYFBv3mJTECxK0n-BqFr9IlRrTgs",
          //             // placesBaseUrl:
          //             //     'https://maps.googleapis.com/maps/api/place/nearbysearch/json?',
          //             searchHintText: "Search for a place",
          //             mounted: mounted,
          //             showBackButton: false,
          //             initialValue: initialValue,
          //             onSuggestionSelected: (value) {
          //               setState(() {
          //                 autocompletePlace =
          //                     value.structuredFormatting?.mainText ?? "";
          //                 initialValue = value;
          //               });
          //             },
          //             onGetDetailsByPlaceId: (value) {
          //               setState(() {
          //                 address = value?.result.formattedAddress ?? "";
          //               });
          //             },
          //           ),
          //           actions: <Widget>[
          //             TextButton(
          //               child: const Text('Done'),
          //               onPressed: () => Navigator.of(context).pop(),
          //             ),
          //           ],
          //         );
          //       },
          //     );
          //   },
          // ),
          // const Spacer(),
          // const Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: Text(
          //     "Google Map Location Picker\nMade By Arvind 😃 with Flutter 🚀",
          //     textAlign: TextAlign.center,
          //     textScaleFactor: 1.2,
          //     style: TextStyle(
          //       color: Colors.grey,
          //     ),
          //   ),
          // ),
          // TextButton(
          //   onPressed: () => Clipboard.setData(
          //     const ClipboardData(text: "https://www.mohesu.com"),
          //   ).then(
          //     (value) => ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(
          //         content: Text("Copied to Clipboard"),
          //       ),
          //     ),
          //   ),
          //   child: const Text("https://www.mohesu.com"),
          // ),
          // const Spacer(),
          // Center(
          //   child: ElevatedButton(
          //     child: const Text('Pick location'),
          //     onPressed: () async {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) {
          //             return MapLocationPicker(
          //               apiKey: "AIzaSyBYVPrbYFBv3mJTECxK0n-BqFr9IlRrTgs",
          //               // placesBaseUrl:
          //               //     'https://maps.googleapis.com/maps/api/place/nearbysearch/json?',
          //               canPopOnNextButtonTaped: true,
          //               currentLatLng: const LatLng(29.121599, 76.396698),
          //               onNext: (GeocodingResult? result) {
          //                 if (result != null) {
          //                   setState(() {
          //                     address = result.formattedAddress ?? "";
          //                   });
          //                 }
          //               },
          //               onSuggestionSelected: (PlacesDetailsResponse? result) {
          //                 if (result != null) {
          //                   setState(() {
          //                     autocompletePlace =
          //                         result.result.formattedAddress ?? "";
          //                   });
          //                 }
          //               },
          //             );
          //           },
          //         ),
          //       );
          //     },
          //   ),
          // ),
          // const Spacer(),
          // ListTile(
          //   title: Text("Geocoded Address: $address"),
          // ),
          // ListTile(
          //   title: Text("Autocomplete Address: $autocompletePlace"),
          // ),
          // const Spacer(
          //   flex: 3,
          // ),
        ],
      ),
    );
  }
}
