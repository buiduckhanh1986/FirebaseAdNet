//
//  FacebookNativeAdViewController.h
//  RetechFirebase
//
//  Created by Bui Duc Khanh on 12/8/17.
//  Copyright © 2017 Bui Duc Khanh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@import FBAudienceNetwork;

@interface FacebookNativeAdViewController : UIViewController  <FBNativeAdDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgvIcon;
@property (strong, nonatomic) IBOutlet UILabel *lblAdTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSponsor;
@property (strong, nonatomic) IBOutlet UILabel *lblSocialContext;
@property (strong, nonatomic) IBOutlet UILabel *lblBody;
@property (strong, nonatomic) IBOutlet UIButton *btnAdAction;

@property (strong, nonatomic) IBOutlet UIView *viewAdUI;
@property (weak, nonatomic) IBOutlet FBMediaView *viewAdCover;
@property (weak, nonatomic) IBOutlet FBAdChoicesView *viewAdChoice;

@end
