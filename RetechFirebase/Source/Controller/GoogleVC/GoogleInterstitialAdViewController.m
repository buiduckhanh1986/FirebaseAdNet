//
//  GoogleInterstitialAdViewController.m
//  RetechFirebase
//
//  Created by Bui Duc Khanh on 3/21/18.
//  Copyright © 2018 Bui Duc Khanh. All rights reserved.
//

#import "GoogleInterstitialAdViewController.h"

@import GoogleMobileAds;

/// The game length.
static const NSInteger kGameLength = 5;

typedef NS_ENUM(NSUInteger, GameState) {
    kGameStateNotStarted = 0,  ///< Game has not started.
    kGameStatePlaying = 1,     ///< Game is playing.
    kGameStatePaused = 2,      ///< Game is paused.
    kGameStateEnded = 3        ///< Game has ended.
};

@interface GoogleInterstitialAdViewController () <UIAlertViewDelegate>

/// The interstitial ad.
@property(nonatomic, strong) GADInterstitial *interstitial;

/// The countdown timer.
@property(nonatomic, strong) NSTimer *timer;

/// The amount of time left in the game.
@property(nonatomic, assign) NSInteger timeLeft;

/// The state of the game.
@property(nonatomic, assign) GameState gameState;

/// The date that the timer was paused.
@property(nonatomic, strong) NSDate *pauseDate;

/// The last fire date before a pause.
@property(nonatomic, strong) NSDate *previousFireDate;

@end

@implementation GoogleInterstitialAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Pause game when application is backgrounded.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pauseGame)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    // Resume game when application becomes active.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resumeGame)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [self startNewGame];
}

#pragma mark Game logic

- (void)startNewGame {
    [self createAndLoadInterstitial];
    
    self.gameState = kGameStatePlaying;
    self.playAgainButton.hidden = YES;
    self.timeLeft = kGameLength;
    [self updateTimeLeft];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(decrementTimeLeft:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)createAndLoadInterstitial {
    self.interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:kGoogleAdmobInterstitialAdID];
    
    GADRequest *request = [GADRequest request];
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
    //request.testDevices = @[ kGADSimulatorID, @"2077ef9a63d2b398840261c8221a0c9a" ];
    [self.interstitial loadRequest:request];
}

- (void)updateTimeLeft {
    self.gameText.text = [NSString stringWithFormat:@"%ld seconds left!", (long)self.timeLeft];
}

- (void)decrementTimeLeft:(NSTimer *)timer {
    self.timeLeft--;
    [self updateTimeLeft];
    if (self.timeLeft == 0) {
        [self endGame];
    }
}

- (void)pauseGame {
    if (self.gameState != kGameStatePlaying) {
        return;
    }
    self.gameState = kGameStatePaused;
    
    // Record the relevant pause times.
    self.pauseDate = [NSDate date];
    self.previousFireDate = [self.timer fireDate];
    
    // Prevent the timer from firing while app is in background.
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)resumeGame {
    if (self.gameState != kGameStatePaused) {
        return;
    }
    self.gameState = kGameStatePlaying;
    
    // Calculate amount of time the app was paused.
    float pauseTime = [self.pauseDate timeIntervalSinceNow] * -1;
    
    // Set the timer to start firing again.
    [self.timer setFireDate:[NSDate dateWithTimeInterval:pauseTime sinceDate:self.previousFireDate]];
}

- (void)endGame {
    self.gameState = kGameStateEnded;
    [self.timer invalidate];
    self.timer = nil;
    [[[UIAlertView alloc]
      initWithTitle:@"Game Over"
      message:[NSString stringWithFormat:@"You lasted %ld seconds", (long)kGameLength]
      delegate:self
      cancelButtonTitle:@"Ok"
      otherButtonTitles:nil] show];
}

#pragma Interstitial button actions

- (IBAction)playAgain:(id)sender {
    [self startNewGame];
}

#pragma mark UIAlertViewDelegate implementation

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    } else {
        NSLog(@"Ad wasn't ready");
    }
    self.playAgainButton.hidden = NO;
}

#pragma mark dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}

@end
