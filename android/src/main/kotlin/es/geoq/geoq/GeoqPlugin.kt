package es.geoq.geoq

import android.Manifest
import android.app.AlertDialog
import android.content.DialogInterface
import android.content.pm.PackageManager
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.View
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.app.ActivityCompat.shouldShowRequestPermissionRationale
import androidx.core.content.ContextCompat
import com.geoq.*
import com.google.android.gms.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.Exception
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

import soa.api.common.services.*
import soa.api.common.services.Authenticate
import soa.api.common.Extra
import soa.api.profiler.UserProfile
import soa.api.user.Device
import soa.api.user.User_FindPlacesNearbyService

/** GeoqPlugin */
class GeoqPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {

  private lateinit var channel : MethodChannel
  private lateinit var activity: FlutterActivity


  override fun onDetachedFromActivity() {
    Log.d("GeoQ", "onDetachedFromActivity")

  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    Log.d("GeoQ", "onReattachedToActivityForConfigChanges")

    activity = binding.activity as FlutterActivity
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    Log.d("GeoQ", "onAttachedToActivity")
    activity = binding.activity as FlutterActivity
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    Log.d("GeoQ", "onMethodCall")

    when(call.method){
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE} ${android.os.Build.VERSION.CODENAME}")

      "initGeoQ" -> {
        var apikey = call.argument<String>("apiKey")
        var notificationTitle = call.argument<String>("notificationTitle")
        var notificationDescription = call.argument<String>("notificationDescription")
        initGeoQ(apikey, notificationTitle, notificationDescription, activity)
        result.success("initGeoQ")
      }

      "subscribeToEvents" ->{
        subscribeToEvents()
        result.success("subscribeToEvents")
      }

      "getUserPermission" -> {
        var perm : String? = call.argument<String>("perm")
        getUserPermission(perm)
        result.success("getUserPermission")
      }
      "setUserPermission" -> {

        var perm : String? = call.argument<String>("perm")
        var value :Boolean = call.argument<Boolean>("value") == true
        setUserPermission(perm, value)
        result.success("setUserPermission")
      }
      "updateExtraData" -> {
        var extraData : String? = call.argument<String>("extraData")
        updateExtraData(extraData)
        result.success("updateExtraData")
      }
      "getAdIdWithPermission" -> {
        var adid : String? = getAdIdWithPermission()
        result.success("getAdIdWithPermission")
      }
      "legalPermissions" -> {
        legalPermissions()
        result.success("legalPermissions")
      }

      "getProfile" -> {
        var userProfile : UserProfile? = getProfile()
        result.success(userProfile.toString())
      }

      else -> result.notImplemented()
    }

  }


  override fun onDetachedFromActivityForConfigChanges() {
    Log.d("GeoQ", "onDetachedFromActivityForConfigChanges")


  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    Log.d("GeoQ", "onAttachedToEngine")
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "geoq")
    channel.setMethodCallHandler(this)
    flutterPluginBinding.applicationContext


  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    Log.d("GeoQ", "onDetachedFromEngine")

    channel.setMethodCallHandler(null)
  }




  private fun checkLocationPermission() : Boolean{
    Log.d("GeoQ", "checkLocationPermission")
    var permissionStatus : Boolean = false
    if (ContextCompat.checkSelfPermission(activity,
        android.Manifest.permission.ACCESS_FINE_LOCATION)
      != PackageManager.PERMISSION_GRANTED) {

        permissionStatus = false

      ActivityCompat.requestPermissions(activity,
        arrayOf(android.Manifest.permission.ACCESS_FINE_LOCATION),
        0)
    }

    if (ContextCompat.checkSelfPermission(activity,
        android.Manifest.permission.WRITE_EXTERNAL_STORAGE)
      != PackageManager.PERMISSION_GRANTED) {

      permissionStatus = false

      ActivityCompat.requestPermissions(activity,
        arrayOf(android.Manifest.permission.WRITE_EXTERNAL_STORAGE),
        0)
    }

    return permissionStatus

  }





  private fun getUserPermission(perm: String?) {
    Log.d("GeoQ", "getUserPermission")

    try {

      GeoQ.getInstance().getUserPermission(perm,object : CallbackListener() {
          override fun onSuccess(o: Any) {
            try {
              
              Handler(Looper.getMainLooper()).post {
                channel.invokeMethod("onGeoQGetUserPermissionSuccess",o)
              }
            } catch (e: Exception) {
              e.printStackTrace()
            }
          }

          override fun onError(error: Error) {
            Log.d("GeoQ", "onError $error")
            Handler(Looper.getMainLooper()).post {
              channel.invokeMethod("onGeoQGetUserPermissionError",error.toString())
            }
          }
        })
      
    } catch (e: Exception) {
      e.printStackTrace()
    }
  }

  private fun setUserPermission(perm: String?, value: Boolean) {
    Log.d("GeoQ", "setUserPermission")
    try {
      
      GeoQ.getInstance().setUserPermission(perm,value, object : CallbackListener() {
          override fun onSuccess(o: Any) {
            try {
              
              Handler(Looper.getMainLooper()).post {
                channel.invokeMethod("onGeoQSetUserPermissionSuccess",o)
              }
            } catch (e: Exception) {
              e.printStackTrace()
            }
          }

          override fun onError(error: Error) {
            Log.d("GeoQ", "onError $error")
            Handler(Looper.getMainLooper()).post {
              channel.invokeMethod("onGeoQSetUserPermissionError",error.toString())
            }
          }
        })
      
    } catch (e: Exception) {
      e.printStackTrace()
    }
  }
private fun getAdIdWithPermission() : String {

  try {
      var result = GeoQ.getInstance().getAdvertisingID(activity)
      return result
    } catch (e: Exception) {
      return "Error"
      e.printStackTrace()
    }
}
private fun updateExtraData(extraData: String?) {
    

    try {

      GeoQ.getInstance().updateExtraData(extraData,object : CallbackListener() {
          override fun onSuccess(o: Any) {
            try {
              
              Handler(Looper.getMainLooper()).post {
                channel.invokeMethod("onGeoQUpdateExtraDataSuccess",o)
              }
            } catch (e: Exception) {
              e.printStackTrace()
            }
          }

          override fun onError(error: Error) {
            Log.d("GeoQ", "onError $error")
            Handler(Looper.getMainLooper()).post {
              channel.invokeMethod("onGeoQUpdateExtraDataError",error.toString())
            }
          }
        })
    } catch (e: Exception) {
      e.printStackTrace()
    }
  }

  fun legalPermissions() {
    try {
      GeoQ.getInstance().legalPermissions()
    } catch (e: Exception) {
      e.printStackTrace()
    }
  }

  fun getProfile(): UserProfile? {
    Log.d("GeoQ", "getProfile")

    try {
      val profile = GeoQ.getInstance().userProfile
      if (profile != null) {
        Log.d("GeoQ", "User profile = $profile")
        return profile
      } else {
       return null
      }
    } catch (e: Exception) {
      e.printStackTrace()
    }
    return UserProfile()
  }

  private fun subscribeToEvents(){
    var events : Events = Events()
    events.channel = channel
    GeoQ.getInstance().addListener(events);
  }

  private fun initGeoQ(apikey :String?, notificationTitle :String?, notificationDescription :String?, activity: FlutterActivity) {
    Log.d("GeoQ", "initGeoQ")


    var geolocationPermitted : Boolean = checkLocationPermission()

    try {
      val geoQConfig = GeoQRegisterConfigBuilder.Builder()
        .withApiKey(apikey)
        .withNotificationTitle(notificationTitle)
        .withNotificationDescription(notificationDescription)
        .withContext(activity.context)
        .withCallbackListener(object : CallbackListener() {
          override fun onSuccess(o: Any) {
            Log.d("GeoQ", "onSuccess DeviceId $o")
            try {
              Handler(Looper.getMainLooper()).post {
                channel.invokeMethod("onGeoQRegisterSuccess",o)
              }
            } catch (e: Exception) {
              e.printStackTrace()
            }
          }

          override fun onWarning(o: Any) {
            Log.d("GeoQ", "onWarning DeviceId $o")
            Handler(Looper.getMainLooper()).post {
              channel.invokeMethod("onGeoQRegisterWarning",o)
            }
          }

          override fun onError(error: Error) {
            Log.d("GeoQ", "onError $error")
            Handler(Looper.getMainLooper()).post {
              channel.invokeMethod("onGeoQRegisterError",error.toString())
            }
          }
        })
        .build()
      Log.d("GeoQ",geoQConfig.toString())
      GeoQ.getInstance().registerDevice(geoQConfig)

    } catch (e: ConfigurationException) {
      e.printStackTrace()
    } catch (e: Exception) {
      e.printStackTrace()
    }
  }


  internal class Events : IGeoQSDKEventListener {
    lateinit var channel : MethodChannel;

    override fun locationChangeEvent(latitude: String, longitude: String) {
      Log.d("GeoQ", "locationChangeEvent")
      Handler(Looper.getMainLooper()).post {
        val arguments: HashMap<String, Any> = HashMap()
        arguments["latitude"] = latitude
        arguments["longitude"] = longitude
        channel.invokeMethod("locationChangeEvent", arguments)
      }
    }
    override fun dataEvent(source: String, value: String) {
      Log.d("GeoQ", "dataEvent")
      Handler(Looper.getMainLooper()).post {
        val arguments: HashMap<String, Any> = HashMap()
        arguments["source"] = source
        arguments["value"] = value
        channel.invokeMethod("dataEvent",arguments)
      }
    }
    override fun pushEvent(data: Bundle) {
      Log.d("GeoQ", "pushEvent")
      Handler(Looper.getMainLooper()).post {
        channel.invokeMethod("pushEvent",data)
      }
    }
  }


}

