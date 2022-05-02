import Flutter
import UIKit
import GeoQSDK
import UserNotifications


var channel: FlutterMethodChannel!


public class SwiftGeoqPlugin: NSObject, FlutterPlugin {
        
  public static func register(with registrar: FlutterPluginRegistrar) {
    channel = FlutterMethodChannel(name: "geoq", binaryMessenger: registrar.messenger())
    let instance = SwiftGeoqPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
    
    
    public func returnStatus(deviceId : String){
    channel.invokeMethod("onGeoQRegisterSuccess", arguments: deviceId)
    }
    

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    let args = call.arguments as? Dictionary<String, Any>
        
    switch call.method {
    case "initGeoQ":
        print("initGeoQ Method")
        GeoQManager.sharedManager()?.registerDevice(appKey: args?["apiKey"] as! String, andPlatform: "https://services.geoq.es", trackingActive: true, completion: {response in
            print("Response from initGeoQ")
            print(response ?? "Null")
            result(response ?? "Failed to get response")
            if (response != nil)
            {
                channel.invokeMethod("onGeoQRegisterSuccess", arguments: response)
            } else
            {
                channel.invokeMethod("onGeoQRegisterSuccess", arguments: "Failed to initialize the device")
            }
        
            
        })
        
    case "setDataNotificationsToken":
        GeoQManager.sharedManager()?.setDataNotificationsToken(deviceToken: (args?["deviceToken"] as! Data), completion: { (response) in
            if (response)
            {
                channel.invokeMethod("onGeoSetDataNotificationsTokenSuccess", arguments: response)
            } else
            {
                channel.invokeMethod("onGeoSetDataNotificationsTokenError", arguments: "Error updating data")
            }
            //result(response)
        })
        
    case "getUserPermission":
        GeoQManager.sharedManager()?.getUserPermission(args?["perm"] as? String, completion: { (permission) in
            if (permission != nil)
            {
                channel.invokeMethod("onGeoQGetUserPermissionSuccess", arguments: permission)
            } else
            {
                channel.invokeMethod("onGeoQGetUserPermissionSuccess", arguments: "Error reading permisssions")
            }
        })
        
    case "setUserPermission":
        GeoQManager.sharedManager()?.setUserPermission(permission: args?["perm"] as! String, value: args?["value"] as! Bool, completion: { (response) in
            if (response)
            {
                channel.invokeMethod("onGeoQSetUserPermissionSuccess", arguments: response)
            } else
            {
                channel.invokeMethod("onGeoQSetUserPermissionSuccess", arguments: "Error setting permisssions")
            }
        })
    
    case "getAdIdWithPermission":
        GeoQManager.sharedManager()?.getAdIdWithPermissionWithCompletion({ (identifier) in
            
            result(identifier)
        })
    
    case "updateExtraData":
        GeoQManager.sharedManager()?.updateExtraData(strExtraData: args?["extraData"] as! String, completion: { response in
            channel.invokeMethod("onGeoQUpdateExtraDataSuccess",arguments: response)
        })
        
        
    case "getProfile":
        GeoQManager.sharedManager()?.getUserProfile({ (userProfile) in
            result(userProfile)
        })
    
    default:
        print("Method not found")
        result(call.method)
    }

  }
    
}
