//
//  CompareViewController.m
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import "CompareViewController.h"
#import "FootballFormDB.h"
@interface CompareViewController ()

@end

@implementation CompareViewController

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
    
    [self setUpTabBar];
    
    [_entirePickerview setAlpha:0.0];
    [_entirePickerview setFrame:CGRectMake(0, 0, 568, 320)];
    
    leagues = [[FootballFormDB sharedInstance]getLeagues];
    currentLeague = [[leagues objectAtIndex:0]objectForKey:@"name"];
    leagueNameText.text = currentLeague;
    selectedLeagueID = [[leagues objectAtIndex:0]objectForKey:@"leagueID"];
    leagueNameText.minimumScaleFactor = 0.3;
    leagueNameText.adjustsFontSizeToFitWidth = YES;

    
    //listOfTeams = [[FootballFormDB sharedInstance]listOfTeams];
    
    listOfTeams = [[FootballFormDB sharedInstance]getTeamsPerLeagueAndHaveNameReturned:selectedLeagueID];
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
    
    [[NSUserDefaults standardUserDefaults]setObject:selectedTeamIDOne forKey:@"compareTeamOneID"];
    [[NSUserDefaults standardUserDefaults]setObject:selectedTeamIDTwo forKey:@"compareTeamTwoID"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self performSegueWithIdentifier:@"goToGraphView" sender:self];
    
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
        [teamName setText:[[listOfTeams objectAtIndex:indexPath.row]objectForKey:@"teamName"]];
        teamName.minimumScaleFactor = 0.3;
        teamName.adjustsFontSizeToFitWidth = YES;
        
        UIImageView *tickBox = (UIImageView *)[cell viewWithTag:202];
        tickBox.hidden=1;
        
        if ([selectedTeamIDOne isEqualToString:[[listOfTeams objectAtIndex:indexPath.row]objectForKey:@"teamID"]]) {
            tickBox.hidden=0;
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
        [teamName setText:[[listOfTeams objectAtIndex:indexPath.row]objectForKey:@"teamName"]];
        teamName.minimumScaleFactor = 0.3;
        teamName.adjustsFontSizeToFitWidth = YES;
        
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

        
        
        return cell;
        
    }
    
}

@end
