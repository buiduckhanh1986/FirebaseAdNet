//
//  GoogleRewardVideoAdViewController.h
//  RetechFirebase
//
//  Created by Bui Duc Khanh on 3/21/18.
//  Copyright © 2018 Bui Duc Khanh. All rights reserved.
//
#import "Config.h"

#import <UIKit/UIKit.h>

@interface GoogleRewardVideoAdViewController : UIViewController

@property(weak, nonatomic) IBOutlet UILabel *gameLabel;

/// The play again button.
@property(weak, nonatomic) IBOutlet UIButton *playAgainButton;

/// The button to show rewarded video.
@property(weak, nonatomic) IBOutlet UIButton *showVideoButton;

/// The text indicating current coin count.
@property(weak, nonatomic) IBOutlet UILabel *coinCountLabel;

/// Restarts the game.
- (IBAction)playAgain:(id)sender;

/// Shows a rewarded video.
- (IBAction)showVideo:(id)sender;

/// Pauses the game.
- (void)pauseGame;

/// Resumes the game.
- (void)resumeGame;
@end
