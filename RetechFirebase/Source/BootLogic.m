//
//  BootLogic.m
//  RetechFirebase
//
//  Created by Bui Duc Khanh on 12/5/17.
//  Copyright © 2017 Bui Duc Khanh. All rights reserved.
//

#import "BootLogic.h"
#import "MainScreen.h"


@implementation BootLogic
+ (void) boot: (UIWindow*) window
{
    MainScreen* mainScreen = [[MainScreen alloc] initWithStyle:UITableViewStyleGrouped];
    //--------- From this line, please customize your menu data -----------
    NSDictionary* google = @{SECTION: @"Google", MENU: @[
                                    @{TITLE: @"Banner", CLASS: @"BasicA"},
                                    @{TITLE: @"Interstitial", CLASS: @"BasicB"},
                                    @{TITLE: @"Native Express", CLASS: @"BasicB"},
                                    @{TITLE: @"Native Advance", CLASS: @"GoogleNativeAdAdvanceViewController"},
                                    @{TITLE: @"Video", CLASS: @"BasicB"}
                                    ]};
    NSDictionary* facebook = @{SECTION: @"Facebook", MENU: @[
                                           @{TITLE: @"Inter B", CLASS: @"InterB"}
                                           ]};

    
    mainScreen.menu = @[google, facebook];
    mainScreen.title = @"Adnet";
    mainScreen.about = @"This is demo adnet app";
    //--------- End of customization -----------
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController: mainScreen];
    
    window.rootViewController = nav;
}
@end
