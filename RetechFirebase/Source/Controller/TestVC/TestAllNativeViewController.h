//
//  TestAllNativeViewController.h
//  RetechFirebase
//
//  Created by Bui Duc Khanh on 12/10/17.
//  Copyright © 2017 Bui Duc Khanh. All rights reserved.
//

#import "Config.h"

@import GoogleMobileAds;
@import UIKit;

@interface TestAllNativeViewController : UIViewController<GADNativeAppInstallAdLoaderDelegate, GADNativeContentAdLoaderDelegate, GADVideoControllerDelegate, GADNativeExpressAdViewDelegate>

@end
