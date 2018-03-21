//
//  GoogleInterstitialAdViewController.h
//  RetechFirebase
//
//  Created by Bui Duc Khanh on 3/21/18.
//  Copyright © 2018 Bui Duc Khanh. All rights reserved.
//
#import "Config.h"
#import <UIKit/UIKit.h>

@interface GoogleInterstitialAdViewController : UIViewController
@property(nonatomic, weak) IBOutlet UILabel *gameText;

/// The play again button.
@property(nonatomic, weak) IBOutlet UIButton *playAgainButton;

/// Starts a new game. Shows an interstitial if it's ready.
- (IBAction)playAgain:(id)sender;
@end
