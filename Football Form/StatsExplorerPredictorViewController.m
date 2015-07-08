//
//  StatsExplorerPredictorViewController.m
//  Football Form
//
//  Created by Aaron Wilkinson on 06/12/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import "StatsExplorerPredictorViewController.h"
#import "FootballFormDB.h"
#import <iAd/iAd.h>
@interface StatsExplorerPredictorViewController ()

@end

@implementation StatsExplorerPredictorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    self.canDisplayBannerAds = YES;
    
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    // Then your code...
    
    [self checkRotation];

}

-(void)viewDidAppear:(BOOL)animated {
    [self checkRotation];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkRotation) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkRotation) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(checkRotation) userInfo:nil repeats:NO];

}


-(void)checkRotation {
    
    if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        
        UIFont *font = [UIFont systemFontOfSize:10.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [segControlOne setTitleTextAttributes:attributes
                                     forState:UIControlStateNormal];
        
        [segControlTwo setTitleTextAttributes:attributes
                                     forState:UIControlStateNormal];
        
        [titLabel setFrame:CGRectMake(40, titLabel.frame.origin.y, titLabel.frame.size.width, titLabel.frame.size.height)];

        
    } else {
        
        UIFont *font = [UIFont systemFontOfSize:13.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [segControlOne setTitleTextAttributes:attributes
                                     forState:UIControlStateNormal];
        
        [segControlTwo setTitleTextAttributes:attributes
                                     forState:UIControlStateNormal];
        
        [titLabel setFrame:CGRectMake(self.view.center.x-titLabel.frame.size.width/2, titLabel.frame.origin.y, titLabel.frame.size.width, titLabel.frame.size.height)];
        
    }
    
    float centreImageWidth = 80;
    float width = (self.view.frame.size.width-centreImageWidth)/2;
    float rightX = width+centreImageWidth;
    
    
    [_leftView setFrame:CGRectMake(0, _leftView.frame.origin.y, width, _leftView.frame.size.height)];
    [_rightView setFrame:CGRectMake(rightX, _rightView.frame.origin.y, width, _rightView.frame.size.height)];
    
    [entirePickerView setFrame:CGRectMake(entirePickerView.frame.origin.x, entirePickerView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];

}

-(void)viewDidDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"FootballForm:PKWillRefresh" object:nil];

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self setUpTabBar];
    
    if (teamOneHomeGames==nil) {
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Loading";
        HUD.square = YES;
        [HUD show:YES];
    
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(actuallyLoad) userInfo:nil repeats:NO];
        
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    
    [revealController setRecognizesPanningOnFrontView:YES];
    
    //Listen for NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(back:)
                                                 name:@"FootballForm:PKWillRefresh"
                                               object:nil];
}

-(NSString *) addSuffixToNumber:(int) number
{
    NSString *suffix;
    int ones = number % 10;
    int temp = floor(number/10.0);
    int tens = temp%10;
    
    if (tens ==1) {
        suffix = @"th";
    } else if (ones ==1){
        suffix = @"st";
    } else if (ones ==2){
        suffix = @"nd";
    } else if (ones ==3){
        suffix = @"rd";
    } else {
        suffix = @"th";
    }
    
    NSString *completeAsString = [NSString stringWithFormat:@"%d%@",number,suffix];
    return completeAsString;
}


-(void)actuallyLoad {
    
    //Here we are setting up the number of games pickerview
    amountOfGames = @"3";
    amountOfGamesArray = @[@"3 Games", @"5 Games", @"10 Games"];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"All Points" forKey:@"gameTypeStatsToGraphOne"];
    [[NSUserDefaults standardUserDefaults]setObject:@"All Points" forKey:@"gameTypeStatsToGraphTwo"];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@ Games", amountOfGames] forKey:@"noOfGamesStatsToGraph"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [entirePickerView setAlpha:0.0];
    [entirePickerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [picker reloadAllComponents];
    
    //Here's the data set up //sshsshssh
    teamOneData = [[FootballFormDB sharedInstance]getTeamDataFromID:[[NSUserDefaults standardUserDefaults]objectForKey:@"statsExplorerTeamOneID"]];
    teamTwoData = [[FootballFormDB sharedInstance]getTeamDataFromID:[[NSUserDefaults standardUserDefaults]objectForKey:@"statsExplorerTeamTwoID"]];
    
    if ([teamOneData count]==0||[teamTwoData count]==0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stats Predictor" message:@"Unfortunately no stats are available for these teams." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setTag:1992];
        [alert show];
        return;
        
    }
    
    if(teamOneData.count>0) {
        NSString *teamOnePosition = [[teamOneData objectAtIndex:0]objectForKey:@"position"];
        if (teamOnePosition.length > 0) {
            if ([teamOnePosition isEqualToString:@"0"]) {
                [_homeTeamPositionInLeagueTable setText:@""];
            } else {
                [_homeTeamPositionInLeagueTable setText:[NSString stringWithFormat:@"%@ in league table", [self addSuffixToNumber:teamOnePosition.intValue]]];
            }
        } else {
            [_homeTeamPositionInLeagueTable setText:@""];
        }
    }
    
    if(teamTwoData.count>0) {
        NSString *teamTwoPosition = [[teamTwoData objectAtIndex:0]objectForKey:@"position"];
        if (teamTwoPosition.length > 0) {
            if ([teamTwoPosition isEqualToString:@"0"]) {
                [_awayTeamPositionInLeagueTable setText:@""];
            } else {
                [_awayTeamPositionInLeagueTable setText:[NSString stringWithFormat:@"%@ in league table", [self addSuffixToNumber:teamTwoPosition.intValue]]];
            }
        } else {
            [_awayTeamPositionInLeagueTable setText:@""];
        }
    }

    
    NSString *onetn = [[teamOneData objectAtIndex:0]objectForKey:@"teamName"];
    onetn = [onetn stringByReplacingOccurrencesOfString:@"AMP;" withString:@""];
    
    NSString *twotn = [[teamTwoData objectAtIndex:0]objectForKey:@"teamName"];
    twotn = [twotn stringByReplacingOccurrencesOfString:@"AMP;" withString:@""];
    
    [_teamOne setText: onetn];
    [_teamTwo setText: twotn];
    
    NSString *logName = [[teamOneData objectAtIndex:0]objectForKey:@"logoID"];
    logName = [logName stringByReplacingOccurrencesOfString:@"NULL" withString:@"default"];
    [_teamOneLogo setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", logName]]];
    
    NSString *logName2 = [[teamTwoData objectAtIndex:0]objectForKey:@"logoID"];
    logName2 = [logName2 stringByReplacingOccurrencesOfString:@"NULL" withString:@"default"];
    [_teamTwoLogo setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", logName2]]];
    
    teamOneID = [[teamOneData objectAtIndex:0]objectForKey:@"id"];
    teamTwoID = [[teamTwoData objectAtIndex:0]objectForKey:@"id"];
    
    leagueI = _statsLeagueID;
    
    teamOneHomeGames = [[FootballFormDB sharedInstance]statsExplorerGetGamesForBothTeam:teamOneID andAmountOfGames:amountOfGames lid:leagueI];
    teamTwoHomeGames = [[FootballFormDB sharedInstance]statsExplorerGetGamesForBothTeam:teamTwoID andAmountOfGames:amountOfGames lid:leagueI];
    
    allHomeOrAwayTeamOne = @"0";
    allHomeOrAwayTeamTwo = @"0";
    
    [tableView1 reloadData];
    [tableView2 reloadData];
    
    /*
    [self workOutThePointsTeamOne];
    [self workOutThePointsTeamTwo];
    [self workOutWhoStarBelongsTo];
     */
    
    [segControlOne setSelectedSegmentIndex:0];
    [segControlTwo setSelectedSegmentIndex:2];
    
    [self refreshTeamOneData];
    [self refreshTeamTwoData];
    
    [self workOutWhoStarBelongsTo];
    
    
    /*
    int width;
    if (IS_IPHONE5) {
        width = 283;
        
        [tableView1 setFrame:CGRectMake(0, 113, width, 124)];
        [tableView2 setFrame:CGRectMake(283, 113, width, 124)];
        
    } else {
        width = 239;
        
        [homeStar setFrame:CGRectMake(48, 2, 27, 27)];
        [_totalPoints1 setFrame:CGRectMake(47, 6, 231, 21)];
        [_totalPoints2 setFrame:CGRectMake(2, 5, 231, 21)];
        [awayStar setFrame:CGRectMake(198, 2, 27, 27)];
        
        [tpv1 setFrame:CGRectMake(-35, tpv1.frame.origin.y, tpv1.frame.size.width, tpv1.frame.size.height)];
        [tpv2 setFrame:CGRectMake(250, tpv1.frame.origin.y, tpv2.frame.size.width, tpv2.frame.size.height)];
     
        [_teamOneLogo setFrame:CGRectMake(6, 1, 27, 27)];
        [_teamOne setFrame:CGRectMake(41, 2, 172, 26)];
        [segControlOne setFrame:CGRectMake(6, 32, 185, 29)];
        [compGrOut setFrame:CGRectMake(207, -5, 71, 62)];
        [_teamTwo setFrame:CGRectMake(270, 2, 169, 26)];
        [_teamTwoLogo setFrame:CGRectMake(448, 1, 27, 27)];
        [segControlTwo setFrame:CGRectMake(291, 32, 185, 29)];
        [GRrrr setFrame:CGRectMake(210, 45, 73, 15)];
        
        [titLabel setFrame:CGRectMake(128, 11, 195, 21)];
        
        [noGameLab setFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.height-noGameLab.frame.size.width)-15, noGameLab.frame.origin.y, noGameLab.frame.size.width, noGameLab.frame.size.height)];
        [closeButty setFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.height-closeButty.frame.size.width)-15, closeButty.frame.origin.y, closeButty.frame.size.width, closeButty.frame.size.height)];
        
        [picker setFrame:CGRectMake(picker.frame.origin.x, picker.frame.origin.y, [[UIScreen mainScreen] bounds].size.height, picker.frame.size.height)];
        
        [tableView1 setFrame:CGRectMake(0, 113, width, 124)];
        [tableView2 setFrame:CGRectMake(241, 113, width, 124)];
        
    }
    */
    
    [self hideHud];
}

-(void)workOutGoals {
    
    int totalHomeGoals = 0;
    int totalAwayGoals = 0;
    
    for (NSDictionary *games in teamOneHomeGames) {
        
        NSString *teamAwayID = games[@"team_away_id"];
        NSString *teamHomeID = games[@"team_home_id"];
        
        NSString *homeGames = games[@"team_home_score"];
        NSString *awayGames = games[@"team_away_score"];
        
        if([teamOneID isEqualToString:teamHomeID]) {
            totalHomeGoals = totalHomeGoals+homeGames.intValue;
        } else if([teamOneID isEqualToString:teamAwayID]) {
            totalHomeGoals = totalHomeGoals+awayGames.intValue;
        }
        
    }

    
    for (NSDictionary *games in teamTwoHomeGames) {
        
        NSString *teamAwayID = games[@"team_away_id"];
        NSString *teamHomeID = games[@"team_home_id"];
        
        NSString *homeGames = games[@"team_home_score"];
        NSString *awayGames = games[@"team_away_score"];
        
        if([teamTwoID isEqualToString:teamHomeID]) {
            totalAwayGoals = totalAwayGoals+homeGames.intValue;
        } else if([teamTwoID isEqualToString:teamAwayID]) {
            totalAwayGoals = totalAwayGoals+awayGames.intValue;
        }
        
    }
    
    [_lblTotalGoalsHome setText:[NSString stringWithFormat:@"Total Goals: %d", totalHomeGoals]];
    [_lblTotalGoalsAway setText:[NSString stringWithFormat:@"Total Goals: %d", totalAwayGoals]];
    
    
    if (totalAwayGoals > totalHomeGoals) {
        //star belongs to team 2
        _imgTotalGoalsHomeStar.hidden=1;
        _imgTotalGoalsAwayStar.hidden=0;
    } else if (totalHomeGoals > totalAwayGoals) {
        //star belongs to 1
        _imgTotalGoalsHomeStar.hidden=0;
        _imgTotalGoalsAwayStar.hidden=1;
    } else {
        //they must have drawn, so lets hide the stars.
        _imgTotalGoalsHomeStar.hidden=1;
        _imgTotalGoalsAwayStar.hidden=1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        return 65;
    } else {
        return 38;
    }
    
}

-(void)setUpTabBar {
    
    [self.tabBarController.tabBar setHidden:YES];
    [self.tabBarController.tabBar removeFromSuperview];
    
    UITabBarItem *fixtures = [[UITabBarItem alloc] initWithTitle:@"Fixtures" image:[UIImage imageNamed:@"tabicons1Fixtures.png"] tag:1];
    UITabBarItem *Leagues = [[UITabBarItem alloc] initWithTitle:@"Leagues" image:[UIImage imageNamed:@"tabicons2Leagues.png"] tag:2];
    UITabBarItem *playerVs = [[UITabBarItem alloc]initWithTitle:@"Player Vs" image:[UIImage imageNamed:@"tabicons3PlayerVs.png"] tag:3];
    UITabBarItem *formPlayers = [[UITabBarItem alloc]initWithTitle:@"Form Players" image:[UIImage imageNamed:@"tabicons4FormPlayers.png"] tag:4];
    UITabBarItem *statsExplorer = [[UITabBarItem alloc]initWithTitle:@"Live Scores" image:[UIImage imageNamed:@"tabicons5Stats.png"] tag:5];
    UITabBarItem *favourites = [[UITabBarItem alloc]initWithTitle:@"Favourites" image:[UIImage imageNamed:@"tabicons6Fav.png"] tag:6];
    UITabBarItem *compare = [[UITabBarItem alloc]initWithTitle:@"More" image:[UIImage imageNamed:@"tabicons7Compare.png"] tag:7];
    
    [_tabBar setItems:@[Leagues, fixtures, playerVs, formPlayers, statsExplorer, favourites, compare]animated:NO];
    
    
    [_tabBar setSelectedItem:fixtures];
    
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    
    if (item.tag==1) {
        /*
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoToFixtures"
         object:self];
        */
    } else if (item.tag==2) {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoToLeagues"
         object:self];
        
    } else if (item.tag==3) {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoPlayerVs"
         object:self];
        
    } else if (item.tag==4) {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoToFormPlayers"
         object:self];
        
    } else if (item.tag==5) {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoToLiveScores"
         object:self];
        
    } else if (item.tag==6) {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoFavourites"
         object:self];
        
    } else if (item.tag==7) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
        [revealController showViewController:revealController.leftViewController];
        
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPicker:(id)sender {
    
    NSString *onTrial = [[NSUserDefaults standardUserDefaults]objectForKey:@"FootballForm:CanAccessNoOfGamesInAppThanksToTrial"];
    
    if (!onTrial) {
    
        NSString *hasPaid = [[NSUserDefaults standardUserDefaults]objectForKey:@"hasBroughtInAppPurchase"];
        
        if (![hasPaid isEqualToString:@"YES"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"In App Purchase" message:@"To be able to filter by the number of games, an In-App purchase of £1.49 is required." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel", @"Restore", @"Purchase", nil];
            [alert show];
            [alert setTag:9012];
            
        } else {
            
            self.canDisplayBannerAds = NO;
                
            [UIView animateWithDuration:0.4 animations:^{
                [entirePickerView setAlpha:1.0];
            }];
            
        }
        
    } else {
        
        self.canDisplayBannerAds = NO;
        
        [UIView animateWithDuration:0.4 animations:^{
            [entirePickerView setAlpha:1.0];
        }];
    }
}


-(void)showPickerJustPaid {

    [UIView animateWithDuration:0.4 animations:^{
        [entirePickerView setAlpha:1.0];
    }];

    self.canDisplayBannerAds = NO;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag==1992) {
        
        [self back:nil];
        
    } else if (alertView.tag==9012) {
        
        if (buttonIndex == 1||buttonIndex == 2) {
            
            if ([SKPaymentQueue canMakePayments]) {
                
                HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [HUD setMode:MBProgressHUDModeIndeterminate];
                [HUD setDetailsLabelText:@"Loading..."];
                [HUD show:YES];//
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(makeRequest) userInfo:nil repeats:NO];
                
                
            } else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"In App Purchase" message:@"We are unable to take an In-App Purchase from this device. Please ensure that parental controls aren't enabled." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
        }
    }
}

-(void)makeRequest {
    
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"FF150129012014"]];
    
    request.delegate = self;
    
    [request start];
    
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    
    SKProduct *validProduct = nil;
    
    int count = [response.products count];
    
    
    
    if (count>0) {
        
        validProduct = [response.products objectAtIndex:0];
        
        
        
        SKPayment *payment = [SKPayment paymentWithProduct:validProduct];
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        
        [[SKPaymentQueue defaultQueue] addPayment:payment]; // <-- KA CHING!
        
        

        
    } else {
        
        UIAlertView *tmp = [[UIAlertView alloc]
                            
                            initWithTitle:@"Not Available"
                            
                            message:@"No products to purchase"
                            
                            delegate:self
                            
                            cancelButtonTitle:nil
                            
                            otherButtonTitles:@"Ok", nil];  
        
        [tmp show];
        
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hideHud) userInfo:nil repeats:NO];
        
        
    }
    
    
    
}

-(void)hideHud {
    
    [HUD removeFromSuperview];
    
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                
                break;
                
            case SKPaymentTransactionStatePurchased:
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"hasBroughtInAppPurchase"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self showPickerJustPaid];
                
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hideHud) userInfo:nil repeats:NO];
                
                break;
                
            case SKPaymentTransactionStateRestored:
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"hasBroughtInAppPurchase"];
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hideHud) userInfo:nil repeats:NO];

                break;
                
            case SKPaymentTransactionStateFailed:
                
                if (transaction.error.code != SKErrorPaymentCancelled) {
                    NSLog(@"Error payment cancelled");
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"In App Purchase" message:@"There was a problem with your purchase. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hideHud) userInfo:nil repeats:NO];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
               
                
                break;
                
            default:
                break;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (tableView == tableView1) {
        
        
        NSArray *arrayGoalScorers = [[FootballFormDB sharedInstance]getGoalScorersPerMatchID:[[teamOneHomeGames objectAtIndex:indexPath.row] objectForKey:@"fixture_id"]];
        NSArray *yellCards =  [[FootballFormDB sharedInstance]getYellowCardsFromMatchID:[[teamOneHomeGames objectAtIndex:indexPath.row] objectForKey:@"fixture_id"]];
        NSArray *redCards =  [[FootballFormDB sharedInstance]getRedCardsFromMatchID:[[teamOneHomeGames objectAtIndex:indexPath.row] objectForKey:@"fixture_id"]];
        NSArray *linups = [[FootballFormDB sharedInstance]getLineUpsPerMatchID:[[teamOneHomeGames objectAtIndex:indexPath.row] objectForKey:@"fixture_id"]];
        
        if (arrayGoalScorers.count==0&&yellCards.count==0&&redCards.count==0&&linups.count==0) {
            return;
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:[[teamOneHomeGames objectAtIndex:indexPath.row] objectForKey:@"fixture_id"] forKey:@"fixtureIDCarried"];
        
        
    } else if (tableView == tableView2) {
        
        
        NSArray *arrayGoalScorers = [[FootballFormDB sharedInstance]getGoalScorersPerMatchID:[[teamTwoHomeGames objectAtIndex:indexPath.row] objectForKey:@"fixture_id"]];
        NSArray *yellCards =  [[FootballFormDB sharedInstance]getYellowCardsFromMatchID:[[teamTwoHomeGames objectAtIndex:indexPath.row] objectForKey:@"fixture_id"]];
        NSArray *redCards =  [[FootballFormDB sharedInstance]getRedCardsFromMatchID:[[teamTwoHomeGames objectAtIndex:indexPath.row] objectForKey:@"fixture_id"]];
        NSArray *linups = [[FootballFormDB sharedInstance]getLineUpsPerMatchID:[[teamTwoHomeGames objectAtIndex:indexPath.row] objectForKey:@"fixture_id"]];
        
        if (arrayGoalScorers.count==0&&yellCards.count==0&&redCards.count==0&&linups.count==0) {
            return;
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:[[teamTwoHomeGames objectAtIndex:indexPath.row] objectForKey:@"fixture_id"] forKey:@"fixtureIDCarried"];
        
        
    }
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self performSegueWithIdentifier:@"StatsPredictorToGameDetails" sender:self];

    
    
    /*
    if (tableView == tableView1) {
        
        [[NSUserDefaults standardUserDefaults]setObject:[[teamOneHomeGames objectAtIndex:indexPath.row] objectForKey:@"fixture_id"] forKey:@"fixtureIDCarried"];
        
    } else if (tableView == tableView2) {
        
        [[NSUserDefaults standardUserDefaults]setObject:[[teamTwoHomeGames objectAtIndex:indexPath.row] objectForKey:@"fixture_id"] forKey:@"fixtureIDCarried"];

        
    }
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self performSegueWithIdentifier:@"StatsPredictorToGameDetails" sender:self];
     */
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == tableView1) {
        
       return [teamOneHomeGames count];
    } else {
        return [teamTwoHomeGames count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableView1) {
    
        //Tableview one
    
    static NSString *CellIdentifer = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
        UILabel *score = (UILabel *)[cell viewWithTag:110];
        [score setTextColor:[UIColor blackColor]];
        NSString *totalScore = totalScore = [NSString stringWithFormat:@"%@ %@ - %@ %@",[[[teamOneHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_home_name"] capitalizedString],[[teamOneHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_home_score"],[[teamOneHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_away_score"], [[[teamOneHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_away_name"]capitalizedString]];
        
        totalScore = [totalScore stringByReplacingOccurrencesOfString:@" Fc" withString:@" FC"];

        [score setText:totalScore];
        [score setMinimumScaleFactor:0.3];
        [score setAdjustsFontSizeToFitWidth:YES];
        
        /*
        if (!IS_IPHONE5) {
            [score setFrame:CGRectMake(3, 7, 236, 21)];
        }
         */

                
        if ([teamOneID isEqualToString:[[teamOneHomeGames objectAtIndex:indexPath.row]objectForKey:@"team_home_id"]]) {
            //THEY ARE PLAYING AT HOME
            
            if ([[[teamOneHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_away_score"] intValue]<[[[teamOneHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_home_score"] intValue]) {
                
                //Won
                [score setTextColor:[UIColor colorWithRed:43/255.0f green:134/255.0f blue:5/255.0f alpha:1]];
                
            } else if ([[[teamOneHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_away_score"] intValue]==[[[teamOneHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_home_score"] intValue]) {
                
                //Draw
                [score setTextColor:[UIColor orangeColor]];
                
            } else {
                
                //Lost
                [score setTextColor:[UIColor redColor]];

            }
            
        } else  {
            
            //THEY ARE PLAYING AWAY
            
            if ([[[teamOneHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_home_score"]intValue]<[[[teamOneHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_away_score"]intValue]) {
                
                //Won
                [score setTextColor:[UIColor colorWithRed:43/255.0f green:134/255.0f blue:5/255.0f alpha:1]];
                
            } else if ([[[teamOneHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_home_score"]intValue]==[[[teamOneHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_away_score"]intValue]) {
                
                //Draw
                [score setTextColor:[UIColor orangeColor]];

            } else {
                //Lost
                [score setTextColor:[UIColor redColor]];
            }
        }

        
        
    return cell;
        
    } else {
        
        static NSString *CellIdentifer = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
        }
        
        
        UILabel *score = (UILabel *)[cell viewWithTag:120];
        NSString *totalScore = totalScore = [NSString stringWithFormat:@"%@ %@ - %@ %@",[[[teamTwoHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_home_name"] capitalizedString],[[teamTwoHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_home_score"],[[teamTwoHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_away_score"], [[[teamTwoHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_away_name"] capitalizedString]];
        
        totalScore = [totalScore stringByReplacingOccurrencesOfString:@" Fc" withString:@" FC"];

        [score setText:totalScore];
        [score setMinimumScaleFactor:0.4];
        [score setAdjustsFontSizeToFitWidth:YES];
        

        /*
        if (!IS_IPHONE5) {
             [score setFrame:CGRectMake(3, 7, 236, 21)];
        }
         */
        
        if ([teamTwoID isEqualToString:[[teamTwoHomeGames objectAtIndex:indexPath.row]objectForKey:@"team_home_id"]]) {
            //THEY ARE PLAYING AT HOME
            
            if ([[[teamTwoHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_away_score"] intValue]<[[[teamTwoHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_home_score"] intValue]) {
                
                //Won
                [score setTextColor:[UIColor colorWithRed:43/255.0f green:134/255.0f blue:5/255.0f alpha:1]];
                
            } else if ([[[teamTwoHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_away_score"] intValue]==[[[teamTwoHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_home_score"] intValue]) {
                
                //Draw
                [score setTextColor:[UIColor orangeColor]];
                
            } else {
                
                //Lost
                [score setTextColor:[UIColor redColor]];
                
            }
            
        } else  {
            
            //THEY ARE PLAYING AWAY
            
            if ([[[teamTwoHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_home_score"]intValue]<[[[teamTwoHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_away_score"]intValue]) {
                
                //Won
                [score setTextColor:[UIColor colorWithRed:43/255.0f green:134/255.0f blue:5/255.0f alpha:1]];
                
            } else if ([[[teamTwoHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_home_score"]intValue]==[[[teamTwoHomeGames objectAtIndex:indexPath.row] objectForKey:@"team_away_score"]intValue]) {
                
                //Draw
                [score setTextColor:[UIColor orangeColor]];
                
            } else {
                //Lost
                [score setTextColor:[UIColor redColor]];
            }
        }

        
        return cell;
        
    }
}

- (IBAction)hidePickerView:(id)sender {
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    HUD.square = YES;
    [HUD show:YES];
    
    self.canDisplayBannerAds = YES;

    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(loadAfterPicker) userInfo:nil repeats:NO];
    
}



- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if ([[amountOfGamesArray objectAtIndex:row]isEqualToString:@"3 Games"]) {
        amountOfGames = @"3";
    } else if ([[amountOfGamesArray objectAtIndex:row]isEqualToString:@"5 Games"]) {
        amountOfGames = @"5";
    } else if ([[amountOfGamesArray objectAtIndex:row]isEqualToString:@"10 Games"]) {
        amountOfGames = @"10";
    }
    
    
}

-(void)loadAfterPicker {
    
    [UIView animateWithDuration:0.4 animations:^{
        [entirePickerView setAlpha:0.0];
    }];
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@ Games", amountOfGames] forKey:@"noOfGamesStatsToGraph"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self refreshTeamOneData];
    [self refreshTeamTwoData];
    [self workOutWhoStarBelongsTo];
    
    [self hideHud];

    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [amountOfGamesArray count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [amountOfGamesArray objectAtIndex:row];
}


/*
*/

-(void)refreshTeamOneData {

    if (segControlOne.selectedSegmentIndex==1) {
        teamOneHomeGames = [[FootballFormDB sharedInstance]statsExplorerGetGamesForBothTeam:teamOneID andAmountOfGames:amountOfGames lid:leagueI];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"All Points" forKey:@"gameTypeStatsToGraphOne"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        
    } else if (segControlOne.selectedSegmentIndex==0) {
        teamOneHomeGames = [[FootballFormDB sharedInstance]statsExplorerGetGamesForHomeTeam:teamOneID andAmountOfGames:amountOfGames lid:leagueI];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"Home Points" forKey:@"gameTypeStatsToGraphOne"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    } else {
        teamOneHomeGames = [[FootballFormDB sharedInstance]statsExplorerGetGamesForAwayTeam:teamOneID andAmountOfGames:amountOfGames lid:leagueI];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"Away Points" forKey:@"gameTypeStatsToGraphOne"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    [tableView1 reloadData];
    
    [self workOutThePointsTeamOne];
}

-(void)refreshTeamTwoData {
    if (segControlTwo.selectedSegmentIndex==1) {
        teamTwoHomeGames = [[FootballFormDB sharedInstance]statsExplorerGetGamesForBothTeam:teamTwoID andAmountOfGames:amountOfGames lid:leagueI];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"All Points" forKey:@"gameTypeStatsToGraphTwo"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    } else if (segControlTwo.selectedSegmentIndex==0) {
        teamTwoHomeGames = [[FootballFormDB sharedInstance]statsExplorerGetGamesForHomeTeam:teamTwoID andAmountOfGames:amountOfGames lid:leagueI];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"Home Points" forKey:@"gameTypeStatsToGraphTwo"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        
    } else {
        teamTwoHomeGames = [[FootballFormDB sharedInstance]statsExplorerGetGamesForAwayTeam:teamTwoID andAmountOfGames:amountOfGames lid:leagueI];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"Away Points" forKey:@"gameTypeStatsToGraphTwo"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    [tableView2 reloadData];

    [self workOutThePointsTeamTwo];
    
}

-(void)workOutThePointsTeamOne {
    
    teamOnePointsforGraph = [NSMutableArray new];
    totalTeamOne = 0;
    
    NSArray *newteamOnePointsforGraph = [[teamOneHomeGames reverseObjectEnumerator] allObjects];

    for(int i=0; i < [newteamOnePointsforGraph count]; i++) {
        
    if ([teamOneID isEqualToString:[[newteamOnePointsforGraph objectAtIndex:i]objectForKey:@"team_home_id"]]) {
        
        if ([[[newteamOnePointsforGraph objectAtIndex:i] objectForKey:@"team_away_score"]intValue]<[[[newteamOnePointsforGraph objectAtIndex:i] objectForKey:@"team_home_score"]intValue]) {
            
            totalTeamOne = totalTeamOne +3;
            
                        
        } else if ([[[newteamOnePointsforGraph objectAtIndex:i] objectForKey:@"team_away_score"]intValue]==[[[newteamOnePointsforGraph objectAtIndex:i] objectForKey:@"team_home_score"]intValue]) {
            
            totalTeamOne = totalTeamOne +1;
            
            
        } else {
            
        }
        

    } else  {
        
        //THEY ARE PLAYING AT HOME
        
        if ([[[newteamOnePointsforGraph objectAtIndex:i] objectForKey:@"team_home_score"]intValue]<[[[newteamOnePointsforGraph objectAtIndex:i] objectForKey:@"team_away_score"]intValue]) {
            
            totalTeamOne = totalTeamOne +3;
            
        } else if ([[[newteamOnePointsforGraph objectAtIndex:i] objectForKey:@"team_home_score"]intValue]==[[[newteamOnePointsforGraph objectAtIndex:i] objectForKey:@"team_away_score"]intValue]) {
            
            totalTeamOne = totalTeamOne +1;
            
        } else {
            
        }
        

    }
        
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", i], @"point", [NSString stringWithFormat:@"%d",totalTeamOne], @"cumulativeAmount", nil];
    [teamOnePointsforGraph addObject:dict];
        
}
    
    [_totalPoints1 setText:[NSString stringWithFormat:@"Total Points: %d", totalTeamOne]];
    
    //NSArray *newteamOnePointsforGraph = [[teamOnePointsforGraph reverseObjectEnumerator] allObjects];
    
    [[NSUserDefaults standardUserDefaults]setObject:teamOnePointsforGraph forKey:@"teamOneGraphPlottingDictionary"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}



-(void)workOutThePointsTeamTwo {
    
    teamTwoPointsforGraph =[NSMutableArray new];
    
    totalTeamTwo = 0;
    
    NSArray *newteamOnePointsforGraph = [[teamTwoHomeGames reverseObjectEnumerator] allObjects];

    
    for(int i=0; i < [newteamOnePointsforGraph count]; i++) {
        
        if ([teamTwoID isEqualToString:[[newteamOnePointsforGraph objectAtIndex:i]objectForKey:@"team_home_id"]]) {
            
            if ([[[newteamOnePointsforGraph objectAtIndex:i] objectForKey:@"team_away_score"]intValue]<[[[newteamOnePointsforGraph objectAtIndex:i] objectForKey:@"team_home_score"]intValue]) {
                
                totalTeamTwo = totalTeamTwo +3;
                
            } else if ([[[newteamOnePointsforGraph objectAtIndex:i] objectForKey:@"team_away_score"]intValue]==[[[newteamOnePointsforGraph objectAtIndex:i] objectForKey:@"team_home_score"]intValue]) {
                
                totalTeamTwo = totalTeamTwo +1;
                
                
            } else {
                
            }
            
            
        } else  {
            
            //THEY ARE PLAYING AT HOME
            
            if ([[[newteamOnePointsforGraph objectAtIndex:i] objectForKey:@"team_home_score"]intValue]<[[[newteamOnePointsforGraph objectAtIndex:i] objectForKey:@"team_away_score"]intValue]) {
                
                totalTeamTwo = totalTeamTwo +3;
                
            } else if ([[[newteamOnePointsforGraph objectAtIndex:i] objectForKey:@"team_home_score"]intValue]==[[[newteamOnePointsforGraph objectAtIndex:i] objectForKey:@"team_away_score"]intValue]) {
                
                totalTeamTwo = totalTeamTwo +1;
                
            } else {
                
            }
            
        }
        
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", i], @"point", [NSString stringWithFormat:@"%d",totalTeamTwo], @"cumulativeAmount", nil];
        [teamTwoPointsforGraph addObject:dict];
    }
    
    [_totalPoints2 setText:[NSString stringWithFormat:@"Total Points: %d", totalTeamTwo]];
    
    [[NSUserDefaults standardUserDefaults]setObject:teamTwoPointsforGraph forKey:@"teamTwoGraphPlottingDictionary"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    
}

-(void)workOutWhoStarBelongsTo {
    if (totalTeamTwo > totalTeamOne) {
        //star belongs to team 2
        homeStar.hidden=1;
        awayStar.hidden=0;
    } else if (totalTeamOne > totalTeamTwo) {
        //star belongs to 1
        homeStar.hidden=0;
        awayStar.hidden=1;
    } else {
        //they must have drawn, so lets hide the stars.
        homeStar.hidden=1;
        awayStar.hidden=1;
    }
    
    [self workOutGoals];
}


- (IBAction)teamOneSegChanged:(id)sender {
    [self refreshTeamOneData];
    [self workOutWhoStarBelongsTo];
    
}

- (IBAction)teamTwoSegChanged:(id)sender {
    
    [self refreshTeamTwoData];
    [self workOutWhoStarBelongsTo];

}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)compareGraph:(id)sender {
    
    if (teamOneHomeGames.count==0) {
        return;
    }
    
    if (teamTwoHomeGames.count==0) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:teamOneID forKey:@"compareTeamOneID"];
    [[NSUserDefaults standardUserDefaults]setObject:teamTwoID forKey:@"compareTeamTwoID"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self performSegueWithIdentifier:@"statsExpToGraph" sender:self];
}

- (IBAction)btnPlaceBet:(id)sender {
    
    //Send NSNotification (local)
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"FootballForm:ChangeBettingImage"
     object:self];
}
@end
