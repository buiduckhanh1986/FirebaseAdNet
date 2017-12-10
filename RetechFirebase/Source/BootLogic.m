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
    NSDictionary* google = @{SECTION: @"Google Admob", MENU: @[
                                    @{TITLE: @"Banner", CLASS: @"GoogleBannerAdViewController"},
                                    /*@{TITLE: @"Interstitial", CLASS: @"BasicB"},
                                    @{TITLE: @"Video", CLASS: @"BasicB"},*/
                                    @{TITLE: @"Native Express", CLASS: @"GoogleNativeAdExpressViewController"},
                                    @{TITLE: @"Native Advance", CLASS: @"GoogleNativeAdAdvanceViewController"}
                                    ]};
    NSDictionary* facebook = @{SECTION: @"Facebook Audience Network", MENU: @[
                                           @{TITLE: @"Banner", CLASS: @"FacebookBannerAdViewController"},
                                           @{TITLE: @"Native", CLASS: @"FacebookNativeAdViewController"}
                                           ]};
    NSMutableArray *menus = [NSMutableArray arrayWithCapacity:1];
    [menus addObject:google];
    [menus addObject:facebook];
    
    mainScreen.menu = [self loadRemoteConfig:menus]; //@[google, facebook];
    mainScreen.title = @"Adnet";
    mainScreen.about = @"This is demo adnet app";
    //--------- End of customization -----------
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController: mainScreen];
    
    window.rootViewController = nav;
}


+ (NSArray *)loadRemoteConfig :(NSMutableArray*) menus {
    // [START get_remote_config_instance]
    FIRRemoteConfig * remoteConfig = [FIRRemoteConfig remoteConfig];
    // [END get_remote_config_instance]
    
    // Create a Remote Config Setting to enable developer mode, which you can use to increase
    // the number of fetches available per hour during development. See Best Practices in the
    // README for more information.
    // [START enable_dev_mode]
    FIRRemoteConfigSettings *remoteConfigSettings = [[FIRRemoteConfigSettings alloc] initWithDeveloperModeEnabled:YES];
    remoteConfig.configSettings = remoteConfigSettings;
    // [END enable_dev_mode]
    
    // Set default Remote Config parameter values. An app uses the in-app default values until you
    // update any values that you want to change in the Firebase console. See Best Practices in the
    // README for more information.
    // [START set_default_values]
    [remoteConfig setDefaultsFromPlistFileName:@"FirebaseRemoteConfigDefault"];
    // [END set_default_values]
    
    long expirationDuration = 3600;
    // If your app is using developer mode, expirationDuration is set to 0, so each fetch will
    // retrieve values from the Remote Config service.
    if (remoteConfig.configSettings.isDeveloperModeEnabled) {
        expirationDuration = 0;
    }
    
    // [START fetch_config_with_callback]
    // TimeInterval is set to expirationDuration here, indicating the next fetch request will use
    // data fetched from the Remote Config service, rather than cached parameter values, if cached
    // parameter values are more than expirationDuration seconds old. See Best Practices in the
    // README for more information.
    [remoteConfig fetchWithExpirationDuration:expirationDuration completionHandler:^(FIRRemoteConfigFetchStatus status, NSError *error) {
        if (status == FIRRemoteConfigFetchStatusSuccess) {
            NSLog(@"Config fetched!");
        } else {
            NSLog(@"Config not fetched");
            NSLog(@"Error %@", error.localizedDescription);
        }
        
        // Update based on new param here
    }];
    // [END fetch_config_with_callback]
    
    
    NSString *admob = remoteConfig[kFirebaseRemoteConfig_google_admob].stringValue;
    NSString *audience = remoteConfig[kFirebaseRemoteConfig_facebook_audience_network].stringValue;
    
    if(![admob isEqualToString:@"1"])
    {
        [menus removeObjectAtIndex:0];
    }
    
    if(![audience isEqualToString:@"1"])
    {
        [menus removeLastObject];
    }
    
    return [menus copy];
}
@end
