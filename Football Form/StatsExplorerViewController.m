//
//  StatsExplorerViewController.m
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import "StatsExplorerViewController.h"
#import "FootballFormDB.h"
#import "AsyncImageView.h"
@interface StatsExplorerViewController ()

@end

@implementation StatsExplorerViewController

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

    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}


-(void)viewWillAppear:(BOOL)animated {
    
    if (listOfTeams==nil) {
    
        [self setUpTabBar];

        [_entirePickerview setAlpha:0.0];
        [_entirePickerview setFrame:CGRectMake(0, 0, 568, 320)];

        leagues = [[FootballFormDB sharedInstance]getLeagues];


        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"statExplorerCurrentLeagueName"]==nil) {
            currentLeague = [[leagues objectAtIndex:0]objectForKey:@"name"];
            leagueNameText.text = currentLeague;
            leagueNameText.minimumScaleFactor = 0.3;
            leagueNameText.adjustsFontSizeToFitWidth = YES;
            selectedLeagueID = [[leagues objectAtIndex:0]objectForKey:@"leagueID"];
            
        } else {
            
            currentLeague = [[NSUserDefaults standardUserDefaults]objectForKey:@"statExplorerCurrentLeagueName"];
            leagueNameText.text = currentLeague;
            leagueNameText.minimumScaleFactor = 0.3;
            leagueNameText.adjustsFontSizeToFitWidth = YES;
            selectedLeagueID = [[NSUserDefaults standardUserDefaults]objectForKey:@"statExplorerCurrentLeagueID"];

        }


        //listOfTeams = [[FootballFormDB sharedInstance]listOfTeams];

        listOfTeams = [[FootballFormDB sharedInstance]getTeamsPerLeagueAndHaveNameReturned:selectedLeagueID];

        int width;
        if (IS_IPHONE5) {
            width = 283;
            
            [tableViewOne setFrame:CGRectMake(0, 44, 283, 225)];
            [tableViewTwo setFrame:CGRectMake(285, 44, 283, 225)];
            
        } else {
            width = 239;
            
            [selLegNext setFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.height-selLegNext.frame.size.width)-15, selLegNext.frame.origin.y, selLegNext.frame.size.width, selLegNext.frame.size.height)];
            [closeButty setFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.height-closeButty.frame.size.width)-15, closeButty.frame.origin.y, closeButty.frame.size.width, closeButty.frame.size.height)];
            [_pickerView setFrame:CGRectMake(_pickerView.frame.origin.x, _pickerView.frame.origin.y, [[UIScreen mainScreen] bounds].size.height, _pickerView.frame.size.height)];

            [titleView setFrame:CGRectMake(100, -1, 157, 44)];
            

            [tableViewOne setFrame:CGRectMake(0, 44, width, 225)];
            [tableViewTwo setFrame:CGRectMake(241, 44, width, 225)];

        }
        
    }
    
    
   
    
    
    /*
     
     int width;
     if (IS_IPHONE5) {
     width = 283;
     
     [searchBarTableOne setFrame:CGRectMake(0, 44, 283, 44)];
     [_playerOneTableView setFrame:CGRectMake(0, 88, 283, 181)];
     [searchBarTableTwo setFrame:CGRectMake(285, 44, 283, 44)];
     [_playerTwoTableView setFrame:CGRectMake(285, 88, 283, 181)];
     
     } else {
     width = 239;
     
     [searchBarTableOne setFrame:CGRectMake(0, 44, width, 44)];
     [_playerOneTableView setFrame:CGRectMake(0, 90, width, 181)];
     [searchBarTableTwo setFrame:CGRectMake(241, 44, width, 44)];
     [_playerTwoTableView setFrame:CGRectMake(241, 90, width, 181)];
     }

     
     */
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

- (IBAction)hideThePicker:(id)sender {
}

#pragma mark Pickerview delegate

//UIPickerView delegate methods
- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
        currentLeague = [[leagues objectAtIndex:row]objectForKey:@"name"];
        selectedLeagueID = [[leagues objectAtIndex:row]objectForKey:@"leagueID"];
    
    [[NSUserDefaults standardUserDefaults]setObject:currentLeague forKey:@"statExplorerCurrentLeagueName"];
    [[NSUserDefaults standardUserDefaults]setObject:selectedLeagueID forKey:@"statExplorerCurrentLeagueID"];
    [[NSUserDefaults standardUserDefaults]synchronize];

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [leagues count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[leagues objectAtIndex:row]objectForKey:@"name"];
}


- (IBAction)selectLeague:(id)sender {
    
    [_pickerTitle setText:@"Select league"];
    
    
    [UIView animateWithDuration:0.6 animations:^{
        [_entirePickerview setAlpha:1.0];
    }];
    
    [_pickerView reloadAllComponents];
}

- (IBAction)hidePicker:(id)sender {
    
    [UIView animateWithDuration:0.6 animations:^{
        [_entirePickerview setAlpha:0.0];
    }];
    
    listOfTeams = [[FootballFormDB sharedInstance]getTeamsPerLeagueAndHaveNameReturned:selectedLeagueID];
    [tableViewOne reloadData];
    [tableViewTwo reloadData];
    
    leagueNameText.text = currentLeague;
    leagueNameText.minimumScaleFactor = 0.3;
    leagueNameText.adjustsFontSizeToFitWidth = YES;
    
    [tableViewOne scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [tableViewTwo scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];

}

- (IBAction)nextPage:(id)sender {
    
    if (selectedTeamIDOne == nil || [selectedTeamIDOne length]==0) {
        
        UIAlertView *alertV = [[UIAlertView alloc]
                               initWithTitle:@"Team One" message:@"Please choose team one." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertV show];
        return;
    }
    
    
    if (selectedTeamIDTwo == nil || [selectedTeamIDTwo length]==0) {
        
        UIAlertView *alertV = [[UIAlertView alloc]
                               initWithTitle:@"Team Two" message:@"Please choose team two." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertV show];
        return;
    }
    
    
    if ([selectedTeamIDOne isEqualToString:selectedTeamIDTwo]) {
        UIAlertView *alertV = [[UIAlertView alloc]
                               initWithTitle:@"Teams" message:@"You cannot compare the same team!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertV show];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:selectedTeamIDOne forKey:@"statsExplorerTeamOneID"];
    [[NSUserDefaults standardUserDefaults]setObject:selectedTeamIDTwo forKey:@"statsExplorerTeamTwoID"];

    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self performSegueWithIdentifier:@"toPredictor" sender:self];
    
}


#pragma mark Tableview Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableViewOne) {
        
        if ([selectedTeamIDOne isEqualToString:[[listOfTeams objectAtIndex:indexPath.row]objectForKey:@"teamID"]]) {
            
            selectedTeamIDOne = nil;
            
        } else {
            
        selectedTeamIDOne = [[listOfTeams objectAtIndex:indexPath.row]objectForKey:@"teamID"];
            
        }
        
        [tableViewOne reloadData];
        
        
    } else if (tableView == tableViewTwo) {
        
        if ([selectedTeamIDTwo isEqualToString:[[listOfTeams objectAtIndex:indexPath.row]objectForKey:@"teamID"]]) {
            
            selectedTeamIDTwo = nil;
            
        } else {
            
        selectedTeamIDTwo = [[listOfTeams objectAtIndex:indexPath.row]objectForKey:@"teamID"];
            
        }
        [tableViewTwo reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [listOfTeams count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableViewOne) {
        
    
    [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    static NSString *CellIdentifer = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
    
        UILabel *teamName = (UILabel *)[cell viewWithTag:201];
        [teamName setText:[[[listOfTeams objectAtIndex:indexPath.row]objectForKey:@"teamName"] capitalizedString]];
        
        UIImageView *teamLogo = (UIImageView *)[cell viewWithTag:991];
        NSString *logName = [[listOfTeams objectAtIndex:indexPath.row]objectForKey:@"logoID"];
        logName = [logName stringByReplacingOccurrencesOfString:@"NULL" withString:@"default"];
        [teamLogo setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", logName]]];
        
        
        teamName.minimumScaleFactor = 0.3;
        teamName.adjustsFontSizeToFitWidth = YES;
        
        UIImageView *tickBox = (UIImageView *)[cell viewWithTag:202];
        tickBox.hidden=1;
        
        if ([selectedTeamIDOne isEqualToString:[[listOfTeams objectAtIndex:indexPath.row]objectForKey:@"teamID"]]) {
            tickBox.hidden=0;
        }
        
        UIImageView *tickNotTicked = (UIImageView *)[cell viewWithTag:9910];
        
        if (IS_IPHONE5) {
            
            [tickNotTicked setFrame:CGRectMake(250, tickBox.frame.origin.y, tickBox.frame.size.width, tickBox.frame.size.height)];
            [tickBox setFrame:CGRectMake(250, tickBox.frame.origin.y, tickBox.frame.size.width, tickBox.frame.size.height)];
        } else {
            
            [tickNotTicked setFrame:CGRectMake(200, tickBox.frame.origin.y, tickBox.frame.size.width, tickBox.frame.size.height)];
            [tickBox setFrame:CGRectMake(200, tickBox.frame.origin.y, tickBox.frame.size.width, tickBox.frame.size.height)];
        }

        
        if (indexPath.row % 2) {
            [cell setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1]];
        } else {
            [cell setBackgroundColor:[UIColor whiteColor]];
        }



    return cell;
        
    } else {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        static NSString *CellIdentifer = @"Cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
        }
        
        UILabel *teamName = (UILabel *)[cell viewWithTag:203];
        [teamName setText:[[[listOfTeams objectAtIndex:indexPath.row]objectForKey:@"teamName"] capitalizedString]];
        teamName.minimumScaleFactor = 0.3;
        teamName.adjustsFontSizeToFitWidth = YES;
        
        UIImageView *teamLogo = (UIImageView *)[cell viewWithTag:992];
        NSString *logName = [[listOfTeams objectAtIndex:indexPath.row]objectForKey:@"logoID"];
        logName = [logName stringByReplacingOccurrencesOfString:@"NULL" withString:@"default"];
        [teamLogo setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", logName]]];
        
        UIImageView *tickBox = (UIImageView *)[cell viewWithTag:204];
        tickBox.hidden=1;

        if ([selectedTeamIDTwo isEqualToString:[[listOfTeams objectAtIndex:indexPath.row]objectForKey:@"teamID"]]) {
            tickBox.hidden=0;
        }
        
        if (indexPath.row % 2) {
            [cell setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1]];
        } else {
            [cell setBackgroundColor:[UIColor whiteColor]];
        }

        UIImageView *tickNotTicked = (UIImageView *)[cell viewWithTag:9910];
        
        if (IS_IPHONE5) {
            
            [tickNotTicked setFrame:CGRectMake(250, tickBox.frame.origin.y, tickBox.frame.size.width, tickBox.frame.size.height)];
            [tickBox setFrame:CGRectMake(250, tickBox.frame.origin.y, tickBox.frame.size.width, tickBox.frame.size.height)];
        } else {
            
            [tickNotTicked setFrame:CGRectMake(200, tickBox.frame.origin.y, tickBox.frame.size.width, tickBox.frame.size.height)];
            [tickBox setFrame:CGRectMake(200, tickBox.frame.origin.y, tickBox.frame.size.width, tickBox.frame.size.height)];
        }
        
        
        return cell;

    }
    
}


#pragma mark iAd Delegate Methods

// Method is called when the iAd is loaded.
-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    [tableViewOne setFrame:CGRectMake(tableViewOne.frame.origin.x, tableViewOne.frame.origin.y, tableViewOne.frame.size.width, 225-bannerView.frame.size.height)];
    [tableViewTwo setFrame:CGRectMake(tableViewTwo.frame.origin.x, tableViewTwo.frame.origin.y, tableViewTwo.frame.size.width, 225-bannerView.frame.size.height)];
    
    
    [bannerView setFrame:CGRectMake(bannerView.frame.origin.x, bannerView.frame.origin.y, [[UIScreen mainScreen] bounds].size.height, bannerView.frame.size.height)];
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1];
    
    
    [banner setAlpha:1];
    
    [UIView commitAnimations];
    
    hasGotAd=YES;
    
}

// Method is called when the iAd fails to load.
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
    [tableViewOne setFrame:CGRectMake(tableViewOne.frame.origin.x, tableViewOne.frame.origin.y, tableViewOne.frame.size.width, 225)];
    [tableViewTwo setFrame:CGRectMake(tableViewTwo.frame.origin.x, tableViewTwo.frame.origin.y, tableViewTwo.frame.size.width, 225)];
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1];
    
    [banner setAlpha:0];
    
    
    [UIView commitAnimations];
    
    hasGotAd=NO;
    
}

@end
