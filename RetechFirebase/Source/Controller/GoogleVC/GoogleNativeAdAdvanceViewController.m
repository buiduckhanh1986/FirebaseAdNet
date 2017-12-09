//
//  GoogleNativeAdAdvanceViewController.m
//  RetechFirebase
//
//  Created by Bui Duc Khanh on 12/6/17.
//  Copyright © 2017 Bui Duc Khanh. All rights reserved.
//

#import "GoogleNativeAdAdvanceViewController.h"

@interface GoogleNativeAdAdvanceViewController ()<GADNativeAppInstallAdLoaderDelegate, GADNativeContentAdLoaderDelegate,
GADVideoControllerDelegate>

/// You must keep a strong reference to the GADAdLoader during the ad loading process.
@property(nonatomic, strong) GADAdLoader *adLoader;

/// The native ad view that is being presented.
@property(nonatomic, strong) UIView *nativeAdView;

@end

@implementation GoogleNativeAdAdvanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Admob Native Advance Ad";
    
    
    self.lblSDKVersion.text = [GADRequest sdkVersion];
    [self onRefreshTouchUpInside:nil];
}

// Refresh Ad Content
- (IBAction)onRefreshTouchUpInside:(id)sender {
    // Loads an ad for any of app install, content, or custom native ads.
    NSMutableArray *adTypes = [[NSMutableArray alloc] init];
    
    if (self.swAppInstall.on) {
        [adTypes addObject:kGADAdLoaderAdTypeNativeAppInstall];
    }
    if (self.swContentAd.on) {
        [adTypes addObject:kGADAdLoaderAdTypeNativeContent];
    }
    
    if (adTypes.count == 0) {
        NSLog(@"At least one ad format must be selected to refresh the ad.");
    } else {
        self.btnRefreshAd.enabled = NO;
        
        GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
        videoOptions.startMuted = self.swVideoMuted.on;
        
        self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:kGoogleAdmobNativeAdvanceAdID
                                           rootViewController:self
                                                      adTypes:adTypes
                                                      options:@[ videoOptions ]];
        self.adLoader.delegate = self;
        [self.adLoader loadRequest:[GADRequest request]];
        self.lblVideoStatus.text = @"";
    }
}


- (void)setAdView:(UIView *)view {
    // Remove previous ad view.
    [self.nativeAdView removeFromSuperview];
    self.nativeAdView = view;
    
    // Add new ad view and set constraints to fill its container.
    [self.viewNativeAdPlaceHolder addSubview:view];
    [self.nativeAdView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_nativeAdView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_nativeAdView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_nativeAdView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDictionary]];
}


#pragma mark GADAdLoaderDelegate implementation

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"%@ failed with error: %@", adLoader, error);
    self.btnRefreshAd.enabled = YES;
}

#pragma mark GADNativeAppInstallAdLoaderDelegate implementation

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAppInstallAd:(GADNativeAppInstallAd *)nativeAppInstallAd {
    NSLog(@"Received native app install ad: %@", nativeAppInstallAd);
    self.btnRefreshAd.enabled = YES;
    
    GADNativeAppInstallAdView *appInstallAdView =
    [[NSBundle mainBundle] loadNibNamed:@"GoogleNativeAppInstallAdView" owner:nil options:nil].firstObject;
    
    [self setAdView:appInstallAdView];
    
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
        
        self.lblVideoStatus.text = @"Ad contains a video asset.";
    } else {
        // If the ad doesn't contain a video asset, the first image asset is shown in the
        // image view. The existing lower priority height constraint is used.
        appInstallAdView.mediaView.hidden = YES;
        appInstallAdView.imageView.hidden = NO;
        
        GADNativeAdImage *firstImage = nativeAppInstallAd.images.firstObject;
        ((UIImageView *)appInstallAdView.imageView).image = firstImage.image;
        
        self.lblVideoStatus.text = @"Ad does not contain a video.";
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
    NSLog(@"Received native content ad: %@", nativeContentAd);
    
    self.lblVideoStatus.text = @"Ad does not contain a video.";
    self.btnRefreshAd.enabled = YES;
    
    // Create and place ad in view hierarchy.
    GADNativeContentAdView *contentAdView =
    [[NSBundle mainBundle] loadNibNamed:@"GoogleNativeContentAdView" owner:nil options:nil].firstObject;
    [self setAdView:contentAdView];
    
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
    self.lblVideoStatus.text = @"Video playback has ended.";
}

@end
