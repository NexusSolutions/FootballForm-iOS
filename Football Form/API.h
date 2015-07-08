//
//  API.h
//  Football Form
//
//  Created by Aaron Wilkinson on 29/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@interface API : AFHTTPClient {
    MBProgressHUD *huddy;
}

@property (strong, nonatomic, getter=getCurrentViewController) UIViewController *currentViewController;
@property (strong, nonatomic) id lastResponse;


+ (void)sendPayload:(NSDictionary *)payload toPath:(NSString *)path withLoadingMessage:(NSString *)loadingMessage complete:(void (^)(id JSON))complete failed:(void (^)(id JSON))failed;

- (UIViewController *)getCurrentViewController; // Unsafe if no current view controller is set!!


+ (API *)sharedAPI;

+ (void)getLiveScores:(NSString *)type
             complete:(void (^)(NSDictionary *userData))complete
               failed:(void (^)(id JSON))failed;

+ (void)getLiveScoresWithoutSpinner:(NSString *)type
             complete:(void (^)(NSDictionary *userData))complete
               failed:(void (^)(id JSON))failed;

+ (void)getLiveScoresData:(NSString *)type
                  matchID:(NSString *)matchID
                 complete:(void (^)(NSDictionary *userData))complete
                   failed:(void (^)(id JSON))failed;

+ (void)addTeamForPushNotifications:(NSString *)teamId
                           complete:(void (^)(NSDictionary *userData))complete
                             failed:(void (^)(id JSON))failed;

@end