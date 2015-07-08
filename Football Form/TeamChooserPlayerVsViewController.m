//
//  TeamChooserPlayerVsViewController.m
//  Football Form
//
//  Created by Aaron Wilkinson on 24/01/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import "TeamChooserPlayerVsViewController.h"
#import "FootballFormDB.h"
#import "AsyncImageView.h"
#import <iAd/iAd.h>
@interface TeamChooserPlayerVsViewController ()

@end

@implementation TeamChooserPlayerVsViewController

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
	// Do any additional setup after loading the view.
    
    [_entirePickerView setAlpha:0.0];
    [_entirePickerView setFrame:CGRectMake(0, 0, 568, 320)];
    
    [_pickerView setFrame:CGRectMake(_pickerView.frame.origin.x, _pickerView.frame.origin.y, [[UIScreen mainScreen] bounds].size.height, _pickerView.frame.size.height)];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    /*
    if (!IS_IPHONE5) {
        [closeButty setFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.height-closeButty.frame.size.width)-15, closeButty.frame.origin.y, closeButty.frame.size.width, closeButty.frame.size.height)];
        [navView setFrame:CGRectMake(-83, navView.frame.origin.y, navView.frame.size.width, navView.frame.size.height)];
    }
     */
    
    self.canDisplayBannerAds = YES;
    
    [self checkRotation];
    
    _leaguesCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, (_leaguesCollectionView.frame.size.width/2)+425);
    
    [_noDataView setHidden:YES];


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
            
            isFirstTableFiltered = NO;
            isSecondTableFiltered = NO;
            
            searchDataPlayerOne = [NSMutableArray new];
            searchDataPlayerTwo = [NSMutableArray new];
            
            [searchBarTableOne setText:@""];
            [searchBarTableTwo setText:@""];
            
            [self.view endEditing:YES];
            
            playerDataTableOne = [[FootballFormDB sharedInstance]getTeamsPerLeagueAndHaveNameReturned:selectedLeagueID];
            playerDataTableTwo = [playerDataTableOne mutableCopy];
            
            [_playerOneTableView reloadData];
            [_playerTwoTableView reloadData];
            
            
            //leagueData =  [[FootballFormDB sharedInstance] getLeagueTable:selectedLe];
            //[_tableView reloadData];
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
        [searchBarTableTwo resignFirstResponder];
        [searchBarTableOne resignFirstResponder];
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    // Then your code...
    
    [self checkRotation];
    
}
    
-(void)checkRotation {
    
    [bannerView setFrame:CGRectMake(bannerView.frame.origin.x, self.view.frame.size.height-bannerView.frame.size.height, self.view.frame.size.width, bannerView.frame.size.height)];

    if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        searchBarTableOne.showsCancelButton = NO;
        searchBarTableTwo.showsCancelButton = NO;
    } else {
        searchBarTableOne.showsCancelButton = YES;
        searchBarTableTwo.showsCancelButton = YES;

    }
    
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"FootballForm:PKWillRefresh" object:nil];
    
}


-(void)clearDa {
    
    leaguesArray = nil;
    [self viewWillAppear:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearDa)
                                                 name:@"FootballForm:PKWillRefresh"
                                               object:nil];
    
    [_leaguesCollectionView setContentOffset:CGPointMake(0, 0)];
    
    if (!leaguesArray) {

        NSString *cid;
        cid = [[NSUserDefaults standardUserDefaults]objectForKey:@"countryID"];
        
        if (!cid) {
            cid = @"40011";
        }
        
        leaguesArray = [[FootballFormDB sharedInstance]getLeaguesForFormPlayers:cid];
        
        if (leaguesArray.count==0) {
            
            [_noDataView setFrame:CGRectMake(_noDataView.frame.origin.x, 44, _noDataView.frame.size.width, _noDataView.frame.size.height)];
            [_noDataView setHidden:NO];
            
            //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Player Vs" message:@"Sorry, there is no player data available for the selected country." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            //[alert show];
            
            [_nextOutOne setHidden:YES];
            [_nextOutTwo setHidden:YES];
            
            return;
            
        }
        
        [_nextOutOne setHidden:NO];
        [_nextOutTwo setHidden:NO];
        [_noDataView setHidden:YES];
        
        int indexx = [self workOutCarriedLeague];
        
        [_leaguesCollectionView setContentOffset:CGPointMake(indexx*213, 0)];

        selectedLeagueID = [[leaguesArray objectAtIndex:indexx] objectForKey:@"leagueID"];
        
        [_leaguesCollectionView reloadData];
        
        isFirstTableFiltered = NO;
        isSecondTableFiltered = NO;
        
        searchDataPlayerOne = [NSMutableArray new];
        searchDataPlayerTwo = [NSMutableArray new];
        
        leagueDivisionData = [[FootballFormDB sharedInstance]getLeagues];

        //Commented this out as I couldnt see the need for it
        //selectedLeagueID =  [[NSUserDefaults standardUserDefaults]objectForKey:@"leagueID"];
        
        playerDataTableOne = [[FootballFormDB sharedInstance]getTeamsPerLeagueAndHaveNameReturned:selectedLeagueID];

        playerDataTableTwo = [playerDataTableOne mutableCopy];
        
        [_playerOneTableView reloadData];
        [_playerTwoTableView reloadData];
        
    }
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
    
    
    [_tabBar setSelectedItem:playerVs];
    
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
        /*
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoPlayerVs"
         object:self];
        */
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // typically you need know which item the user has selected.
    // this method allows you to keep track of the selection
    
    if (tableView == _playerOneTableView) {
        if (isFirstTableFiltered) {
            
            NSString *playerID = [[searchedDataFirst objectAtIndex:indexPath.row] objectForKey:@"teamID"];
            NSString *leid = [[searchedDataFirst objectAtIndex:indexPath.row] objectForKey:@"leagueID"];

            [[NSUserDefaults standardUserDefaults]setObject:leid forKey:@"FootballForm:PlayerVsLeagueIDT1"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            static NSString *CellIdentifer = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
            UIImageView *tick = (UIImageView *)[cell viewWithTag:112];
            if ([searchDataPlayerOne containsObject:playerID]) {
                
                [searchDataPlayerOne removeObject:playerID];
                
            } else {
                
                searchDataPlayerOne = [NSMutableArray new];
                [searchDataPlayerOne addObject:playerID];
                tick.hidden=0;
                
            }
            
            [_playerOneTableView reloadData];
            
        } else {
            
            NSString *playerID = [[playerDataTableOne objectAtIndex:indexPath.row] objectForKey:@"teamID"];
            NSString *leid = [[playerDataTableOne objectAtIndex:indexPath.row] objectForKey:@"leagueID"];
            
            [[NSUserDefaults standardUserDefaults]setObject:leid forKey:@"FootballForm:PlayerVsLeagueIDT1"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            static NSString *CellIdentifer = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
            UIImageView *tick = (UIImageView *)[cell viewWithTag:112];
            if ([searchDataPlayerOne containsObject:playerID]) {
                [searchDataPlayerOne removeObject:playerID];
                
            } else {
                
                searchDataPlayerOne = [NSMutableArray new];
                [searchDataPlayerOne addObject:playerID];
                tick.hidden=0;
            }
            
            [_playerOneTableView reloadData];
            
            
        }
        
    } else if (tableView == _playerTwoTableView) {
        if (isSecondTableFiltered) {
            
            NSString *playerID = [[searchedDataSecond objectAtIndex:indexPath.row] objectForKey:@"teamID"];
            NSString *leid = [[searchedDataSecond objectAtIndex:indexPath.row] objectForKey:@"leagueID"];

            [[NSUserDefaults standardUserDefaults]setObject:leid forKey:@"FootballForm:PlayerVsLeagueIDT2"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            static NSString *CellIdentifer = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
            UIImageView *tick = (UIImageView *)[cell viewWithTag:122];
            if ([searchDataPlayerTwo containsObject:playerID]) {
                [searchDataPlayerTwo removeObject:playerID];
                
            } else {
                searchDataPlayerTwo = [NSMutableArray new];
                [searchDataPlayerTwo addObject:playerID];
                tick.hidden=0;
                
            }
            
            [_playerTwoTableView reloadData];
            
        } else {
            
            NSString *playerID = [[playerDataTableTwo objectAtIndex:indexPath.row] objectForKey:@"teamID"];
            NSString *leid = [[playerDataTableTwo objectAtIndex:indexPath.row] objectForKey:@"leagueID"];

            [[NSUserDefaults standardUserDefaults]setObject:leid forKey:@"FootballForm:PlayerVsLeagueIDT2"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            static NSString *CellIdentifer = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
            UIImageView *tick = (UIImageView *)[cell viewWithTag:122];
            if ([searchDataPlayerTwo containsObject:playerID]) {
                [searchDataPlayerTwo removeObject:playerID];
                
            } else {
                searchDataPlayerTwo = [NSMutableArray new];
                [searchDataPlayerTwo addObject:playerID];
                tick.hidden=0;
                
            }
            
            [_playerTwoTableView reloadData];
        }
    }
    
}
// This will tell your UITableView how many rows you wish to have in each section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == _playerOneTableView) {
        if (isFirstTableFiltered) {
            
            return [searchedDataFirst count];
            
        } else {
            
            return [playerDataTableOne count];
            
        }
        
    } else if (tableView == _playerTwoTableView) {
        
        if (isSecondTableFiltered) {
            
            return [searchedDataSecond count];
            
        } else {
            
            return [playerDataTableTwo count];
            
        }
        
    }
    
    return 0;
}

// This will tell your UITableView what data to put in which cells in your table.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    
    
    
    
    
    if (tableView == _playerOneTableView) {
        
        if (isFirstTableFiltered) {
            
            static NSString *CellIdentifer = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
            }
            NSString *playerID = [[searchedDataFirst objectAtIndex:indexPath.row] objectForKey:@"teamID"];
            
            //101 is home, 102 is away
            
            UILabel *playerOne = (UILabel *)[cell viewWithTag:101];
            [playerOne setText:[NSString stringWithFormat:@"%@", [[[searchedDataFirst objectAtIndex:indexPath.row] objectForKey:@"teamName"] capitalizedString]]];
            playerOne.minimumScaleFactor = 0.3;
            playerOne.adjustsFontSizeToFitWidth = YES;
            
            UIImageView *teamLogo = (UIImageView *)[cell viewWithTag:991];
            NSString *logName = [[searchedDataFirst objectAtIndex:indexPath.row]objectForKey:@"logoID"];
            logName = [logName stringByReplacingOccurrencesOfString:@"NULL" withString:@"default"];
            [teamLogo setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", logName]]];
            
            UIImageView *tick = (UIImageView *)[cell viewWithTag:112];
            tick.hidden=1;
            
            if ([searchDataPlayerOne containsObject:playerID]) {
                
                tick.hidden=0;
                
            } else {
                
                tick.hidden=1;
                
            }
            
            
            if (indexPath.row % 2) {
                [cell setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1]];
            } else {
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            
            
            /*
            UIImageView *tickNotTicked = (UIImageView *)[cell viewWithTag:9910];
            
            if (IS_IPHONE5) {
                
                [tickNotTicked setFrame:CGRectMake(250, tick.frame.origin.y, tick.frame.size.width, tick.frame.size.height)];
                [tick setFrame:CGRectMake(250, tick.frame.origin.y, tick.frame.size.width, tick.frame.size.height)];
            } else {
                
                [tickNotTicked setFrame:CGRectMake(200, tick.frame.origin.y, tick.frame.size.width, tick.frame.size.height)];
                [tick setFrame:CGRectMake(200, tick.frame.origin.y, tick.frame.size.width, tick.frame.size.height)];
            }
             */

            
            
            return cell;
            
            
        } else {
            
            static NSString *CellIdentifer = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
            }
            NSString *playerID = [[playerDataTableOne objectAtIndex:indexPath.row] objectForKey:@"teamID"];
            
            //101 is home, 102 is away
            
            UILabel *playerOne = (UILabel *)[cell viewWithTag:101];
            [playerOne setText:[NSString stringWithFormat:@"%@", [[[playerDataTableOne objectAtIndex:indexPath.row] objectForKey:@"teamName"] capitalizedString]]];
            //[playerOne setTextAlignment:NSTextAlignmentCenter];
            playerOne.minimumScaleFactor = 0.3;
            playerOne.adjustsFontSizeToFitWidth = YES;
            
            UIImageView *teamLogo = (UIImageView *)[cell viewWithTag:991];
            NSString *logName = [[playerDataTableOne objectAtIndex:indexPath.row]objectForKey:@"logoID"];
            logName = [logName stringByReplacingOccurrencesOfString:@"NULL" withString:@"default"];
            [teamLogo setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", logName]]];
            
            
            
            UIImageView *tick = (UIImageView *)[cell viewWithTag:112];
            tick.hidden=1;
            
            
            
            if ([searchDataPlayerOne containsObject:playerID]) {
                
                tick.hidden=0;
                
            } else {
                
                tick.hidden=1;
                
            }
            
            if (indexPath.row % 2) {
                [cell setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1]];
            } else {
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            
            /*
            UIImageView *tickNotTicked = (UIImageView *)[cell viewWithTag:9910];
            
            if (IS_IPHONE5) {
                
                [tickNotTicked setFrame:CGRectMake(250, tick.frame.origin.y, tick.frame.size.width, tick.frame.size.height)];
                [tick setFrame:CGRectMake(250, tick.frame.origin.y, tick.frame.size.width, tick.frame.size.height)];
            } else {
                
                [tickNotTicked setFrame:CGRectMake(200, tick.frame.origin.y, tick.frame.size.width, tick.frame.size.height)];
                [tick setFrame:CGRectMake(200, tick.frame.origin.y, tick.frame.size.width, tick.frame.size.height)];
            }
             */

            
            
            return cell;
        }
        
        
    } else {
        
        if (isSecondTableFiltered) {
        
            static NSString *CellIdentifer = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
            }
            
            NSString *playerID = [[searchedDataSecond objectAtIndex:indexPath.row] objectForKey:@"teamID"];
            
            UILabel *playerTwo = (UILabel *)[cell viewWithTag:101];
            [playerTwo setText:[NSString stringWithFormat:@"%@", [[[searchedDataSecond objectAtIndex:indexPath.row] objectForKey:@"teamName"] capitalizedString]]];
            //[playerTwo setTextAlignment:NSTextAlignmentCenter];
            playerTwo.minimumScaleFactor = 0.3;
            playerTwo.adjustsFontSizeToFitWidth = YES;
            
            
            UIImageView *tick = (UIImageView *)[cell viewWithTag:122];
            tick.hidden=1;
            
            UIImageView *teamLogo = (UIImageView *)[cell viewWithTag:992];
            NSString *logName = [[searchedDataSecond objectAtIndex:indexPath.row]objectForKey:@"logoID"];
            logName = [logName stringByReplacingOccurrencesOfString:@"NULL" withString:@"default"];
            [teamLogo setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", logName]]];
            
            
            if ([searchDataPlayerTwo containsObject:playerID]) {
                tick.hidden=0;
            } else {
                tick.hidden=1;
            }
            
            if (indexPath.row % 2) {
                [cell setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1]];
            } else {
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            
            /*
            UIImageView *tickNotTicked = (UIImageView *)[cell viewWithTag:9910];
            
            if (IS_IPHONE5) {
                
                [tickNotTicked setFrame:CGRectMake(250, tick.frame.origin.y, tick.frame.size.width, tick.frame.size.height)];
                [tick setFrame:CGRectMake(250, tick.frame.origin.y, tick.frame.size.width, tick.frame.size.height)];
            } else {
                
                [tickNotTicked setFrame:CGRectMake(200, tick.frame.origin.y, tick.frame.size.width, tick.frame.size.height)];
                [tick setFrame:CGRectMake(200, tick.frame.origin.y, tick.frame.size.width, tick.frame.size.height)];
            }
             */
            
            return cell;
            
        } else {
            
            static NSString *CellIdentifer = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
            }
            
            NSString *playerID = [[playerDataTableTwo objectAtIndex:indexPath.row] objectForKey:@"teamID"];
            
            UILabel *playerTwo = (UILabel *)[cell viewWithTag:101];
            [playerTwo setText:[NSString stringWithFormat:@"%@", [[[playerDataTableTwo objectAtIndex:indexPath.row] objectForKey:@"teamName"] capitalizedString]]];
            
            //[playerTwo setTextAlignment:NSTextAlignmentCenter];
            
            playerTwo.minimumScaleFactor = 0.3;
            playerTwo.adjustsFontSizeToFitWidth = YES;
            
            UIImageView *teamLogo = (UIImageView *)[cell viewWithTag:992];
            NSString *logName = [[playerDataTableTwo objectAtIndex:indexPath.row]objectForKey:@"logoID"];
            logName = [logName stringByReplacingOccurrencesOfString:@"NULL" withString:@"default"];
            [teamLogo setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", logName]]];
            
            
            UIImageView *tick = (UIImageView *)[cell viewWithTag:122];
            tick.hidden=1;
            
            
            if ([searchDataPlayerTwo containsObject:playerID]) {
                tick.hidden=0;
            } else {
                tick.hidden=1;
            }
            
            if (indexPath.row % 2) {
                [cell setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1]];
            } else {
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            
            UIImageView *tickNotTicked = (UIImageView *)[cell viewWithTag:9910];
            /*
            if (IS_IPHONE5) {
                
                [tickNotTicked setFrame:CGRectMake(250, tick.frame.origin.y, tick.frame.size.width, tick.frame.size.height)];
                [tick setFrame:CGRectMake(250, tick.frame.origin.y, tick.frame.size.width, tick.frame.size.height)];
            } else {
                
                [tickNotTicked setFrame:CGRectMake(200, tick.frame.origin.y, tick.frame.size.width, tick.frame.size.height)];
                [tick setFrame:CGRectMake(200, tick.frame.origin.y, tick.frame.size.width, tick.frame.size.height)];
            }
             */

            
            return cell;
        }
        
        
    }
    
}

#pragma mark Search bar delegates
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setText:@""];
    [searchBar resignFirstResponder];
    
    if (searchBar == searchBarTableOne) {
        isFirstTableFiltered = NO;
        [_playerOneTableView reloadData];
        
    } else {
        isSecondTableFiltered = NO;
        [_playerTwoTableView reloadData];
        
    }
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar == searchBarTableOne) {
        
        
        if (searchText.length == 0)
            isFirstTableFiltered = NO;
        else
            isFirstTableFiltered = YES;
        
        NSMutableArray *tmpSearched = [[NSMutableArray alloc] init];
        
        for(int i=0; i < [playerDataTableOne count]; i++) {
            
            NSString *totalString = [NSString stringWithFormat:@"%@",[[playerDataTableOne objectAtIndex:i]objectForKey:@"teamName"]];
            
            
            //we are going for case insensitive search here
            NSRange range = [totalString rangeOfString:searchText
                                               options:NSCaseInsensitiveSearch];
            
            if (range.location != NSNotFound)
                [tmpSearched addObject:[playerDataTableOne objectAtIndex:i]];
            
            
        }
        
        searchedDataFirst = tmpSearched.copy;
        
        [_playerOneTableView reloadData];
        
    } else if (searchBar == searchBarTableTwo) {
        
        
        if (searchText.length == 0)
            isSecondTableFiltered = NO;
        else
            isSecondTableFiltered = YES;
        
        NSMutableArray *tmpSearched = [[NSMutableArray alloc] init];
        
        for(int i=0; i < [playerDataTableTwo count]; i++) {
            
            NSString *totalString = [NSString stringWithFormat:@"%@",[[playerDataTableTwo objectAtIndex:i]objectForKey:@"teamName"]];
            
            
            //we are going for case insensitive search here
            NSRange range = [totalString rangeOfString:searchText
                                               options:NSCaseInsensitiveSearch];
            
            if (range.location != NSNotFound)
                [tmpSearched addObject:[playerDataTableTwo objectAtIndex:i]];
            
        }
        
        searchedDataSecond = tmpSearched.copy;
        
        [_playerTwoTableView reloadData];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)next:(id)sender {
    
    if ([searchDataPlayerOne count] != 1) {
        
        UIAlertView *alertV = [[UIAlertView alloc]
                               initWithTitle:@"Team One" message:@"Please choose team one." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertV show];
        
        return;
    }
    
    if ([searchDataPlayerTwo count] != 1) {
        
        UIAlertView *alertV = [[UIAlertView alloc]
                               initWithTitle:@"Team Two" message:@"Please choose team two." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertV show];
        
        return;
    }
    
    //They may want to compare 2 players in the same team, so lets leave this out
    /*
    if ([searchDataPlayerOne isEqual:searchDataPlayerTwo]) {
        UIAlertView *alertV = [[UIAlertView alloc]
                               initWithTitle:@"Teams" message:@"You cannot compare the same teams!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertV show];
        
        return;
    }
     */
    
    [[NSUserDefaults standardUserDefaults]setObject:[searchDataPlayerOne objectAtIndex:0] forKey:@"teamOneIDCarryPlayerVs"];
    [[NSUserDefaults standardUserDefaults]setObject:[searchDataPlayerTwo objectAtIndex:0] forKey:@"teamTwoIDCarryPlayerVs"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self performSegueWithIdentifier:@"legToPv" sender:self];
    
}
- (IBAction)selectLeague:(id)sender {
    
    [UIView animateWithDuration:0.7 animations:^{
        [_entirePickerView setAlpha:1.0];
    }];
    
    [searchBarTableOne resignFirstResponder];
    [searchBarTableTwo resignFirstResponder];
    
}

- (IBAction)closePickerView:(id)sender {
    
    [UIView animateWithDuration:0.7 animations:^{
        [_entirePickerView setAlpha:0.0];
    }];
    
    [_playerOneTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [_playerTwoTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

#pragma mark Pickerview Delegate Methods
//UIPickerView delegate methods
- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    selectedLeagueID =  [[NSUserDefaults standardUserDefaults]objectForKey:@"leagueID"];
    
    [leagueTitle setText:[[leagueDivisionData objectAtIndex:row]objectForKey:@"name"]];
    leagueTitle.minimumScaleFactor = 0.3;
    leagueTitle.adjustsFontSizeToFitWidth = YES;
    
    if ([leagueTitle.text isEqualToString:@"All Leagues"]) {
        
        playerDataTableOne = [[FootballFormDB sharedInstance]getTeamsPerLeagueAndHaveNameReturned:selectedLeagueID];
        playerDataTableTwo = [playerDataTableOne mutableCopy];
        
    } else {
        
        playerDataTableOne = [[FootballFormDB sharedInstance]getTeamsPerLeagueAndHaveNameReturned:selectedLeagueID];
        playerDataTableTwo = [playerDataTableOne mutableCopy];
        
    }
    
    [_playerOneTableView reloadData];
    [_playerTwoTableView reloadData];
    
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [leagueDivisionData count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[leagueDivisionData objectAtIndex:row]objectForKey:@"name"];
}

#pragma mark iAd Delegate Methods

/*
// Method is called when the iAd is loaded.
-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    /*
    [_playerOneTableView setFrame:CGRectMake(_playerOneTableView.frame.origin.x, _playerOneTableView.frame.origin.y, _playerOneTableView.frame.size.width, 230-bannerView.frame.size.height)];
    [_playerTwoTableView setFrame:CGRectMake(_playerTwoTableView.frame.origin.x, _playerTwoTableView.frame.origin.y, _playerTwoTableView.frame.size.width, 230-bannerView.frame.size.height)];
    */

/*
    float tvHeight1 = self.view.frame.size.height-_playerOneTableView.frame.origin.y;
    
    [_playerOneTableView setFrame:CGRectMake(_playerOneTableView.frame.origin.x, _playerOneTableView.frame.origin.y, _playerOneTableView.frame.size.width, tvHeight1-bannerView.frame.size.height)];
    
    
    float tvHeight2 = self.view.frame.size.height-_playerTwoTableView.frame.origin.y;
    
    [_playerTwoTableView setFrame:CGRectMake(_playerTwoTableView.frame.origin.x, _playerTwoTableView.frame.origin.y, _playerTwoTableView.frame.size.width, tvHeight2-bannerView.frame.size.height)];

    
    
    [bannerView setFrame:CGRectMake(bannerView.frame.origin.x, self.view.frame.size.height-bannerView.frame.size.height, self.view.frame.size.width, bannerView.frame.size.height)];
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1];
    
    
    [banner setAlpha:1];
    
    [UIView commitAnimations];
    
    hasGotAd=YES;
    
}
 
 */

/*
// Method is called when the iAd fails to load.
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    /*
    [_playerOneTableView setFrame:CGRectMake(_playerOneTableView.frame.origin.x, _playerOneTableView.frame.origin.y, _playerOneTableView.frame.size.width, 230)];
    [_playerTwoTableView setFrame:CGRectMake(_playerTwoTableView.frame.origin.x, _playerTwoTableView.frame.origin.y, _playerTwoTableView.frame.size.width, 230)];
     */
    /*
    float tvHeight1 = self.view.frame.size.height-_playerOneTableView.frame.origin.y;
    
    [_playerOneTableView setFrame:CGRectMake(_playerOneTableView.frame.origin.x, _playerOneTableView.frame.origin.y, _playerOneTableView.frame.size.width, tvHeight1)];
    
    float tvHeight2 = self.view.frame.size.height-_playerTwoTableView.frame.origin.y;
    
    [_playerTwoTableView setFrame:CGRectMake(_playerTwoTableView.frame.origin.x, _playerTwoTableView.frame.origin.y, _playerTwoTableView.frame.size.width, tvHeight2)];

    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1];
    
    [banner setAlpha:0];
    
    
    [UIView commitAnimations];
    
    hasGotAd=NO;
    
}
     */



- (IBAction)invokePeek:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    [revealController showViewController:revealController.leftViewController];
    
}
@end
