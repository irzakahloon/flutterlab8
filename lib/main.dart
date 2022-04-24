import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lab_8/page2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GeoLocatorApp(),
    );
  }
}
// Implement the “geolocator” package to determine the current position of the device upon click of the button. After determining the position of longitude and latitude of the current position.

// 2. Determine the current permission status for GPS in the App.

// 3. Modify the code done in task 1 to print the longitude and latitude of the current position on start of app instead of button press.
class GeoLocatorApp extends StatefulWidget {
  const GeoLocatorApp({Key? key}) : super(key: key);

  @override
  State<GeoLocatorApp> createState() => _GeoLocatorAppState();
}

class _GeoLocatorAppState extends State<GeoLocatorApp> {
  Position? position;

  @override
  initState() {
    var pos;
    Future.delayed(Duration(seconds: 3), () async {
      _determinePosition().then((value) {
        print(value);
        pos = value;
        setState(() {
          position = pos;
        });
        return value;
      });
    });

    super.initState();
  }

  Future<Position> _determinePosition() async {
    late LocationPermission permission;
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      }
    } //me nimaz prh kr aya
    if (permission == LocationPermission.deniedForever) {
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  currentLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Page 1'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Page2()));
                },
                child: Icon(
                  Icons.queue_play_next_rounded,
                  size: 100,
                ),
              ),
              Text(position == null ? 'No Access' : position.toString(),
                  style: TextStyle(fontSize: 24)),
              FlatButton(
                onPressed: () {
                  setState(() {
                    currentLocation();
                  });
                  print(position);
                },
                child: Icon(
                  Icons.location_pin,
                  size: 50,
                ),
              ),
            ],
          ),
        ));
  }
}
