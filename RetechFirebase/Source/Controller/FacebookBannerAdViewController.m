//
//  FacebookBannerAdViewController.m
//  RetechFirebase
//
//  Created by Bui Duc Khanh on 12/10/17.
//  Copyright © 2017 Bui Duc Khanh. All rights reserved.
//

#import "FacebookBannerAdViewController.h"

@interface FacebookBannerAdViewController ()

@end

@implementation FacebookBannerAdViewController
{
    FBAdView *adView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Build GUI
    [self buildGUI];
}

- (void)buildGUI {
    self.title = @"Banner Ad";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    float frameWidth= self.view.bounds.size.width;
    
    FBAdView *adView = [[FBAdView alloc] initWithPlacementID:kFacebookAudienceBannerAdPlacementID
                                                      adSize:kFBAdSizeHeight50Banner
                                          rootViewController:self];
    adView.frame = CGRectMake(frameWidth/2 - adView.bounds.size.width/2, 0, adView.bounds.size.width, adView.bounds.size.height);
    adView.delegate = self;
    [adView loadAd];
    [self.view addSubview:adView];
}

- (void)adView:(FBAdView *)adView didFailWithError:(NSError *)error {
    NSLog(@"Ad failed to load: %i", (int)error.code);
}

- (void)adViewDidLoad:(FBAdView *)adView {
    NSLog(@"Ad was loaded and ready to be displayed");
}
@end
