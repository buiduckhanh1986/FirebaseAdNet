//
//  GoogleBannerAdViewController.m
//  RetechFirebase
//
//  Created by Bui Duc Khanh on 12/9/17.
//  Copyright © 2017 Bui Duc Khanh. All rights reserved.
//

#import "GoogleBannerAdViewController.h"

@interface GoogleBannerAdViewController ()

@end

@implementation GoogleBannerAdViewController
{
    GADBannerView *viewBannerAd;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Build GUI
    [self buildGUI];
    
    // Load Ad
    [self loadAd];
}

- (void)buildGUI {
    self.title = @"Banner Ad";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    float frameWidth= self.view.bounds.size.width;
    
    //viewBannerAd = [[GADBannerView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, frameWidth * 628/1200)];
    viewBannerAd = [[GADBannerView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, 50)];
    
    [self.view addSubview:viewBannerAd];
}


- (void)loadAd {
    // Replace this ad unit ID with your own ad unit ID.
    viewBannerAd.adUnitID = kGoogleBannerAdID;
    viewBannerAd.rootViewController = self;
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADBannerView automatically returns test ads when running on a
    // simulator.
    request.testDevices = @[ kGADSimulatorID ];
    [viewBannerAd loadRequest:request];
}

@end
