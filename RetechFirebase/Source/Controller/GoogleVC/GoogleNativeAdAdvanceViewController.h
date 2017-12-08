//
//  GoogleNativeAdAdvanceViewController.h
//  RetechFirebase
//
//  Created by Bui Duc Khanh on 12/6/17.
//  Copyright © 2017 Bui Duc Khanh. All rights reserved.
//
#import "Config.h"

@import GoogleMobileAds;
@import UIKit;

@interface GoogleNativeAdAdvanceViewController : UIViewController

/// Container that holds the native ad.
@property (weak, nonatomic) IBOutlet UIView *viewNativeAdPlaceHolder;

/// The Google Mobile Ads SDK version number label.
@property (weak, nonatomic) IBOutlet UILabel *lblSDKVersion;

/// Displays status messages about video assets.
@property (weak, nonatomic) IBOutlet UILabel *lblVideoStatus;

/// Switch to request app install ads.
@property (weak, nonatomic) IBOutlet UISwitch *swAppInstall;

/// Switch to request content ads.
@property (weak, nonatomic) IBOutlet UISwitch *swContentAd;

/// Indicates if video ads should start muted.
@property (weak, nonatomic) IBOutlet UISwitch *swVideoMuted;

/// Refresh the native ad.
@property (weak, nonatomic) IBOutlet UIButton *btnRefreshAd;

@end
