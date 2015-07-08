//
//  API.m
//  Alert5FireAndRescue
//
//  Created by Aaron Wilkinson on 18/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import "API.h"
#import "AFJSONRequestOperation.h"

#define kAPIURI     @"http://footballform.createaclients.co.uk"
#define kAPIKey     @"dfd-sdh-fj--dfj--d-s-sd-sd-st-hsfg-jsf-sfgh-sf-5r-h-se-h-dsth-td"


/*
 #define kAPISalt    @"Laj82Pq9"
 #define kAuthUser   @"CreateAnAPI"
 #define kAuthPass   @"pvD}OI3}s{X6"
 */



@implementation API
@synthesize currentViewController = _currentViewController;
@synthesize lastResponse;



+ (API *)sharedAPI{
    static API *sharedAPI = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAPI = [[API alloc] initWithBaseURL:[NSURL URLWithString:kAPIURI]];
    });
    
    return sharedAPI;
}


-(id)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    
    
    if (self) {
        NSString *email = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
        NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_password"];
        
        
        [self setDefaultHeader:@"x-api-key" value:kAPIKey];
        [self setAuthorizationHeaderWithUsername:email password:password];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        //[self setParameterEncoding:(AFJSONParameterEncoding)];
    }
    
    return self;
}

+ (void)sendPayload:(NSDictionary *)payload toPath:(NSString *)path withLoadingMessage:(NSString *)loadingMessage complete:(void (^)(id JSON))complete failed:(void (^)(id))failed{
    UIAlertView *errorView;
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    NetworkStatus internetStatus = [reach currentReachabilityStatus];
    
    if(internetStatus == NotReachable) {
        errorView = [[UIAlertView alloc]
                     initWithTitle: @"No Internet Connection"
                     message: @"It doesn't look like you have an active internet connection. Please connect to the internet to continue."
                     delegate: self
                     cancelButtonTitle: @"OK" otherButtonTitles: nil];
        
        [errorView show];
        return;
        
    }
    
    UIViewController *vc = [[API sharedAPI] getCurrentViewController];
    
    if(loadingMessage != nil){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
        [hud setLabelText:loadingMessage];
        [hud setDetailsLabelText:@"Please Wait..."];
        [hud removeFromSuperViewOnHide];
    }
    
    [[API sharedAPI]getPath:path parameters:payload success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        [MBProgressHUD hideHUDForView:vc.view animated:YES];
        [[API sharedAPI] setLastResponse:JSON];
        
        // Remove current view controller
        [[API sharedAPI] setCurrentViewController:nil];
        
        NSDictionary *returnData = (NSDictionary *)JSON;
        
        // Check for an error with the request
        if([[returnData objectForKey:@"response"] isEqualToString:@"Error"]){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[returnData objectForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            if(failed != nil) failed(JSON);
            
        }else{
            
            if(complete != nil) complete(JSON);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        if(failed != nil) failed(error);
        
        [MBProgressHUD hideHUDForView:vc.view animated:YES];
        
        [[API sharedAPI] setCurrentViewController:nil];
    }];

}

/*
+ (void)getLiveScores:(NSString *)type
       complete:(void (^)(NSDictionary *userData))complete
         failed:(void (^)(id JSON))failed {
    
    NSString *selectedLeague = [[NSUserDefaults standardUserDefaults]objectForKey:@"leagueID"];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            type,     @"type",
                            selectedLeague, @"league_id",
                            nil];
    
    [API sendPayload:params toPath:@"/api/v2/live_scores_api.php" withLoadingMessage:@"Loading Live Scores" complete:complete failed:failed];
    
}
 */


+ (void)getLiveScores:(NSString *)type
             complete:(void (^)(NSDictionary *userData))complete
               failed:(void (^)(id JSON))failed {
    
    NSString *selectedLeague = [[NSUserDefaults standardUserDefaults]objectForKey:@"countryID"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            type,     @"type",
                            selectedLeague, @"league_id",
                            @"Y", @"should_show_no_results_as_success",
                            nil];
    
    [API sendPayload:params toPath:@"/api/v2/live_scores_api_country_id.php" withLoadingMessage:@"Loading Live Scores" complete:complete failed:failed];
    
}

+ (void)addTeamForPushNotifications:(NSString *)teamId
             complete:(void (^)(NSDictionary *userData))complete
               failed:(void (^)(id JSON))failed {
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            deviceToken,     @"deviceToken",
                            teamId, @"teamId",
                            nil];
    
    [API sendPayload:params toPath:@"/api/v2/register_team_for_push_notifications.php" withLoadingMessage:nil complete:complete failed:failed];
    
    
}
/*
+ (void)getLiveScoresWithoutSpinner:(NSString *)type
             complete:(void (^)(NSDictionary *userData))complete
               failed:(void (^)(id JSON))failed {
    
    NSString *selectedLeague = [[NSUserDefaults standardUserDefaults]objectForKey:@"leagueID"];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            type,     @"type",
                            selectedLeague, @"league_id",
                            nil];
    
    [API sendPayload:params toPath:@"/api/v2/live_scores_api.php" withLoadingMessage:nil complete:complete failed:failed];
    
}
*/

+ (void)getLiveScoresWithoutSpinner:(NSString *)type
                           complete:(void (^)(NSDictionary *userData))complete
                             failed:(void (^)(id JSON))failed {
    
    NSString *selectedLeague = [[NSUserDefaults standardUserDefaults]objectForKey:@"countryID"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            type,     @"type",
                            selectedLeague, @"league_id",
                            nil];
    
    [API sendPayload:params toPath:@"/api/v2/live_scores_api_country_id.php" withLoadingMessage:nil complete:complete failed:failed];
    
}

//countryID
+ (void)getLiveScoresData:(NSString *)type
                  matchID:(NSString *)matchID
             complete:(void (^)(NSDictionary *userData))complete
               failed:(void (^)(id JSON))failed {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            type,     @"type",
                            matchID,   @"match_id",
                            nil];
    
    [API sendPayload:params toPath:@"/api/v2/live_scores_api.php" withLoadingMessage:@"Loading" complete:complete failed:failed];
    
    
}

@end
