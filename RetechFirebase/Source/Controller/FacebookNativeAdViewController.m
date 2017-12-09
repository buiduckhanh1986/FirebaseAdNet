//
//  FacebookNativeAdViewController.m
//  RetechFirebase
//
//  Created by Bui Duc Khanh on 12/8/17.
//  Copyright © 2017 Bui Duc Khanh. All rights reserved.
//

#import "FacebookNativeAdViewController.h"

@interface FacebookNativeAdViewController ()
@property (strong, nonatomic) FBNativeAd *nativeAd;

@end

@implementation FacebookNativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"Audience Network Native Ad";
    
#ifdef DEBUG
    [FBAdSettings setLogLevel:FBAdLogLevelLog];
    [FBAdSettings addTestDevice:@"4bd3b56d8c2d2b4e8e8c2919d2c243afdd9ab313"];
#endif
    
    // Use different ID for each ad placement in your app.
    FBNativeAd *nativeAd = [[FBNativeAd alloc] initWithPlacementID:kFacebookAudienceNativeAdPlacementID];
    
    // Set a delegate to get notified when the ad was loaded.
    nativeAd.delegate = self;
    
    // Configure native ad to wait to call nativeAdDidLoad: until all ad assets are loaded
    nativeAd.mediaCachePolicy = FBNativeAdsCachePolicyAll;
    [nativeAd loadAd];
}

- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd
{
    if (self.nativeAd) {
        [self.nativeAd unregisterView];
    }
    
    self.nativeAd = nativeAd;
    
    // Create native UI using the ad metadata.
    [self.viewAdCover setNativeAd:nativeAd];
    
    __weak typeof(self) weakSelf = self;
    [self.nativeAd.icon loadImageAsyncWithBlock:^(UIImage *image) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.imgvIcon.image = image;
    }];
    
    // Render native ads onto UIView
    self.lblAdTitle.text = self.nativeAd.title;
    self.lblBody.text = self.nativeAd.body;
    self.lblSocialContext.text = self.nativeAd.socialContext;
    self.lblSponsor.text = @"Sponsored";
    
    [self.btnAdAction setTitle:self.nativeAd.callToAction
                               forState:UIControlStateNormal];
    
    
    // Wire up UIView with the native ad; the whole UIView will be clickable.
    [nativeAd registerViewForInteraction:self.viewAdUI
                      withViewController:self];
    
    self.viewAdChoice.nativeAd = nativeAd;
    self.viewAdChoice.corner = UIRectCornerTopRight;
}

- (void)nativeAd:(FBNativeAd *)nativeAd didFailWithError:(NSError *)error
{
    NSLog(@"Native ad failed to load with error: %@", error);
}

- (void)nativeAdDidClick:(FBNativeAd *)nativeAd
{
    NSLog(@"Native ad was clicked.");
}

- (void)nativeAdDidFinishHandlingClick:(FBNativeAd *)nativeAd
{
    NSLog(@"Native ad did finish click handling.");
}

- (void)nativeAdWillLogImpression:(FBNativeAd *)nativeAd
{
    NSLog(@"Native ad impression is being captured.");
}
@end
