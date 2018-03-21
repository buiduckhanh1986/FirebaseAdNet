//
//  TestAllNativeViewController.m
//  RetechFirebase
//
//  Created by Bui Duc Khanh on 12/10/17.
//  Copyright © 2017 Bui Duc Khanh. All rights reserved.
//

#import "TestAllNativeViewController.h"

@interface TestAllNativeViewController ()

/// You must keep a strong reference to the GADAdLoader during the ad loading process.
@property(nonatomic, strong) GADAdLoader *admobAdLoader;

@end

@implementation TestAllNativeViewController
{
    UIView *admobNativeAdvanceAdView;
    
    UIView *viewAdmobNativeAdvanceAdPlaceHolder;
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
    self.title = @"All Native Ad";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    float width= self.view.bounds.size.width;
    float height = width * 628 /1200;
    
  
    viewAdmobNativeAdvanceAdPlaceHolder = [[UIView alloc] initWithFrame:CGRectMake(0, height + 20, width, height)];
    [self.view addSubview:viewAdmobNativeAdvanceAdPlaceHolder];
    
    
    
}

- (void)loadAd {
    GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
    videoOptions.startMuted = TRUE;
    
    // Admob Native Advance
    NSMutableArray *nativeAdvanceAdTypes = [[NSMutableArray alloc] init];
    
    [nativeAdvanceAdTypes addObject:kGADAdLoaderAdTypeNativeAppInstall];
    [nativeAdvanceAdTypes addObject:kGADAdLoaderAdTypeNativeContent];
    
    self.admobAdLoader = [[GADAdLoader alloc] initWithAdUnitID:kGoogleAdmobNativeAdvanceAdID
                                       rootViewController:self
                                                  adTypes:nativeAdvanceAdTypes
                                                  options:@[ videoOptions ]];
    self.admobAdLoader.delegate = self;
    [self.admobAdLoader loadRequest:[GADRequest request]];
    
}


- (void)setAdmobNativeAdvanceAdView:(UIView *)view {
    // Remove previous ad view.
    if (admobNativeAdvanceAdView != nil)
        [admobNativeAdvanceAdView removeFromSuperview];
    admobNativeAdvanceAdView = view;
    
    // Add new ad view and set constraints to fill its container.
    [viewAdmobNativeAdvanceAdPlaceHolder addSubview:view];
    [admobNativeAdvanceAdView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(admobNativeAdvanceAdView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[admobNativeAdvanceAdView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[admobNativeAdvanceAdView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDictionary]];
}


#pragma mark GADAdLoaderDelegate implementation

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"%@ Admob Advance failed with error: %@", adLoader, error);
}

#pragma mark GADNativeAppInstallAdLoaderDelegate implementation

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAppInstallAd:(GADNativeAppInstallAd *)nativeAppInstallAd {
    NSLog(@"Admob Advance Received native app install ad: %@", nativeAppInstallAd);
    
    GADNativeAppInstallAdView *appInstallAdView =
    [[NSBundle mainBundle] loadNibNamed:@"GoogleNativeAppInstallAdView" owner:nil options:nil].firstObject;
    
    [self setAdmobNativeAdvanceAdView:appInstallAdView];
    
    // Associate the app install ad view with the app install ad object. This is required to make the ad clickable.
    appInstallAdView.nativeAppInstallAd = nativeAppInstallAd;
    
    // Populate the app install ad view with the app install ad assets.
    // Some assets are guaranteed to be present in every app install ad.
    ((UILabel *)appInstallAdView.headlineView).text = nativeAppInstallAd.headline;
    ((UIImageView *)appInstallAdView.iconView).image = nativeAppInstallAd.icon.image;
    ((UILabel *)appInstallAdView.bodyView).text = nativeAppInstallAd.body;
    [((UIButton *)appInstallAdView.callToActionView)setTitle:nativeAppInstallAd.callToAction
                                                    forState:UIControlStateNormal];
    
    // Some app install ads will include a video asset, while others do not. Apps can use the
    // GADVideoController's hasVideoContent property to determine if one is present, and adjust their
    // UI accordingly.
    
    // The UI for this controller constrains the image view's height to match the media view's
    // height, so by changing the one here, the height of both views are being adjusted.
    if (nativeAppInstallAd.videoController.hasVideoContent) {
        // The video controller has content. Show the media view.
        appInstallAdView.mediaView.hidden = NO;
        appInstallAdView.imageView.hidden = YES;
        
        // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
        // ratio of the video it displays.
        NSLayoutConstraint *heightConstraint =
        [NSLayoutConstraint constraintWithItem:appInstallAdView.mediaView
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:appInstallAdView.mediaView
                                     attribute:NSLayoutAttributeWidth
                                    multiplier:(1 / nativeAppInstallAd.videoController.aspectRatio)
                                      constant:0];
        heightConstraint.active = YES;
        
        // By acting as the delegate to the GADVideoController, this ViewController receives messages
        // about events in the video lifecycle.
        nativeAppInstallAd.videoController.delegate = self;
        
        NSLog(@"Admob Advance Ad contains a video asset.");
    } else {
        // If the ad doesn't contain a video asset, the first image asset is shown in the
        // image view. The existing lower priority height constraint is used.
        appInstallAdView.mediaView.hidden = YES;
        appInstallAdView.imageView.hidden = NO;
        
        GADNativeAdImage *firstImage = nativeAppInstallAd.images.firstObject;
        ((UIImageView *)appInstallAdView.imageView).image = firstImage.image;
        
        NSLog(@"Admob Advance Ad does not contain a video.");
    }
    
    // These assets are not guaranteed to be present, and should be checked first.
    if (nativeAppInstallAd.starRating) {
        ((UIImageView *)appInstallAdView.starRatingView).image =
        [self imageForStars:nativeAppInstallAd.starRating];
        appInstallAdView.starRatingView.hidden = NO;
    } else {
        appInstallAdView.starRatingView.hidden = YES;
    }
    
    if (nativeAppInstallAd.store) {
        ((UILabel *)appInstallAdView.storeView).text = nativeAppInstallAd.store;
        appInstallAdView.storeView.hidden = NO;
    } else {
        appInstallAdView.storeView.hidden = YES;
    }
    
    if (nativeAppInstallAd.price) {
        ((UILabel *)appInstallAdView.priceView).text = nativeAppInstallAd.price;
        appInstallAdView.priceView.hidden = NO;
    } else {
        appInstallAdView.priceView.hidden = YES;
    }
    
    // In order for the SDK to process touch events properly, user interaction should be disabled.
    appInstallAdView.callToActionView.userInteractionEnabled = NO;
}

/// Gets an image representing the number of stars. Returns nil if rating is less than 3.5 stars.
- (UIImage *)imageForStars:(NSDecimalNumber *)numberOfStars {
    double starRating = numberOfStars.doubleValue;
    if (starRating >= 5) {
        return [UIImage imageNamed:@"stars_5"];
    } else if (starRating >= 4.5) {
        return [UIImage imageNamed:@"stars_4_5"];
    } else if (starRating >= 4) {
        return [UIImage imageNamed:@"stars_4"];
    } else if (starRating >= 3.5) {
        return [UIImage imageNamed:@"stars_3_5"];
    } else {
        return nil;
    }
}

#pragma mark GADNativeContentAdLoaderDelegate implementation

- (void)adLoader:(GADAdLoader *)adLoader
didReceiveNativeContentAd:(GADNativeContentAd *)nativeContentAd {
    NSLog(@"Admob Advance Received native content ad: %@", nativeContentAd);
    
    NSLog(@"Admob Advance Ad does not contain a video.");
    
    // Create and place ad in view hierarchy.
    GADNativeContentAdView *contentAdView =
    [[NSBundle mainBundle] loadNibNamed:@"GoogleNativeContentAdView" owner:nil options:nil].firstObject;
    [self setAdmobNativeAdvanceAdView:contentAdView];
    
    // Associate the content ad view with the content ad object. This is required to make the ad
    // clickable.
    contentAdView.nativeContentAd = nativeContentAd;
    
    // Populate the content ad view with the content ad assets.
    // Some assets are guaranteed to be present in every content ad.
    ((UILabel *)contentAdView.headlineView).text = nativeContentAd.headline;
    ((UILabel *)contentAdView.bodyView).text = nativeContentAd.body;
    ((UIImageView *)contentAdView.imageView).image =
    ((GADNativeAdImage *)nativeContentAd.images.firstObject).image;
    ((UILabel *)contentAdView.advertiserView).text = nativeContentAd.advertiser;
    [((UIButton *)contentAdView.callToActionView)setTitle:nativeContentAd.callToAction
                                                 forState:UIControlStateNormal];
    
    // Other assets are not, however, and should be checked first.
    if (nativeContentAd.logo && nativeContentAd.logo.image) {
        ((UIImageView *)contentAdView.logoView).image = nativeContentAd.logo.image;
        contentAdView.logoView.hidden = NO;
    } else {
        contentAdView.logoView.hidden = YES;
    }
    
    // In order for the SDK to process touch events properly, user interaction should be disabled.
    contentAdView.callToActionView.userInteractionEnabled = NO;
}


#pragma mark GADVideoControllerDelegate implementation

- (void)videoControllerDidEndVideoPlayback:(GADVideoController *)videoController {
    NSLog(@"Admob Video playback has ended.");
}
@end
