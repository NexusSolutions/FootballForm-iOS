//
//  AppDelegate.m
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import "AppDelegate.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"shouldShowUpdateModal"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.revealController = [PKRevealController revealControllerWithFrontViewController:[storyboard instantiateInitialViewController] leftViewController:[self leftVCiPhone]];
    self.revealController.delegate = self;
    self.revealController.animationDuration = 0.25;
    
    self.window.rootViewController = self.revealController;
    
    [self.window makeKeyAndVisible];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    } else {
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
        
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    if (!url) {
        return NO;
    }
    
    NSString *URLString = [url absoluteString];
    
    [[NSUserDefaults standardUserDefaults]setObject:URLString forKey:@"FootballForm:OpenURL"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    NSString *devTok = [NSString stringWithFormat:@"%@", deviceToken];
    devTok = [devTok stringByReplacingOccurrencesOfString:@" " withString:@""];
    devTok = [devTok stringByReplacingOccurrencesOfString:@"<" withString:@""];
    devTok = [devTok stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSLog(@"My token is: %@", devTok);
    
    [[NSUserDefaults standardUserDefaults]setObject:devTok forKey:@"deviceToken"];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
    //I've reversed it as we have no way to set it in the first place
    if (!shouldShow) {
    
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoToLiveScores"
         object:self];
            
        shouldShow = YES;
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reset) userInfo:nil repeats:NO];
        
    }
}


-(void)reset {
    shouldShow = NO;
}

/*
- (void)revealController:(PKRevealController *)revealController willChangeToState:(PKRevealControllerState)next {
    //PKRevealControllerState current = revealController.state;
    
    if ((int)next==3) {
        
        
    }
}
 */

- (UIViewController *)leftVCiPhone
{
    UIViewController *leftViewController = [[PKRevealInterface alloc] init];
    
    return leftViewController;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    NSMutableArray *mutAr = [[FootballFormDB sharedInstance] getFavouritesInLeagueTableForTempSaving];
    
    if (mutAr.count>0) {
        [[NSUserDefaults standardUserDefaults]setObject:mutAr forKey:@"FootballForm:FavouriteTeams"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
