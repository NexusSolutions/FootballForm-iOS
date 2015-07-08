//
//  PlayerVsViewController.m
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import "PlayerVsViewController.h"
#import "FootballFormDB.h"
#import <iAd/iAd.h>

@interface PlayerVsViewController ()

@end

@implementation PlayerVsViewController

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
        [navvy setFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.height-navvy.frame.size.width)-10, navvy.frame.origin.y, navvy.frame.size.width, navvy.frame.size.height)];
        [playerVsLabel setFrame:CGRectMake(208,  playerVsLabel.frame.origin.y, playerVsLabel.frame.size.width, playerVsLabel.frame.size.height)];
        [leagueTitle setFrame:CGRectMake(115,  leagueTitle.frame.origin.y, leagueTitle.frame.size.width, leagueTitle.frame.size.height)];
        [selPlLab setFrame:CGRectMake(200,  selPlLab.frame.origin.y, selPlLab.frame.size.width, selPlLab.frame.size.height)];

    }
     */
    
    self.canDisplayBannerAds = YES;
    
    [self checkRotation];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [searchBarTableTwo resignFirstResponder];
    [searchBarTableOne resignFirstResponder];
    
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


-(void)viewWillAppear:(BOOL)animated {
    
    [self setUpTabBar];
    
    isFirstTableFiltered = NO;
    isSecondTableFiltered = NO;
    
    searchDataPlayerOne = [NSMutableArray new];
    searchDataPlayerTwo = [NSMutableArray new];
    
    NSString *lido = [[NSUserDefaults standardUserDefaults]objectForKey:@"FootballForm:PlayerVsLeagueIDT1"];
    NSString *lidT = [[NSUserDefaults standardUserDefaults]objectForKey:@"FootballForm:PlayerVsLeagueIDT2"];

    playerDataTableOne = [[FootballFormDB sharedInstance]getAllPlayersInATeam:[[NSUserDefaults standardUserDefaults] objectForKey:@"teamOneIDCarryPlayerVs"] leagueID:lido];
    
    NSString *string = [NSString stringWithFormat:@"%@ - %@", [[[FootballFormDB sharedInstance] giveATeamIDAndGetANameBack:[[NSUserDefaults standardUserDefaults] objectForKey:@"teamOneIDCarryPlayerVs"]] capitalizedString],[[[FootballFormDB sharedInstance] giveATeamIDAndGetANameBack:[[NSUserDefaults standardUserDefaults] objectForKey:@"teamTwoIDCarryPlayerVs"]] capitalizedString]];

    [leagueTitle setText:string];
    [leagueTitle setAdjustsFontSizeToFitWidth:YES];
    [leagueTitle setMinimumScaleFactor:0.3];

    playerDataTableTwo = [[FootballFormDB sharedInstance]getAllPlayersInATeam:[[NSUserDefaults standardUserDefaults] objectForKey:@"teamTwoIDCarryPlayerVs"] leagueID:lidT];
    
    [_playerOneTableView reloadData];
    [_playerTwoTableView reloadData];
    
    if ([playerDataTableOne count]==0&&[playerDataTableTwo count]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Players" message:@"Sorry, it doesn't look like we have any player data for these teams." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setTag:101];
        [alert show];
    }

    /*
    int width;
    if (IS_IPHONE5) {
        width = 283;
        
        [searchBarTableOne setFrame:CGRectMake(0, 44, 283, 44)];
        [_playerOneTableView setFrame:CGRectMake(0, 88, 283, 232)];
        [searchBarTableTwo setFrame:CGRectMake(285, 44, 283, 44)];
        [_playerTwoTableView setFrame:CGRectMake(285, 88, 283, 232)];
    
    } else {
        width = 239;
        
        [searchBarTableOne setFrame:CGRectMake(0, 44, width, 44)];
        [_playerOneTableView setFrame:CGRectMake(0, 90, width, 232)];
        [searchBarTableTwo setFrame:CGRectMake(241, 44, width, 44)];
        [_playerTwoTableView setFrame:CGRectMake(241, 90, width, 232)];
    }
     */
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"FootballForm:PKWillRefresh" object:nil];
    
    //Listen for NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(back:)
                                                 name:@"FootballForm:PKWillRefresh"
                                               object:nil];


    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag ==101) {
        
        if (buttonIndex == 0) {
        
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"FootballForm:PKWillRefresh" object:nil];

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
            
        NSString *playerID = [[searchedDataFirst objectAtIndex:indexPath.row] objectForKey:@"player_id"];
        
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
            
            NSString *playerID = [[playerDataTableOne objectAtIndex:indexPath.row] objectForKey:@"player_id"];
            
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
            
            NSString *playerID = [[searchedDataSecond objectAtIndex:indexPath.row] objectForKey:@"player_id"];
            
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
            
            NSString *playerID = [[playerDataTableTwo objectAtIndex:indexPath.row] objectForKey:@"player_id"];
            
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
            NSString *playerID = [[searchedDataFirst objectAtIndex:indexPath.row] objectForKey:@"player_id"];
            NSString *goals = [[searchedDataFirst objectAtIndex:indexPath.row] objectForKey:@"goals_scored"];

            //101 is home, 102 is away
            
            UILabel *playerOne = (UILabel *)[cell viewWithTag:101];
            [playerOne setText:[NSString stringWithFormat:@"%@ %@", goals, [[[searchedDataFirst objectAtIndex:indexPath.row] objectForKey:@"player_name"] capitalizedString]]];
            //[playerOne setTextAlignment:NSTextAlignmentCenter];
            playerOne.minimumScaleFactor = 0.3;
            playerOne.adjustsFontSizeToFitWidth = YES;
            
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
             NSString *playerID = [[playerDataTableOne objectAtIndex:indexPath.row] objectForKey:@"player_id"];
            NSString *goals = [[playerDataTableOne objectAtIndex:indexPath.row] objectForKey:@"goals_scored"];

         //101 is home, 102 is away
    
         UILabel *playerOne = (UILabel *)[cell viewWithTag:101];
         [playerOne setText:[NSString stringWithFormat:@"%@ %@", goals, [[[playerDataTableOne objectAtIndex:indexPath.row] objectForKey:@"player_name"] capitalizedString]]];
         //[playerOne setTextAlignment:NSTextAlignmentCenter];
         playerOne.minimumScaleFactor = 0.3;
         playerOne.adjustsFontSizeToFitWidth = YES;
        
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
        
        NSString *playerID = [[searchedDataSecond objectAtIndex:indexPath.row] objectForKey:@"player_id"];
        NSString *goals = [[searchedDataSecond objectAtIndex:indexPath.row] objectForKey:@"goals_scored"];

        
        UILabel *playerTwo = (UILabel *)[cell viewWithTag:101];
        [playerTwo setText:[NSString stringWithFormat:@"%@ %@", goals, [[[searchedDataSecond objectAtIndex:indexPath.row] objectForKey:@"player_name"] capitalizedString]]];
        //[playerTwo setTextAlignment:NSTextAlignmentCenter];
        playerTwo.minimumScaleFactor = 0.3;
        playerTwo.adjustsFontSizeToFitWidth = YES;
        
        
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
        
    } else {
        
        static NSString *CellIdentifer = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
        }
        
        NSString *playerID = [[playerDataTableTwo objectAtIndex:indexPath.row] objectForKey:@"player_id"];
        NSString *goals = [[playerDataTableTwo objectAtIndex:indexPath.row] objectForKey:@"goals_scored"];

        
        UILabel *playerTwo = (UILabel *)[cell viewWithTag:101];
        [playerTwo setText:[NSString stringWithFormat:@"%@ %@", goals, [[[playerDataTableTwo objectAtIndex:indexPath.row] objectForKey:@"player_name"] capitalizedString]]];
        //[playerTwo setTextAlignment:NSTextAlignmentCenter];
        playerTwo.minimumScaleFactor = 0.3;
        playerTwo.adjustsFontSizeToFitWidth = YES;
        
        
        UIImageView *tick = (UIImageView *)[cell viewWithTag:122];
        tick.hidden=1;
        
        
        if ([searchDataPlayerTwo containsObject:playerID]) {
            tick.hidden=0;
        } else {
            tick.hidden=1;
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

        
        if (indexPath.row % 2) {
            [cell setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1]];
        } else {
            [cell setBackgroundColor:[UIColor whiteColor]];
        }
        
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
            
            NSString *totalString = [NSString stringWithFormat:@"%@ (%@)",[[[playerDataTableOne objectAtIndex:i]objectForKey:@"player_name"] capitalizedString], [[[playerDataTableOne objectAtIndex:i]objectForKey:@"team_name"] capitalizedString]];
            totalString = [totalString stringByReplacingOccurrencesOfString:@" Fc" withString:@" FC"];
    
        
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
            
            NSString *totalString = [NSString stringWithFormat:@"%@ (%@)",[[[playerDataTableTwo objectAtIndex:i]objectForKey:@"player_name"] capitalizedString], [[[playerDataTableTwo objectAtIndex:i]objectForKey:@"team_name"] capitalizedString]];
            totalString = [totalString stringByReplacingOccurrencesOfString:@" Fc" withString:@" FC"];

            
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
                               initWithTitle:@"Choose" message:@"Please choose player one." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertV show];
        
        return;
    }
    
    if ([searchDataPlayerTwo count] != 1) {
        
        UIAlertView *alertV = [[UIAlertView alloc]
                               initWithTitle:@"Choose" message:@"Please choose player two." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertV show];
        
        return;
    }
    
    if ([searchDataPlayerOne isEqual:searchDataPlayerTwo]) {
        UIAlertView *alertV = [[UIAlertView alloc]
                               initWithTitle:@"Players" message:@"You cannot compare the same players!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertV show];
        
        return;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:searchDataPlayerOne forKey:@"playerOneDataCarry"];
    [[NSUserDefaults standardUserDefaults]setObject:searchDataPlayerTwo forKey:@"playerTwoDataCarry"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self performSegueWithIdentifier:@"toPlayerCompare" sender:self];

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
    
    selectedLeagueID =  [[leagueDivisionData objectAtIndex:row]objectForKey:@"leagueID"];
    
    [leagueTitle setText:[[leagueDivisionData objectAtIndex:row]objectForKey:@"name"]];
    leagueTitle.minimumScaleFactor = 0.3;
    leagueTitle.adjustsFontSizeToFitWidth = YES;

    if ([leagueTitle.text isEqualToString:@"All Leagues"]) {
        
        playerDataTableOne = [[FootballFormDB sharedInstance]getAllPlayers];
        playerDataTableTwo = [playerDataTableOne mutableCopy];
        
    } else {
        
        playerDataTableOne = [[FootballFormDB sharedInstance]getPlayersPerLeague:selectedLeagueID];
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

// Method is called when the iAd is loaded.
-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    float tvHeight1 = self.view.frame.size.height-_playerOneTableView.frame.origin.y;
    float tvHeight2 = self.view.frame.size.height-_playerTwoTableView.frame.origin.y;

    [_playerOneTableView setFrame:CGRectMake(_playerOneTableView.frame.origin.x, _playerOneTableView.frame.origin.y, _playerOneTableView.frame.size.width, tvHeight1-bannerView.frame.size.height)];
    [_playerTwoTableView setFrame:CGRectMake(_playerTwoTableView.frame.origin.x, _playerTwoTableView.frame.origin.y, _playerTwoTableView.frame.size.width, tvHeight2-bannerView.frame.size.height)];
    
    
    [bannerView setFrame:CGRectMake(bannerView.frame.origin.x, self.view.frame.size.height-bannerView.frame.size.height, self.view.frame.size.width, bannerView.frame.size.height)];
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1];
    
    
    [banner setAlpha:1];
    
    [UIView commitAnimations];
    
    hasGotAd=YES;
    
}

// Method is called when the iAd fails to load.
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
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

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
@end
