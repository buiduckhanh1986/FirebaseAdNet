//
//  BootLogic.h
//  RetechFirebase
//
//  Created by Bui Duc Khanh on 12/5/17.
//  Copyright © 2017 Bui Duc Khanh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SECTION @"section"
#define MENU @"menu"
#define TITLE @"title"
#define CLASS @"class"

@interface BootLogic : NSObject
+ (void) boot: (UIWindow *) window;
@end
