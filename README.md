# GeoqSDK Flutter

Este plugin ha sido desarrollado tomando como base los sdk de [GeoQ](https://geoq.es) para [Android](http://services.geoq.es/content/documentation/geoq/sdk/android/Geoq-SDK-android-v2.0.1.pdf) y [iOS](http://services.geoq.es/content/documentation/geoq/sdk/ios/Geoq-SDK-ios-v2.0.1_Swift_ES.pdf) descritos en la documentación oficial.

## Ejemplo

Para ejecutar el ejemplo incluido, es necesario clonar este repositorio en un directorio local, a continuación acceder al directorio local mediante una terminal y navegar la carpeta example

Una vez estando en la carpeta example, ejecutar 

    flutter pub get

Es necesario registrar un nuevo proyecto en [Firebase](https://firebase.google.com/docs/android/setup?hl=es), obtener el archivo google-services.json y copiarlo en el directorio example/android/app/

Una vez finalizada la configuración, es posible ejecutar el ejemplo mediante el comando 

    flutter run


## Uso del sdk

Para el ejemplo incluido, se importa el plugin de la siguiente manera en el archivo pubspec.yaml

```
  geoq:
    path: ../
```
Despues en el archivo clase main.dart

```
import 'package:geoq/geoq.dart';
```
Creamos la clase Repository la cual extendera de la clase Geoq

```
class Repository extends Geoq with ChangeNotifier
```

En este ejemplo utilizamos ChangeNotifier del paquete [provider](https://pub.dev/packages/provider) para actualizar los widgets de acuerdo al estado de las variables

Al extender de la clase Geoq tendremos que implementar los siguientes override

```
  @override
  void onGeoQRegisterError(String error) {
  }

  @override
  void onGeoQRegisterSuccess(String deviceId) {
  }

  @override
  void onGeoQRegisterWarning(String deviceId) {
  }
```
Los métodos anteriores son ejecutados como resultado de inicializar el sdk de Geoq mediante 

```
await Geoq.initGeoQ(String apiKey, String notificationTitle, String notificationDescription);
```
La llamada al método será de acuerdo al resultado de la inicialización del SDK.

Los siguientes métodos nos servirán para manejar los distintos eventos provenientes del código nativo

```
  @override
  void dataEvent(String source, String value) {
  }

  @override
  void locationChangeEvent(String latitude, String longitude) {
  }

  @override
  void pushEvent(Object data) {
  }
  ```
Para hacer uso de esta característica, es necesario suscribir al registro de eventos de la siguiente manera

```
    await Geoq.subscribeToEvents();
```



## Métodos adicionales

    legalPermissions()

Este método permite lanzar la página de consulta de los permisos legales establecidos para el usuario de la aplicación. 

Lanzará una ventana del navegador con dicha página, si ha sido establecida la misma en GeoQ. En caso contrario, no realizará ninguna acción.

    getUserPermission(String permission)

Los valores devueltos por la plataforma pueden ser los siguientes (siempre de tipo String):

• “true”: el usuario ha aceptado el permiso consultado

• “false”: el usuario no ha aceptado el permiso consultado

• “no-response”: el usuario no ha respondido al permiso consultado

• “”: el valor para este permiso no se ha generado en GeoQ para la aplicación.

Póngase en contacto con el administrador si desea establecer dichos permisos.

    setUserPermission(String perm, bool value)

Permite establecer el valor deseado para el permiso deseado. Los parámetros válidos son:

• permission: es el nombre del permiso a establecer (permissionTracking, permissionNotifications o permissionRevoke).

• value: true o false. Indica si se concede o se deniega el permiso.

    getProfile()

Este método permite la obtención del perfil del usuario en el momento que se requiera