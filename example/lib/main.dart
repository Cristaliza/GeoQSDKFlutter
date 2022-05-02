import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoq/geoq.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Repository(),
      child: MyApp(),
    ),
  );
}

class Repository extends Geoq with ChangeNotifier {
  String apiKey = "wUgo9ExixaGe6UdU1OkO7AGU6oQaqa";
  String notificationTitle = "GeoQ";
  String notificationDescription = "Flutter Plugin";
  String status = "Status : ";
  String latitudeTxt = "Latitud : ";
  String longitudeTxt = "Longitud : ";
  bool initialized = false;
  bool initializing = false;

  Future<void> initializeGeoQPlugin(String apiKey, String notificationTitle,
      String notificationDescription) async {
    try {
      status = "Initializing GeoQPlugin";
      initializing = true;
      notifyListeners();
      await Geoq.initGeoQ(apiKey, notificationTitle, notificationDescription);
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> setPermission(String permission, bool value) async {
    try {
      status = "Setting permissions";

      await Geoq.setUserPermission(permission, value);
      //notifyListeners();
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> getPermission(String permission) async {
    try {
      status = "Setting permissions";

      await Geoq.getUserPermission(permission);
      //notifyListeners();
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateExtraData(String extraData) async {
    try {
      status = "Updating data";

      await Geoq.updateExtraData(extraData);
      //notifyListeners();
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> subscribeToEvents() async {
    try {
      await Geoq.subscribeToEvents();
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> getAdIdWithPermissions() async {
    try {
      await Geoq.getAdIdWithPermission();
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> legalPermissions() async {
    try {
      await Geoq.legalPermissions();
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  @override
  void onGeoQRegisterError(String error) {
    status = "Status : onGeoQRegisterError \n " + "Device Id : " + error;
    initialized = false;
    initializing = false;
    notifyListeners();
  }

  @override
  void onGeoQRegisterSuccess(String deviceId) {
    status = "Status : onGeoQRegisterSuccess \n" + "Device Id : " + deviceId;
    initialized = true;
    initializing = false;
    notifyListeners();
  }

  @override
  void onGeoQRegisterWarning(String deviceId) {
    status = "Status : onGeoQRegisterWarning \n" + "Device Id : " + deviceId;
    initialized = true;
    initializing = false;
    notifyListeners();
  }

  @override
  void onGeoQGetUserPermissionError(String error) {
    status = "Status : onGeoQGetUserPermissionError \n " + "Error : " + error;
    notifyListeners();
  }

  @override
  void onGeoQGetUserPermissionSuccess(String result) {
    status =
        "Status : onGeoQGetUserPermissionSuccess \n" + "Result : " + result;
    notifyListeners();
  }

  @override
  void onGeoQSetUserPermissionError(String error) {
    status = "Status : onGeoQSetUserPermissionError \n " + "Error : " + error;
    notifyListeners();
  }

  @override
  void onGeoQSetUserPermissionSuccess(String result) {
    status =
        "Status : onGeoQSetUserPermissionSuccess \n" + "Result : " + result;
    notifyListeners();
  }

  @override
  void dataEvent(String source, String value) {
    print("dataEvent " + source + " : " + value);
  }

  @override
  void locationChangeEvent(String latitude, String longitude) {
    print("locationChangeEvent " + latitude + " : " + longitude);
    latitudeTxt = "Latitud : " + latitude;
    longitudeTxt = "Longitud : " + longitude;
    notifyListeners();
  }

  @override
  void pushEvent(Object data) {
    print("pushEvent " + data.toString());
  }

  @override
  void onGeoQUpdateExtraDataError(String result) {
    status = "Status : onGeoQUpdateExtraDataError \n" + "Result : " + result;
    notifyListeners();
  }

  @override
  void onGeoQUpdateExtraDataSuccess(String result) {
    status = "Status : onGeoQUpdateExtraDataSuccess \n" + "Result : " + result;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter GeoQ Plugin Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<Repository>(
              builder: (context, repository, child) => repository.initialized
                  ? Text(
                      '${repository.status}',
                      style: Theme.of(context).textTheme.headline4,
                    )
                  : Container(),
            ),
            Consumer<Repository>(
              builder: (context, repository, child) => repository.initializing
                  ? Text(
                      '${repository.status}',
                      style: Theme.of(context).textTheme.headline4,
                    )
                  : Container(),
            ),
            SizedBox(
              height: 20,
            ),
            Consumer<Repository>(
                builder: (context, repository, child) =>
                    !repository.initialized && !repository.initializing
                        ? ElevatedButton(
                            child: Text("Inicializar GeoQ Plugin"),
                            onPressed: () {
                              var repository = context.read<Repository>();
                              repository.initialize();
                              repository.initializeGeoQPlugin(
                                  repository.apiKey,
                                  repository.notificationTitle,
                                  repository.notificationDescription);
                            })
                        : Container()),
            SizedBox(
              height: 20,
            ),
            Consumer<Repository>(
                builder: (context, repository, child) =>
                    repository.initialized && !repository.initializing
                        ? ElevatedButton(
                            child: Text("Get GeoQ Tracking Permission"),
                            onPressed: () {
                              var repository = context.read<Repository>();
                              repository.getPermission("permissionTracking");
                            })
                        : Container()),
            SizedBox(
              height: 20,
            ),
            Consumer<Repository>(
                builder: (context, repository, child) =>
                    repository.initialized && !repository.initializing
                        ? ElevatedButton(
                            child: Text("Set GeoQ Permission True"),
                            onPressed: () {
                              var repository = context.read<Repository>();
                              repository.setPermission(
                                  "permissionTracking", true);
                            })
                        : Container()),
            SizedBox(
              height: 20,
            ),
            Consumer<Repository>(
                builder: (context, repository, child) =>
                    repository.initialized && !repository.initializing
                        ? ElevatedButton(
                            child: Text("Update Aditional Data"),
                            onPressed: () {
                              var repository = context.read<Repository>();
                              repository.updateExtraData(
                                  "AditionalId:123,AditionalId2:456");
                            })
                        : Container()),
            SizedBox(
              height: 20,
            ),
            Consumer<Repository>(
                builder: (context, repository, child) =>
                    repository.initialized && !repository.initializing
                        ? ElevatedButton(
                            child: Text("Get AdId "),
                            onPressed: () {
                              var repository = context.read<Repository>();
                              repository.getAdIdWithPermissions();
                            })
                        : Container()),
            SizedBox(
              height: 20,
            ),
            Consumer<Repository>(
                builder: (context, repository, child) => repository.initialized
                    ? Text(repository.latitudeTxt)
                    : Container()),
            Consumer<Repository>(
                builder: (context, repository, child) => repository.initialized
                    ? Text(repository.longitudeTxt)
                    : Container()),
          ],
        ),
      ),
    );
  }
}
