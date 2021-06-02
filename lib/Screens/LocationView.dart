import 'dart:async';
import 'dart:core';
import 'dart:typed_data';
import 'package:declic_ap/resources/firebase_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const double CAMERA_ZOOM = 20;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;

class LocationView extends StatefulWidget {
  final String uid;
  final GeoPoint firstP;

  const LocationView({Key key, this.uid, this.firstP}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LocationViewState();
}

class LocationViewState extends State<LocationView> {
  LocationViewState();

  MapboxMapController controller;
  bool showMap;
  Symbol myCurrentSymbol;
  StreamSubscription locationSubscription;
  LatLng myCurrentlatLng;

  final FireMethods fireMethods = FireMethods();

  void _onStyleLoaded() async {
    await addImageFromAsset("assetImage", "assets/custom-icon.png");
    if (myCurrentSymbol == null) {
      myCurrentSymbol = await controller
          .addSymbol(
        SymbolOptions(geometry: myCurrentlatLng, iconImage: "assetImage"),
      )
          .then((value) {
        print("true");
        return value;
      }).onError((error, stackTrace) {
        print("false");
        return null;
      });
    }
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller?.addImage(name, list);
  }

  @override
  void initState() {
    showMap = widget.firstP != null ? true : false;

    if (showMap)
      myCurrentlatLng = LatLng(widget.firstP.latitude, widget.firstP.longitude);

    locationSubscription =
        fireMethods.getUserStreamFromUid(widget.uid).listen((event) async {
      final GeoPoint geoPoint = event.get("pos");
      if (geoPoint != null) {
        if (showMap) {
          myCurrentlatLng = LatLng(geoPoint.latitude, geoPoint.longitude);
          controller?.animateCamera(CameraUpdate.newLatLng(myCurrentlatLng));
          if (myCurrentSymbol != null) {
            controller?.updateSymbol(
                myCurrentSymbol,
                SymbolOptions(
                    geometry: myCurrentlatLng, iconImage: "assetImage"));
          }
        } else {
          setState(() {
            myCurrentlatLng = LatLng(geoPoint.latitude, geoPoint.longitude);
            showMap = true;
          });
        }
      }
    });
    super.initState();
  }

  void _onMapCreated(MapboxMapController controller) async {
    this.controller = controller;
  }

  @override
  void dispose() {
    controller?.dispose();
    locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return showMap
        ? Material(
                  child: Stack(
            children: [
              Positioned.fill(
                            child: MapboxMap(
                    accessToken:
                        "pk.eyJ1Ijoid2xhbjA3IiwiYSI6ImNrbzFkMjh3NjA3aW0ycWxwcDlsY3E0em4ifQ.SzsG9P26lUTgf1LZsjKgBw",
                    onMapCreated: _onMapCreated,
                    onStyleLoadedCallback: _onStyleLoaded,
                    initialCameraPosition: CameraPosition(
                        target: myCurrentlatLng,
                        zoom: CAMERA_ZOOM,
                        bearing: CAMERA_BEARING,
                        tilt: CAMERA_TILT),
                  ),
              ),
                Positioned(
                  child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back_ios)),
                  top: 20,
                  left: 10,
                ),
            ],
          ),
        )
        : Material(
            child: Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: Text("NO LOCATION DATA ENCORE ..."),
                ),
              ),
              Positioned(
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back_ios)),
                top: 20,
                left: 10,
              ),
            ],
          ));
  }
}
