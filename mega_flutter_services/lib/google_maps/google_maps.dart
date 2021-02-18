import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../gps/gps_utils.dart';
import 'marker.dart';

class MegaMaps extends StatefulWidget {
  final String style;
  final bool compassEnabled;
  final bool myLocationEnabled;
  final bool myLocationButtonEnabled;
  final List<MegaMarker> markers;
  final String icon;

  const MegaMaps({
    this.style,
    this.compassEnabled = true,
    this.myLocationEnabled = true,
    this.myLocationButtonEnabled = true,
    this.markers = const [],
    this.icon,
  });

  @override
  _MegaMapsState createState() => _MegaMapsState();
}

class _MegaMapsState extends State<MegaMaps> {
  GoogleMapController mapController;
  final LatLng _center = const LatLng(-33.558224, -46.6620382);
  BitmapDescriptor icon = BitmapDescriptor.defaultMarker;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      compassEnabled: widget.compassEnabled,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
      myLocationEnabled: widget.myLocationEnabled,
      myLocationButtonEnabled: widget.myLocationButtonEnabled,
      markers: widget.markers
          .map(
            (mark) => Marker(
              markerId: MarkerId('${mark.lat}${mark.lng}'),
              position: LatLng(
                mark.lat,
                mark.lng,
              ),
              icon: icon,
            ),
          )
          .toSet(),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (widget.style != null && widget.style.isNotEmpty) {
      mapController.setMapStyle(widget.style);
    }

    if (widget.icon != null && widget.icon.isNotEmpty) {
      final config =
          createLocalImageConfiguration(context, size: const Size(12, 12));

      BitmapDescriptor.fromAssetImage(
        config,
        'assets/ic_marker.png',
        package: 'mega_flutter_services',
      ).then(
        (value) {
          setState(() {
            this.icon = value;
          });
        },
      );
    }

    MegaGPSLocationUtils.getAnyLocation().then((value) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(value[0], value[1]),
          zoom: 13.8,
        ),
      ));
    }, onError: (e) {});
  }
}
