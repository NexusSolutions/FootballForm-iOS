//
//  FormPlayersViewController.m
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import "FormPlayersViewController.h"
#import "FootballFormDB.h"
#import <iAd/iAd.h>

@interface FormPlayersViewController ()

@end

@implementation FormPlayersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    for (UIView *views in scrollView.subviews) {
        [views removeFromSuperview];
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [leaguesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionViewy cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    
    cell = (UICollectionViewCell *)[collectionViewy dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *leagueName = (UILabel *)[cell viewWithTag:101];
    [leagueName setText:[[leaguesArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    int fractionalPag = (_leaguesCollectionView.contentSize.width / leaguesArray.count)-5;
    
    int fractionalPage = _leaguesCollectionView.contentOffset.x / fractionalPag;
    
    if (fractionalPage>=indexPath.row) {
        
        if (fractionalPage>=[leaguesArray count]) {
            fractionalPage=(int)[leaguesArray count]-1;
        }
        
        if (![selectedLeagueID isEqualToString:[[leaguesArray objectAtIndex:fractionalPage] objectForKey:@"leagueID"]]) {
            
            selectedLeagueID = [[leaguesArray objectAtIndex:fractionalPage] objectForKey:@"leagueID"];
            
            if (selectedLeagueID) [[NSUserDefaults standardUserDefaults]setObject:selectedLeagueID forKey:@"FootballForm:LeagueToCarry:LeagueID"];
            
            [[NSUserDefaults standardUserDefaults]setObject:selectedLeagueID forKey:@"leagueID"];
            [[NSUserDefaults standardUserDefaults]setObject:leagueName.text forKey:@"leagueName"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            //[self reloadDataAfterPicker];
            
            [spinnerrr setHidden:NO];
            [spinnerrr startAnimating];

            
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(reloadDataAfterPicker) userInfo:nil repeats:NO];
            
            //do the reloading stuff here
            
            [seg setSelectedSegmentIndex:0];
        }
        
        
        [leagueName setTextColor:[UIColor whiteColor]];
        
    } else {
        
        [leagueName setTextColor:[UIColor colorWithRed:160/255.0f green:178/255.0f blue:192/255.0f alpha:1]];
        
    }
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollViexw {
    
    if (scrollViexw==_leaguesCollectionView) {
        
        if (!scrollViexw.decelerating) [_leaguesCollectionView reloadData];
        
    } else {
        
        [topDataView setFrame:CGRectMake(-scrollViexw.contentOffset.x, topDataView.frame.origin.y, topDataView.frame.size.width, topDataView.frame.size.height)];

    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollViewx {
    
    if (scrollViewx==_leaguesCollectionView) {
        [UIView animateWithDuration:0.5 animations:^{
            
            int fractionalPag = (_leaguesCollectionView.contentSize.width/leaguesArray.count)-5;
            int fractionalPage = _leaguesCollectionView.contentOffset.x / fractionalPag;
            
            
            if (fractionalPage>=[leaguesArray count]) {
                fractionalPage=(int)[leaguesArray count]-1;
            }
            
            [_leaguesCollectionView setContentOffset:CGPointMake(fractionalPage*213, 0)];
            
        }];
    }
    
}


-(void)viewDidAppear:(BOOL)animated {
    
    [_leaguesCollectionView setContentOffset:CGPointMake(0, 0)];
    
    leaguesArray = nil;
    
    cacheNormal = [NSMutableArray new];
    cacheGoalsFirstHalf = [NSMutableArray new];
    cacheGoalsSecondHalf = [NSMutableArray new];
    
    gamesArray = @[@"All", @"3 Games", @"5 Games", @"10 Games"];
    gamesValue = @[@"1234567", @"3", @"5", @"10"];
    
    currentGameAmount = [gamesValue objectAtIndex:0];
    
    leagues = [[FootballFormDB sharedInstance]getLeaguesWithAmmendedAll];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"26012", @"leagueID", @"FA Community Shield", @"name", nil];
    [leagues removeObject:dict];
    
    NSDictionary *dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"36066", @"leagueID", @"FA Cup", @"name", nil];
    [leagues removeObject:dict1];
    
    NSDictionary *dict2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"26013", @"leagueID", @"Conference North", @"name", nil];
    [leagues removeObject:dict2];
    
    NSDictionary *dict3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"26012", @"leagueID", @"FA Community Shield", @"name", nil];
    [leagues removeObject:dict3];
    
    NSDictionary *dict4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"26011", @"leagueID", @"Conference South", @"name", nil];
    [leagues removeObject:dict4];
    
    NSDictionary *dict5 = [[NSDictionary alloc] initWithObjectsAndKeys:@"26008", @"leagueID", @"League Two", @"name", nil];
    [leagues removeObject:dict5];
    
    NSDictionary *dict6 = [[NSDictionary alloc] initWithObjectsAndKeys:@"26007", @"leagueID", @"League One", @"name", nil];
    [leagues removeObject:dict6];
    
    NSDictionary *dict7 = [[NSDictionary alloc] initWithObjectsAndKeys:@"26006", @"leagueID", @"Conference Premier", @"name", nil];
    [leagues removeObject:dict7];
    
    int index = 0;
    for (NSDictionary *dict in leagues) {
        
        if ([[dict objectForKey:@"name"]isEqualToString:@"Premier League"]) {
            currentLeague = [[leagues objectAtIndex:index]objectForKey:@"leagueName"];
            selectedLeagueID = [[NSUserDefaults standardUserDefaults]objectForKey:@"leagueID"];
        }
        
        index++;
    }

    if (currentLeague ==nil) {
        
        currentLeague = [[leagues objectAtIndex:0]objectForKey:@"leagueName"];
        selectedLeagueID = [[NSUserDefaults standardUserDefaults]objectForKey:@"leagueID"];
    }
    
    
    [_entirePickerView setAlpha:0.0];
    [_entirePickerView setFrame:CGRectMake(0, 0, 568, 320)];
    
    isFilteredByFirstHalfGoals = NO;
    isFilteredBySecondHalfGoals = NO;
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setMode:MBProgressHUDModeIndeterminate];
    [HUD setLabelText:@"Loading Data"];
    [HUD setDetailsLabelText:@"Please wait..."];
    [HUD show:YES];
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(reloadDataAfterPicker) userInfo:nil repeats:NO];
    
}

-(int)workOutCarriedLeague {
    
    NSString *carriedLeagueID = [[NSUserDefaults standardUserDefaults]objectForKey:@"FootballForm:LeagueToCarry:LeagueID"];
    
    int index = 0;
    
    if (carriedLeagueID) {
        
        for (NSDictionary *leagueNameData in leaguesArray) {
            
            NSString *leagueIDDict = leagueNameData[@"leagueID"];
            if ([leagueIDDict isEqualToString:carriedLeagueID]) {
                return index;
            }
            
            index++;
            
        }
        
    }
    
    return 0;
    
}

/*
-(void)scrollViewDidScroll:(UIScrollView *)scrollViewd {
    
    [topDataView setFrame:CGRectMake(-scrollViewd.contentOffset.x, topDataView.frame.origin.y, topDataView.frame.size.width, topDataView.frame.size.height)];
    
}
*/
/*
-(void)collectDataViewAppeared {
    
    firstHalfGoals = [[FootballFormDB sharedInstance]getFormPlayers:@"1234567" limitBy:currentGameAmount];
    
    NSArray * sorted2 = [firstHalfGoals sortedArrayUsingComparator: ^(id first, id second) {
        return - [([(NSDictionary *)first objectForKey:@"TotalGoals"]) compare:([(NSDictionary *)second objectForKey:@"TotalGoals"]) options: NSNumericSearch];
    }];
    
    cacheNormal = [sorted2 mutableCopy];
    firstHalfGoals = cacheNormal;
    
    NSArray * sorted3 = [firstHalfGoals sortedArrayUsingComparator: ^(id first, id second) {
        return - [([(NSDictionary *)first objectForKey:@"periodOneGoals"]) compare:([(NSDictionary *)second objectForKey:@"periodOneGoals"]) options: NSNumericSearch];
    }];
    
    cacheGoalsFirstHalf = [sorted3 mutableCopy];
    
    NSArray * sorted4 = [firstHalfGoals sortedArrayUsingComparator: ^(id first, id second) {
        return - [([(NSDictionary *)first objectForKey:@"periodTwoGoals"]) compare:([(NSDictionary *)second objectForKey:@"periodTwoGoals"]) options: NSNumericSearch];
    }];
    
    cacheGoalsSecondHalf = [sorted4 mutableCopy];
    
    
    NSArray * sorted5 = [firstHalfGoals sortedArrayUsingComparator: ^(id first, id second) {
        return - [([(NSDictionary *)first objectForKey:@"appearances"]) compare:([(NSDictionary *)second objectForKey:@"appearances"]) options: NSNumericSearch];
    }];
    
    cacheTotalPlayed = [sorted5 mutableCopy];
    
    NSArray * sorted6 = [firstHalfGoals sortedArrayUsingComparator: ^(id first, id second) {
        return - [([(NSDictionary *)first objectForKey:@"TotalGoals"]) compare:([(NSDictionary *)second objectForKey:@"TotalGoals"]) options: NSNumericSearch];
    }];
    
    cacheTotalGoals = [sorted6 mutableCopy];


    
    
    [self buildUpInterface];
}
*/



-(void)buildUpInterface {
    
    [scrollView setContentOffset:CGPointMake(0, 0)];
    
        [scrollView setContentSize:CGSizeMake(568, [firstHalfGoals count]*45)];

    
    
    for (UIView *views in scrollView.subviews) {
        [views removeFromSuperview];
    }
    
    int x = 0;
    int y = 0;
    int index =0;
    
    for (NSDictionary *dict in firstHalfGoals) {
        
        UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(x, y, 568, 45)];
        [scrollView addSubview:cellView];
        
        UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(55, 13, 30, 30)];
        [im setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[dict objectForKey:@"logoID"]]]];
        [cellView addSubview:im];
    
        UILabel *playerName = [[UILabel alloc]initWithFrame:CGRectMake(53, 1, 185, 26)];
        [playerName setFont:[UIFont systemFontOfSize:16]];
        [playerName setText:[dict objectForKey:@"playerName"]];
        [cellView addSubview:playerName];
        
        UILabel *goalFirstHalf = [[UILabel alloc]initWithFrame:CGRectMake(310, 12, 45, 21)];
        [goalFirstHalf setText:[dict objectForKey:@"periodOneGoals"]];
        [goalFirstHalf setTextAlignment:NSTextAlignmentCenter];
        [cellView addSubview:goalFirstHalf];
        
        UILabel *goalSecondHalf = [[UILabel alloc]initWithFrame:CGRectMake(377, 12, 45, 21)];
        [goalSecondHalf setText:[dict objectForKey:@"periodTwoGoals"]];
        [goalSecondHalf setTextAlignment:NSTextAlignmentCenter];
        [cellView addSubview:goalSecondHalf];
        
        UILabel *teamName = [[UILabel alloc]initWithFrame:CGRectMake(53, 22, 185, 21)];
        [teamName setText:[dict objectForKey:@"teamName"]];
        [teamName setFont:[UIFont italicSystemFontOfSize:13]];

        [cellView addSubview:teamName];
        
        UILabel *appearances = [[UILabel alloc]initWithFrame:CGRectMake(256, 12, 38, 21)];
        [appearances setText:[dict objectForKey:@"appearances"]];
        [appearances setTextAlignment:NSTextAlignmentCenter];
        [cellView addSubview:appearances];
        
        UILabel *position = [[UILabel alloc]initWithFrame:CGRectMake(1, 12, 40, 21)];
        [position setText:[NSString stringWithFormat:@"%d", index+1]];
        [position setTextAlignment:NSTextAlignmentCenter];
        [cellView addSubview:position];
        
        UILabel *totalGoals = [[UILabel alloc]initWithFrame:CGRectMake(443, 12, 39, 21)];
        [totalGoals setText:[dict objectForKey:@"TotalGoals"]];
        [totalGoals setTextAlignment:NSTextAlignmentCenter];
        [cellView addSubview:totalGoals];
        
        float sum = [totalGoals.text floatValue]/[appearances.text floatValue];
        UILabel *ratio = [[UILabel alloc]initWithFrame:CGRectMake(497, 12, 66, 21)];
        [ratio setText:[NSString stringWithFormat:@"%.3f", sum]];
        [ratio setTextAlignment:NSTextAlignmentLeft];
        [cellView addSubview:ratio];
        
        //appearances
        
        if (index % 2) {
            
            [cellView setBackgroundColor:[UIColor whiteColor]];

        } else {
            
            [cellView setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1]];

        }
        
        index++;
        
        y = y +45;
        
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hideHud) userInfo:nil repeats:NO];
}

-(void)hideHud {
    
    [spinnerrr setHidden:YES];
    [spinnerrr stopAnimating];

    [HUD removeFromSuperview];
    
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
    
    
    [_tabBar setSelectedItem:formPlayers];
    
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    
    if (item.tag==1) {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoToFixtures"
         object:self];
        
    } else if (item.tag==2) {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoToLeagues"
         object:self];
        
    } else if (item.tag==3) {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoPlayerVs"
         object:self];
        
    } else if (item.tag==4) {
        /*
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoToFormPlayers"
         object:self];
        */
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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [_noDataView setHidden:YES];
    
    [spinnerrr setHidden:YES];

    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    //Listen for NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewDidAppear:)
                                                 name:@"FootballForm:PKWillRefresh"
                                               object:nil];
    
    self.canDisplayBannerAds = YES;
    
    _leaguesCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, (_leaguesCollectionView.frame.size.width/2)+425);


    
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"FootballForm:PKWillRefresh" object:nil];
    
}


- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectLeague:(id)sender {
    whichPicker = @"LEAGUE";
    [_pickerTitle setText:@"Select league"];

    
    [UIView animateWithDuration:0.6 animations:^{
        [_entirePickerView setAlpha:1.0];
    }];
    [_pickerView reloadAllComponents];

}


- (IBAction)selectNumberOfGames:(id)sender {
    whichPicker = @"GAMES";
    [_pickerTitle setText:@"Select number of games"];
    
    
    [UIView animateWithDuration:0.6 animations:^{
        [_entirePickerView setAlpha:1.0];
    }];
    
    [_pickerView reloadAllComponents];
}


- (IBAction)hidePicker:(id)sender {
    
    [UIView animateWithDuration:0.6 animations:^{
        [_entirePickerView setAlpha:0.0];
    }];
    
     //if (![whichPicker isEqualToString:@"GAMES"]) {
         
         HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         [HUD setMode:MBProgressHUDModeIndeterminate];
         [HUD setLabelText:@"Filtering Data"];
         [HUD setDetailsLabelText:@"Please wait..."];
         [HUD show:YES];
         
         [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(reloadDataAfterPicker) userInfo:nil repeats:NO];
     //} else {
         //NSLog(@"%@", currentGameAmount);
     //}
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag ==1091) {
        
        //[self showPeek:nil];
    }
}

-(void)reloadDataAfterPicker {
    
    if ([selectedLeagueID isEqualToString:@"000123"]) {
        selectedLeagueID = @"1234567";
    }
    
    [_noDataView setHidden:YES];

    
    NSString *cid;
    cid = [[NSUserDefaults standardUserDefaults]objectForKey:@"countryID"];
    
    if (!cid) {
        cid = @"40011";
    }
    
    if (!leaguesArray) {
        
        leaguesArray = [[FootballFormDB sharedInstance]getLeaguesForFormPlayers:cid];
        [_leaguesCollectionView reloadData];

        if (leaguesArray.count==0) {
            
            [_noDataView setFrame:CGRectMake(_noDataView.frame.origin.x, 44, _noDataView.frame.size.width, _noDataView.frame.size.height)];
            [_noDataView setHidden:NO];
            
            [self hideHud];
            seg.hidden=YES;
            
            return;
        }
        
        int indexx = [self workOutCarriedLeague];
        
        [_leaguesCollectionView setContentOffset:CGPointMake(indexx*213, 0)];
        
        selectedLeagueID = leaguesArray[indexx][@"leagueID"];
        currentLeague = leaguesArray[indexx][@"leagueName"];
        
    } else {
        
        [spinnerrr setHidden:NO];
        [spinnerrr startAnimating];
        
        [_noDataView setHidden:YES];
        
        seg.hidden=NO;

    }

    if (leaguesArray.count==0) {
        
        [_noDataView setFrame:CGRectMake(_noDataView.frame.origin.x, 44, _noDataView.frame.size.width, _noDataView.frame.size.height)];
        [_noDataView setHidden:NO];

        
        [spinnerrr setHidden:YES];
        [spinnerrr stopAnimating];
        
        [self hideHud];
        
        seg.hidden=YES;
        
        return;
    }
    
    seg.hidden=NO;
    
    firstHalfGoals = [[FootballFormDB sharedInstance]getFormPlayers:selectedLeagueID side:@""];
    
    if (firstHalfGoals.count <=0) {
        
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hideHud) userInfo:nil repeats:NO];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Form Players" message:@"Form players data is not available for this league." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setTag:1091];
        [alert show];
        
        return;
        
    }
        
    NSArray * sorted2 = [firstHalfGoals sortedArrayUsingComparator: ^(id first, id second) {
        return - [([(NSDictionary *)first objectForKey:@"TotalGoals"]) compare:([(NSDictionary *)second objectForKey:@"TotalGoals"]) options: NSNumericSearch];
    }];
    
    cacheNormal = [sorted2 mutableCopy];
    firstHalfGoals = cacheNormal;
    
    NSArray * sorted3 = [firstHalfGoals sortedArrayUsingComparator: ^(id first, id second) {
        return - [([(NSDictionary *)first objectForKey:@"periodOneGoals"]) compare:([(NSDictionary *)second objectForKey:@"periodOneGoals"]) options: NSNumericSearch];
    }];
    
    cacheGoalsFirstHalf = [sorted3 mutableCopy];
    
    NSArray * sorted4 = [firstHalfGoals sortedArrayUsingComparator: ^(id first, id second) {
        return - [([(NSDictionary *)first objectForKey:@"periodTwoGoals"]) compare:([(NSDictionary *)second objectForKey:@"periodTwoGoals"]) options: NSNumericSearch];
    }];
    
    cacheGoalsSecondHalf = [sorted4 mutableCopy];
    
   
    NSArray * sorted5 = [firstHalfGoals sortedArrayUsingComparator: ^(id first, id second) {
        return - [([(NSDictionary *)first objectForKey:@"appearances"]) compare:([(NSDictionary *)second objectForKey:@"appearances"]) options: NSNumericSearch];
    }];
    
    cacheTotalPlayed = [sorted5 mutableCopy];
    
    NSArray * sorted6 = [firstHalfGoals sortedArrayUsingComparator: ^(id first, id second) {
        return - [([(NSDictionary *)first objectForKey:@"TotalGoals"]) compare:([(NSDictionary *)second objectForKey:@"TotalGoals"]) options: NSNumericSearch];
    }];
    
    cacheTotalGoals = [sorted6 mutableCopy];
    
    [self buildUpInterface];

}

-(void)reloadDataAfterPickerHome {
    
    if ([selectedLeagueID isEqualToString:@"000123"]) {
        selectedLeagueID = @"1234567";
    }
    
    firstHalfGoals = [[FootballFormDB sharedInstance]getFormPlayers:selectedLeagueID side:@"HOME"];
    
    NSArray * sorted2 = [firstHalfGoals sortedArrayUsingComparator: ^(id first, id second) {
        return - [([(NSDictionary *)first objectForKey:@"TotalGoals"]) compare:([(NSDictionary *)second objectForKey:@"TotalGoals"]) options: NSNumericSearch];
    }];
    
    cacheNormal = [sorted2 mutableCopy];
    firstHalfGoals = cacheNormal;
    
    NSArray * sorted3 = [firstHalfGoals sortedArrayUsingComparator: ^(id first, id second) {
        return - [([(NSDictionary *)first objectForKey:@"periodOneGoals"]) compare:([(NSDictionary *)second objectForKey:@"periodOneGoals"]) options: NSNumericSearch];
    }];
    
    cacheGoalsFirstHalf = [sorted3 mutableCopy];
    
    NSArray * sorted4 = [firstHalfGoals sortedArrayUsingComparator: ^(id first, id second) {
        return - [([(NSDictionary *)first objectForKey:@"periodTwoGoals"]) compare:([(NSDictionary *)second objectForKey:@"periodTwoGoals"]) options: NSNumericSearch];
    }];
    
    cacheGoalsSecondHalf = [sorted4 mutableCopy];
    
    
    NSArray * sorted5 = [firstHalfGoals sortedArrayUsingComparator: ^(id first, id second) {
        return - [([(NSDictionary *)first objectForKey:@"appearances"]) compare:([(NSDictionary *)second objectForKey:@"appearances"]) options: NSNumericSearch];
    }];
    
    cacheTotalPlayed = [sorted5 mutableCopy];
    
    NSArray * sorted6 = [firstHalfGoals sortedArrayUsingComparator: ^(id first, id second) {
        return - [([(NSDictionary *)first objectForKey:@"TotalGoals"]) compare:([(NSDictionary *)second objectForKey:@"TotalGoals"]) options: NSNumericSearch];
    }];
    
    cacheTotalGoals = [sorted6 mutableCopy];
    
    [self buildUpInterface];
    
}

-(void)reloadDataAfterPickerAway {
    
    if ([selectedLeagueID isEqualToString:@"000123"]) {
        selectedLeagueID = @"1234567";
    }
    
    firstHalfGoals = [[FootballFormDB sharedInstance]getFormPlayers:selectedLeagueID side:@"AWAY"];
    
    NSArray * sorted2 = [firstHalfGoals sortedArrayUsingComparator: ^(id first, id second) {
        return - [([(NSDictionary *)first objectForKey:@"TotalGoals"]) compare:([(NSDictionary *)second objectForKey:@"TotalGoals"]) options: NSNumericSearch];
    }];
    
    cacheNormal = [sorted2 mutableCopy];
    firstHalfGoals = cacheNormal;
    
    NSArray * sorted3 = [firstHalfGoals sortedArrayUsingComparator: ^(id first, id second) {
        return - [([(NSDictionary *)first objectForKey:@"periodOneGoals"]) compare:([(NSDictionary *)second objectForKey:@"periodOneGoals"]) options: NSNumericSearch];
    }];
    
    cacheGoalsFirstHalf = [sorted3 mutableCopy];
    
    NSArray * sorted4 = [firstHalfGoals sortedArrayUsingComparator: ^(id first, id second) {
        return - [([(NSDictionary *)first objectForKey:@"periodTwoGoals"]) compare:([(NSDictionary *)second objectForKey:@"periodTwoGoals"]) options: NSNumericSearch];
    }];
    
    cacheGoalsSecondHalf = [sorted4 mutableCopy];
    
    
    NSArray * sorted5 = [firstHalfGoals sortedArrayUsingComparator: ^(id first, id second) {
        return - [([(NSDictionary *)first objectForKey:@"appearances"]) compare:([(NSDictionary *)second objectForKey:@"appearances"]) options: NSNumericSearch];
    }];
    
    cacheTotalPlayed = [sorted5 mutableCopy];
    
    NSArray * sorted6 = [firstHalfGoals sortedArrayUsingComparator: ^(id first, id second) {
        return - [([(NSDictionary *)first objectForKey:@"TotalGoals"]) compare:([(NSDictionary *)second objectForKey:@"TotalGoals"]) options: NSNumericSearch];
    }];
    
    cacheTotalGoals = [sorted6 mutableCopy];
    
    [self buildUpInterface];
    
}


#pragma mark Pickerview delegate

//UIPickerView delegate methods
- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([whichPicker isEqualToString:@"GAMES"]) {
       currentGameAmount = [gamesValue objectAtIndex:row];
    } else {
        
        currentLeague = [[leagues objectAtIndex:row]objectForKey:@"name"];
        selectedLeagueID = [[leagues objectAtIndex:row]objectForKey:@"leagueID"];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if ([whichPicker isEqualToString:@"GAMES"]) {
        return [gamesArray count];
    } else {
        
        return [leagues count];
    }

    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([whichPicker isEqualToString:@"GAMES"]) {
        
        return [gamesArray objectAtIndex:row];
        
    } else {
        
        return [[leagues objectAtIndex:row]objectForKey:@"name"];
    }
    
}


- (IBAction)allHomeAway:(id)sender {
    
    if (seg.selectedSegmentIndex==0) {
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD setMode:MBProgressHUDModeIndeterminate];
        [HUD setLabelText:@"Loading Data"];
        [HUD setDetailsLabelText:@"Please wait..."];
        [HUD show:YES];
        
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(reloadDataAfterPicker) userInfo:nil repeats:NO];
        
    } else if (seg.selectedSegmentIndex==1) {
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD setMode:MBProgressHUDModeIndeterminate];
        [HUD setLabelText:@"Loading Data"];
        [HUD setDetailsLabelText:@"Please wait..."];
        [HUD show:YES];
        
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(reloadDataAfterPickerHome) userInfo:nil repeats:NO];
        
    } else if (seg.selectedSegmentIndex==2) {
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD setMode:MBProgressHUDModeIndeterminate];
        [HUD setLabelText:@"Loading Data"];
        [HUD setDetailsLabelText:@"Please wait..."];
        [HUD show:YES];
        
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(reloadDataAfterPickerAway) userInfo:nil repeats:NO];
        
        
    }
}

- (IBAction)filterBy1stHalfGoals:(id)sender {
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setMode:MBProgressHUDModeIndeterminate];
    [HUD setLabelText:@"Filtering Data"];
    [HUD setDetailsLabelText:@"Please wait..."];
    [HUD show:YES];

    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(filterFirst) userInfo:nil repeats:NO];
    
}

-(void)filterFirst {
    
    if (isFilteredByFirstHalfGoals) {
        
        firstHalfGoals = cacheNormal;
        
        isFilteredByFirstHalfGoals = NO;
        
    } else {
        
        firstHalfGoals = cacheGoalsFirstHalf;
        
        isFilteredByFirstHalfGoals = YES;
        
    }
    
    [self buildUpInterface];
    
}


- (IBAction)filterGoalsBySecondHalf:(id)sender {
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setMode:MBProgressHUDModeIndeterminate];
    [HUD setLabelText:@"Filtering Data"];
    [HUD setDetailsLabelText:@"Please wait..."];
    [HUD show:YES];
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(filterSecond) userInfo:nil repeats:NO];

}

- (IBAction)filterByPlayed:(id)sender {
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setMode:MBProgressHUDModeIndeterminate];
    [HUD setLabelText:@"Filtering Data"];
    [HUD setDetailsLabelText:@"Please wait..."];
    [HUD show:YES];
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(filterPlayed) userInfo:nil repeats:NO];

    
}

- (IBAction)filterByTotal:(id)sender {
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setMode:MBProgressHUDModeIndeterminate];
    [HUD setLabelText:@"Filtering Data"];
    [HUD setDetailsLabelText:@"Please wait..."];
    [HUD show:YES];
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(filterTotGoals) userInfo:nil repeats:NO];
}

- (IBAction)showPeek:(id)sender {
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    [revealController showViewController:revealController.leftViewController];
    
    
}

-(void)filterTotGoals {
    
    
    if (isFilteredByTotalGoals) {
        
        firstHalfGoals = cacheNormal;
        
        isFilteredByTotalGoals = NO;
        
    } else {
        
        firstHalfGoals = cacheTotalGoals;
        
        isFilteredByTotalGoals = YES;
        
    }
    
    [self buildUpInterface];

    
}

-(void)filterPlayed {
    if (isFilteredByPlayed) {
        
        firstHalfGoals = cacheNormal;
        
        isFilteredByPlayed = NO;
        
    } else {
        
        firstHalfGoals = cacheTotalPlayed;
        
        isFilteredByPlayed = YES;
        
    }
    
    [self buildUpInterface];

}

-(void)filterSecond {
    
    if (isFilteredBySecondHalfGoals) {
        
        firstHalfGoals = cacheNormal;
        
        isFilteredBySecondHalfGoals = NO;
        
    } else {
        
        firstHalfGoals = cacheGoalsSecondHalf;
        
        isFilteredBySecondHalfGoals = YES;
        
    }
    
    [self buildUpInterface];
    
}

@end
