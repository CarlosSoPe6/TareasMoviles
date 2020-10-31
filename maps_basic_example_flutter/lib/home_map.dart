import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeMap extends StatefulWidget {
  const HomeMap({Key key}) : super(key: key);

  @override
  _HomeMapState createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  final TextEditingController _searchController = TextEditingController();
  final Set<Marker> _mapMarkers = Set();
  final Set<Polygon> _polygons = Set();
  GoogleMapController _mapController;
  Position _currentPosition;
  Position _defaultPosition = Position(
    longitude: 20.608148,
    latitude: -103.417576,
  );

  Widget _drawer(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              onTap: () {
                _showPolygon();
                Navigator.of(context).pop();
              },
              title: Text(
                'Ver Polígono',
              ),
            ),
            ListTile(
              onTap: () {
                _mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(
                        _currentPosition.latitude,
                        _currentPosition.longitude,
                      ),
                      zoom: 15.0,
                    ),
                  ),
                );
                Navigator.of(context).pop();
              },
              title: Text(
                'Ir a mi ubicación',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gmap(BuildContext context, AsyncSnapshot<dynamic> result) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              _currentPosition.latitude,
              _currentPosition.longitude,
            ),
          ),
          polygons: _polygons,
          onMapCreated: _onMapCreated,
          markers: _mapMarkers,
          onLongPress: _setMarker,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCurrentPosition(),
      builder: (context, result) {
        if (result.error == null) {
          if (_currentPosition == null) _currentPosition = _defaultPosition;
          return Scaffold(
            drawer: _drawer(context),
            body: _gmap(context, result),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _displaySearchDialog(context);
              },
              child: Icon(Icons.search),
            ),
          );
        } else {
          Scaffold(
            body: Center(
              child: Text("Se ha producido un error"),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  void _showPolygon() {
    setState(() {
      if (_mapMarkers.isNotEmpty) {
        List<LatLng> vertex = List();
        _mapMarkers.forEach((element) {
          if (element.position.latitude == _currentPosition.latitude &&
              element.position.longitude == _currentPosition.longitude) {
            return;
          }
          vertex.add(
              LatLng(element.position.latitude, element.position.longitude));
        });
        var polygon = Polygon(
          polygonId: PolygonId(Timeline.now.toString()),
          points: vertex,
          strokeColor: Colors.purple,
          fillColor: Colors.blue,
        );
        _polygons.add(polygon);
      }
    });
  }

  void _onMapCreated(controller) {
    setState(() {
      _mapController = controller;
    });
  }

  void _setMarker(LatLng coord) async {
    // get address
    String _markerAddress = await _getGeocodingAddress(
      Position(
        latitude: coord.latitude,
        longitude: coord.longitude,
      ),
    );

    // add marker
    setState(() {
      _mapMarkers.add(
        Marker(
          markerId: MarkerId(coord.toString()),
          position: coord,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          onTap: () => showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              child: Column(
                children: [
                  Text('Address'),
                  Text(_markerAddress.toString()),
                  Text("${coord.latitude}, ${coord.longitude}")
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> _getCurrentPosition() async {
    //try {
    // verify permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    // get current position
    _currentPosition = await Geolocator.getCurrentPosition(
        timeLimit: Duration(seconds: 60),
        desiredAccuracy: LocationAccuracy.high);

    // get address
    String _currentAddress = await _getGeocodingAddress(_currentPosition);

    // add marker
    _mapMarkers.add(
      Marker(
        markerId: MarkerId(_currentPosition.toString()),
        position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        infoWindow: InfoWindow(
          title: _currentPosition.toString(),
          snippet: _currentAddress,
        ),
      ),
    );

    // move camera
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _currentPosition.latitude,
            _currentPosition.longitude,
          ),
          zoom: 15.0,
        ),
      ),
    );
    //} catch (e) {
    //  print(e);
    //}
  }

  Future<String> _getGeocodingAddress(Position position) async {
    // geocoding
    var places = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (places != null && places.isNotEmpty) {
      final Placemark place = places.first;
      return "${place.thoroughfare}, ${place.locality}";
    }
    return "No address available";
  }

  Future<Void> _displaySearchDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Búsqueda'),
            content: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(hintText: "Búsqueda"),
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Buscar'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  try {
                    List<Location> locations =
                        await locationFromAddress(_searchController.text);
                    Location location = locations[0];
                    // move camera
                    _mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(
                            location.latitude,
                            location.longitude,
                          ),
                          zoom: 15.0,
                        ),
                      ),
                    );
                  } catch (e) {}
                  _searchController.clear();
                },
              )
            ],
          );
        });
  }
}
