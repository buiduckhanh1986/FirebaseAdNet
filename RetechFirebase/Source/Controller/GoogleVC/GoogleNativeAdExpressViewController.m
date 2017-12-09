//
//  GoogleNativeAdExpressViewController.m
//  RetechFirebase
//
//  Created by Bui Duc Khanh on 12/9/17.
//  Copyright © 2017 Bui Duc Khanh. All rights reserved.
//

#import "GoogleNativeAdExpressViewController.h"

@interface GoogleNativeAdExpressViewController ()<GADNativeExpressAdViewDelegate, GADVideoControllerDelegate>

@end

@implementation GoogleNativeAdExpressViewController
{
    GADNativeExpressAdView *nativeExpressAdView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Build GUI
    [self buildGUI];
    
    // Load Ad
    [self loadAd];
}

- (void)buildGUI {
    self.title = @"Admob Native Express Ad";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    float frameWidth= self.view.bounds.size.width;
    
    nativeExpressAdView = [[GADNativeExpressAdView alloc] initWithFrame:CGRectMake(5, 5, frameWidth - 10, 300)];
    
    [self.view addSubview:nativeExpressAdView];
}


- (void)loadAd {
    nativeExpressAdView.adUnitID = kGoogleAdmobNativeExpressAdID;
    nativeExpressAdView.rootViewController = self;
    nativeExpressAdView.delegate = self;
    
    // The video options object can be used to control the initial mute state of video assets.
    // By default, they start muted.
    GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
    videoOptions.startMuted = true;
    [nativeExpressAdView setAdOptions:@[ videoOptions ]];
    
    // Set this UIViewController as the video controller delegate, so it will be notified of events
    // in the video lifecycle.
    nativeExpressAdView.videoController.delegate = self;
    
    GADRequest *request = [GADRequest request];
    [nativeExpressAdView loadRequest:request];
}

#pragma mark - GADNativeExpressAdViewDelegate

- (void)nativeExpressAdViewDidReceiveAd:(GADNativeExpressAdView *)nativeExpressAdView {
    if (nativeExpressAdView.videoController.hasVideoContent) {
        NSLog(@"Received ad an with a video asset.");
    } else {
        NSLog(@"Received ad an without a video asset.");
    }
}

#pragma mark - GADVideoControllerDelegate

- (void)videoControllerDidEndVideoPlayback:(GADVideoController *)videoController {
    NSLog(@"Playback has ended for this ad's video asset.");
}
@end
