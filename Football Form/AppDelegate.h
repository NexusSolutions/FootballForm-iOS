//
//  AppDelegate.h
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKRevealInterface.h"
#import "PKRevealController.h"
#import "FootballFormDB.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, PKRevealing> {
    BOOL shouldShow;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readwrite) PKRevealController *revealController;

@end
