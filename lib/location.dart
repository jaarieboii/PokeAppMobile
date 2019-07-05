import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:pokemondex/custom_theme.dart';
import 'package:pokemondex/themes.dart';

class MyLocation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyLocationState();
}

class MyLocationState extends State<MyLocation> {
  Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSubscription;

  Location location = new Location();
  String error;

  @override
  void initState() {
    super.initState();

    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;

    initPlatformState();
    locationSubscription = location.onLocationChanged().listen((Map<String,double> result) {
      setState(() {
        currentLocation = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
            title: Text('Location'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('lat/lng:${currentLocation['latitude']}/${currentLocation['longitude']}', style:
              TextStyle(
                fontSize: 30.0,
                color: Colors.blueAccent,),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              ListTile(
                onTap: () {
                  _changeTheme(context, MyThemeKeys.LIGHT);
                },
                title: Text("Light!"),
              ),
              ListTile(
                onTap: () {
                  _changeTheme(context, MyThemeKeys.DARK);
                },
                title: Text("Dark!"),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                title: Text("Home"),
              ),
            ],),
        ),
      )
    );
  }

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  void initPlatformState() async {
      Map<String, double> my_location;
      try {
        my_location = await location.getLocation();
        error = "";
      }on PlatformException catch(e) {
        if(e.code == 'PERMISION_DENIED')
          error = 'Permission denied';
        else if(e.code == 'PERMISSION_DENIED_NEVER_ASK')
          error = "permission denied - please ask the user to enable it from the app settings";
        my_location = null;
      }
      setState(() {
        currentLocation = my_location;
      });
    }
  }



