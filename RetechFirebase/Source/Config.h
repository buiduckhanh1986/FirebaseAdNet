//
//  Config.h
//  RetechFirebase
//
//  Created by Bui Duc Khanh on 12/5/17.
//  Copyright © 2017 Bui Duc Khanh. All rights reserved.
//

#ifndef Config_h
#define Config_h

#import <Foundation/Foundation.h>

static NSString *const kGCMMessageIDKey                                                             = @"gcm.message_id";

static NSString *const kGoogleAdmobAppID                                                            = @"ca-app-pub-6936496742883768~6967597834";

static NSString *const kGoogleBannerAdID                                                            = @"ca-app-pub-3940256099942544/6300978111";

static NSString *const kGoogleAdmobNativeExpressAdID                                                = @"ca-app-pub-3940256099942544/8897359316";

static NSString *const kGoogleAdmobNativeAdvanceAdID                                                = @"ca-app-pub-3940256099942544/3986624511";

static NSString *const kGoogleAdmobRewardVideoAdID                                                = @"ca-app-pub-3940256099942544/1712485313";

static NSString *const kGoogleAdmobInterstitialAdID                                                = @"ca-app-pub-3940256099942544/4411468910";

static NSString *const kFacebookAudienceBannerAdPlacementID                                         = @"IMG_16_9_APP_INSTALL#156415834974454_156991784916859";

static NSString *const kFacebookAudienceNativeAdPlacementID                                         = @"VID_HD_16_9_46S_APP_INSTALL#156415834974454_156416568307714"; //https://developers.facebook.com/docs/audience-network/testing?locale=vi_VN

static NSString *const kFirebaseRemoteConfig_google_admob                                           = @"admob_enable";

static NSString *const kFirebaseRemoteConfig_facebook_audience_network                              = @"audience_network_enable";


static NSString *const kUnityGameId                              = @"1739631";

static int kUnityMediationOrdinal                               = 1;
static BOOL kUnityTestMode                                      = TRUE;

#endif /* Config_h */
