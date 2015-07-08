
//
//  LiveScoresViewController.m
//  Football Form
//
//  Created by Aaron Wilkinson on 16/04/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import "LiveScoresViewController.h"
#import <iAd/iAd.h>
@interface LiveScoresViewController ()

@end

@implementation LiveScoresViewController

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
    
    refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor grayColor];
    [refresh addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:refresh];
    
    //Listen for NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ll)
                                                 name:@"FootballForm:PKWillRefresh"
                                               object:nil];
    
    self.canDisplayBannerAds = YES;
    
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [_tableView reloadData];
        
}

-(void)ll {
    
    gameData=nil;
    [self viewDidAppear:YES];
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"FootballForm:PKWillRefresh" object:nil];
    
}



-(void)viewDidAppear:(BOOL)animated {
    
    NSString *openedFromWidget = [[NSUserDefaults standardUserDefaults]objectForKey:@"FootballForm:OpenURL"];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"FootballForm:OpenURL"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    if (openedFromWidget) {
        
        NSString *lastPart = [openedFromWidget lastPathComponent];
        
        if (lastPart) {
            
            if ([lastPart isEqualToString:@"no"]) {
                
                [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(viewDid) userInfo:nil repeats:NO];

            } else {
                
                tempMatchID = lastPart;
                [self performSegueWithIdentifier:@"lsTolsd" sender:self];
                
            }
            
        } else {
            
            [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(viewDid) userInfo:nil repeats:NO];

        }
        
    } else {
        
        [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(viewDid) userInfo:nil repeats:NO];

    }

}


-(void)viewDid {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    [revealController setRecognizesPanningOnFrontView:YES];
    
    if (gameData==nil) {
        
        [[API sharedAPI]setCurrentViewController:self];
        [API getLiveScores:@"GET_GAMES" complete:^(NSDictionary *userData) {
            
            gameData = [[userData objectForKey:@"data"] objectForKey:@"match_data"];
            
            if ([gameData count]==0) {
                
                NSString *message = userData[@"data"][@"message"];
                NSString *titleAlert = userData[@"data"][@"title"];
                
                if (message&&titleAlert) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleAlert message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert setTag:101];
                    [alert show];
                    
                } else {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Live Scores" message:@"Sorry, no games are available at this time." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert setTag:101];
                    [alert show];
                    
                }
            }
            
            [self sortLeagueData];
            
            [_tableView reloadData];
            
        } failed:^(id JSON) {
            NSLog(@"%@", JSON);
        }];
    }
}

-(void)sortLeagueData {
    
    alphabet = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];

    
    leagueNames = [NSMutableArray new];
    
    for (NSDictionary *dicty in gameData) {
        
        NSString *leagueName = dicty[@"league_name"];
        
        if (![leagueNames containsObject:leagueName]) [leagueNames addObject:leagueName];
        
    }
    
    //Here I am resorting the array so we can use tableview sections
    
    sortedData = [NSMutableArray new];
    
    for (NSString *leagueNombre in leagueNames) {
        
        NSMutableArray *games = [NSMutableArray new];
        
        for (NSDictionary *game in gameData) {
            
            NSString *lname = game[@"league_name"];
            
            if ([lname isEqualToString:leagueNombre]) {
            
                if (![games containsObject:game]) {
                    [games addObject:game];
                }
                
            }
        }
        
        [sortedData addObject:@{leagueNombre : games}];
        
    }
    
    NSLog(@"%@", sortedData);
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag ==101) {
        
        if (buttonIndex == 0) {
            
            [self showPeek:nil];
            
        } else if (buttonIndex == 1) {
            
        }
        
    }
    
}

-(void)loadData {
    
    [[API sharedAPI]setCurrentViewController:self];
    [API getLiveScoresWithoutSpinner:@"GET_GAMES" complete:^(NSDictionary *userData) {
        
        gameData = [[userData objectForKey:@"data"] objectForKey:@"match_data"];
        
        [self sortLeagueData];
        
        [_tableView reloadData];
        
        [refresh endRefreshing];
        
    } failed:^(id JSON) {
        
        [refresh endRefreshing];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"lsTolsd"]) {
        LiveScoresDetailViewController *controller = segue.destinationViewController;
        [controller setMatchID:tempMatchID];
    }
}

#pragma mark UITableView Delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *sectionTitle = [leagueNames objectAtIndex:indexPath.section];
    
    NSArray *sectionArray = [sortedData[indexPath.section] objectForKey:sectionTitle];
    
    NSDictionary *sectionData = sectionArray[indexPath.row];
    
    NSString *staType = [sectionData objectForKey:@"status_type"];
    
    if ([staType isEqualToString:@"live"] || [staType isEqualToString:@"fin"]) {
    
        tempMatchID = [sectionData objectForKey:@"id"];
        [self performSegueWithIdentifier:@"lsTolsd" sender:self];
        
    }
    
}

/*- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [gameData count];
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Dont forget to change the cell identifier in the storyboard/xib file
    static NSString *CellIdentifer = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
    
    UILabel *homeTeamName = (UILabel *)[cell viewWithTag:101];
    UILabel *score = (UILabel *)[cell viewWithTag:102];
    UILabel *awayTeamName = (UILabel *)[cell viewWithTag:103];
    UILabel *scoreLive = (UILabel *)[cell viewWithTag:110];
    UILabel *timeLive = (UILabel *)[cell viewWithTag:120];
    
    UILabel *leagueName = (UILabel *)[cell viewWithTag:201];
    
    UIImageView *rightBg = (UIImageView *)[cell viewWithTag:12345];
    rightBg.image = [rightBg.image resizableImageWithCapInsets:UIEdgeInsetsMake(4, 25, 4, 25)];
    
    UIImageView *leftBg = (UIImageView *)[cell viewWithTag:190];
    leftBg.image = [leftBg.image resizableImageWithCapInsets:UIEdgeInsetsMake(4, 25, 4, 25)];
    
    if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        
        [score setFont:[UIFont systemFontOfSize:10]];
        [scoreLive setFont:[UIFont systemFontOfSize:13]];
        [timeLive setFont:[UIFont systemFontOfSize:9]];

        
    } else {
        
        [score setFont:[UIFont systemFontOfSize:17]];
        [scoreLive setFont:[UIFont systemFontOfSize:17]];
        [timeLive setFont:[UIFont systemFontOfSize:13]];

        
    }

    NSString *sectionTitle = [leagueNames objectAtIndex:indexPath.section];

    NSArray *sectionArray = [sortedData[indexPath.section] objectForKey:sectionTitle];

    NSDictionary *sectionData = sectionArray[indexPath.row];

    NSString *lName = [sectionData objectForKey:@"league_name"];
    [leagueName setText:lName.uppercaseString];
    
    NSString *scoreText = [sectionData objectForKey:@"score"];
    NSString *statusType = [sectionData objectForKey:@"status_type"];
    NSString *startTime = [sectionData objectForKey:@"start_time"];

    if (scoreText.length==0) {
        scoreText = @"0-0";
    }
    
    if ([statusType isEqualToString:@"sched"]) {
        scoreText = startTime;
    }
    
    [homeTeamName setText:[sectionData objectForKey:@"team_home_name"]];
    [score setText:scoreText];
    [awayTeamName setText:[sectionData objectForKey:@"team_away_name"]];
    
    if ([statusType isEqualToString:@"live"]) {

        [scoreLive setText:scoreText];
        [timeLive setText:startTime];
        
        scoreLive.hidden=0;
        timeLive.hidden=0;
        score.hidden=1;
        
    } else {

        scoreLive.hidden=1;
        timeLive.hidden=1;
        score.hidden=0;
        
    }
    
    if ([statusType isEqualToString:@"fin"]) {
        [score setText:[NSString stringWithFormat:@"%@ FT", score.text]];
        
        if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
            [score setFont:[UIFont systemFontOfSize:13]];
        } else {
            [score setFont:[UIFont systemFontOfSize:17]];
        }
        

    }

    return cell;
}


- (IBAction)showPeek:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    [revealController showViewController:revealController.leftViewController];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [leagueNames count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [leagueNames objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *sectionTitle = [leagueNames objectAtIndex:section];
    NSArray *sectionAnimals = [sortedData[section] objectForKey:sectionTitle];
    return [sectionAnimals count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    
    NSString *string =[leagueNames objectAtIndex:section];
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1]];
    
    return view;
}

/*- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return alphabet;
}*/

@end
