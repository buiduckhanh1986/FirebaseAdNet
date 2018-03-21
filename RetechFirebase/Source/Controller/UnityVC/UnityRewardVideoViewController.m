//
//  UnityRewardVideoViewController.m
//  RetechFirebase
//
//  Created by Bui Duc Khanh on 3/19/18.
//  Copyright © 2018 Bui Duc Khanh. All rights reserved.
//

#import "UnityRewardVideoViewController.h"

@interface UnityRewardVideoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnVideoSkip;
@property (weak, nonatomic) IBOutlet UIButton *btnVideoNoSkip;

@property (copy, nonatomic) NSString* videoSkipPlacementID;
@property (copy, nonatomic) NSString* videoNoSkipPlacementID;
@end

@implementation UnityRewardVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Unity Reward Video";
    
    [self initializeUnityGUITest];

}

- (void)initializeUnityGUITest {
    self.videoSkipPlacementID = @"video";
    self.videoNoSkipPlacementID = @"rewardedVideo";
    BOOL isInitialize = true;
    
    if ([UnityAds isReady:self.videoSkipPlacementID]) {
        isInitialize = false;
        
        self.btnVideoSkip.enabled = YES;
        self.btnVideoSkip.backgroundColor = [UIColor colorWithRed:0.13 green:0.59 blue:0.95 alpha:1.0];
    }
    else{
        self.btnVideoSkip.enabled = NO;
        self.btnVideoSkip.backgroundColor = [UIColor colorWithRed:0.13 green:0.17 blue:0.22 alpha:0.8];
    }
    
    if ([UnityAds isReady:self.videoNoSkipPlacementID]) {
        isInitialize = false;
        
        self.btnVideoNoSkip.enabled = YES;
        self.btnVideoNoSkip.backgroundColor = [UIColor colorWithRed:0.13 green:0.59 blue:0.95 alpha:1.0];
    }
    else{
        self.btnVideoNoSkip.enabled = NO;
        self.btnVideoNoSkip.backgroundColor = [UIColor colorWithRed:0.13 green:0.17 blue:0.22 alpha:0.8];
    }
    
    if (isInitialize)
        [self initializeUnityAd];
}


- (IBAction)btnVideoNoSkipTouchUpInside:(id)sender {
    if ([UnityAds isReady:self.videoNoSkipPlacementID]) {
        self.btnVideoNoSkip.enabled = NO;
        UADSPlayerMetaData *playerMetaData = [[UADSPlayerMetaData alloc] init];
        [playerMetaData setServerId:@"rikshot"];
        [playerMetaData commit];
        
        UADSMediationMetaData *mediationMetaData = [[UADSMediationMetaData alloc] init];
        [mediationMetaData setOrdinal:kUnityMediationOrdinal++];
        [mediationMetaData commit];
        
        [UnityAds show:self placementId:self.videoNoSkipPlacementID];
    }
}

- (IBAction)btnVideoSkipTouchUpInside:(id)sender {
    if ([UnityAds isReady:self.videoSkipPlacementID]) {
        self.btnVideoSkip.enabled = NO;
        UADSPlayerMetaData *playerMetaData = [[UADSPlayerMetaData alloc] init];
        [playerMetaData setServerId:@"rikshot"];
        [playerMetaData commit];
        
        UADSMediationMetaData *mediationMetaData = [[UADSMediationMetaData alloc] init];
        [mediationMetaData setOrdinal:kUnityMediationOrdinal++];
        [mediationMetaData commit];
        
        [UnityAds show:self placementId:self.videoSkipPlacementID];
    }
}

- (void)initializeUnityAd {
    // mediation
    UADSMediationMetaData *mediationMetaData = [[UADSMediationMetaData alloc] init];
    [mediationMetaData setName:@"mediationPartner"];
    [mediationMetaData setVersion:@"v12345"];
    [mediationMetaData commit];
    
    UADSMetaData *debugMetaData = [[UADSMetaData alloc] init];
    [debugMetaData set:@"test.debugOverlayEnabled" value:@YES];
    [debugMetaData commit];

    
    [UnityAds setDebugMode:true];
    
    [UnityAds initialize:kUnityGameId delegate:self testMode:kUnityTestMode];
}

- (void)unityAdsReady:(NSString *)placementId {
    NSLog(@"UADS Ready");
    
    if ([placementId isEqualToString:@"video"] || [placementId isEqualToString:@"defaultZone"] || [placementId isEqualToString:@"defaultVideoAndPictureZone"]) {
        self.videoSkipPlacementID = placementId;
        self.btnVideoSkip.enabled = YES;
        self.btnVideoSkip.backgroundColor = [UIColor colorWithRed:0.13 green:0.59 blue:0.95 alpha:1.0];
    }
    if ([placementId isEqualToString:@"rewardedVideo"] || [placementId isEqualToString:@"rewardedVideoZone"] || [placementId isEqualToString:@"incentivizedZone"]) {
        self.videoNoSkipPlacementID = placementId;
        self.btnVideoNoSkip.enabled = YES;
        self.btnVideoNoSkip.backgroundColor = [UIColor colorWithRed:0.13 green:0.59 blue:0.95 alpha:1.0];
    }
}

- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message {
    NSLog(@"UnityAds ERROR: %ld - %@",(long)error, message);
    if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_8_0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"UnityAds Error" message:[NSString stringWithFormat:@"%ld - %@",(long)error, message] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)unityAdsDidStart:(NSString *)placementId {
    NSLog(@"UADS Start");
    
}

- (void)unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state {
    NSString *stateString = @"UNKNOWN";
    switch (state) {
        case kUnityAdsFinishStateError:
            stateString = @"ERROR";
            break;
        case kUnityAdsFinishStateSkipped:
            stateString = @"SKIPPED";
            break;
        case kUnityAdsFinishStateCompleted:
            stateString = @"COMPLETED";
            break;
        default:
            break;
    }
    NSLog(@"UnityAds FINISH: %@ - %@", stateString, placementId);
}

@end
