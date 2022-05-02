//
//  GeoQSDK.h
//  GeoQSDK
//
//  Created by Cristaliza S.L. on 5/5/16.
//  Copyright © 2016 Cristaliza S.L. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for GeoQSDK.
FOUNDATION_EXPORT double GeoQSDKVersionNumber;

//! Project version string for GeoQSDK.
FOUNDATION_EXPORT const unsigned char GeoQSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GeoQSDK/PublicHeader.h>

//#import <GeoQSDK/GeoQManager.h>

@class GeoQManager;

//#import <GeoQSDK/FG_GroupData.h>
//#import <GeoQSDK/FG_Event.h>
//#import <GeoQSDK/FG_Extra.h>
//#import <GeoQSDK/FG_Place.h>
//#import <GeoQSDK/FG_Paging.h>
//#import <GeoQSDK/FG_Authenticate.h>
//#import <GeoQSDK/FG_AuthenticateBean.h>

@class FG_Authenticate;

@class FG_AuthenticateBean;

//#import <GeoQSDK/FG_SoaApiPlace_NearbyParametersOut.h>
//#import <GeoQSDK/FG_SoaApiVoilapp_LoginAppParametersIn.h>
//#import <GeoQSDK/FG_SoaApiVoilapp_LoginAppService.h>
//#import <GeoQSDK/FG_SoaApiVoilapp_SendFormService.h>

@class FG_SoaApiVoilapp_SendFormService;

//#import <GeoQSDK/FG_SoaApiVoilapp_LoginAppParametersOut.h>

@class FG_SoaApiVoilapp_LoginAppParametersOut;
@class FG_SoaApiVoilapp_LoginAppParametersIn;
@class FG_SoaApiVoilapp_LoginAppService;

@class FG_SoaApiPlace_NearbyParametersOut;

//#import <GeoQSDK/FG_UserHabit.h>
//#import <GeoQSDK/FG_UserProfile.h>

@protocol FG_UserProfile;

@class FG_UserProfile;

@protocol FG_UserHabit;

@class FG_UserHabit;

@protocol FG_Place;

@class FG_Place;

@protocol FG_GroupData;

@class FG_GroupData;

@protocol FG_Event;
@protocol FG_Extra;

@class FG_Extra;
@class FG_Event;

@protocol FG_Paging;

@class FG_Paging;

