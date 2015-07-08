//
//  FavouritesViewController.m
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import "FavouritesViewController.h"
#import "FootballFormDB.h"
#import <iAd/iAd.h>

@interface FavouritesViewController ()

@end

@implementation FavouritesViewController

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
    
    self.canDisplayBannerAds = YES;

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    // Then your code...
    
    if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        
        //[teamNameView setFrame:CGRectMake(0, 45, 190, [[UIScreen mainScreen] bounds].size.height-44)];
        
    } else {
        
        //[teamNameView setFrame:CGRectMake(0, 45, 190, 275)];
        
    }
    
    [teamNameView setFrame:CGRectMake(0, 45, 190, teamNameView.frame.size.height)];

}


- (BOOL)prefersStatusBarHidden {
    
    return YES;
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [teamNameViewSV setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    
    [self setUpTabBar];
    
    leagueData =  [[FootballFormDB sharedInstance] getFavouritesInLeagueTable];

    if ([leagueData count]==0) {
        noFavourites.hidden=0;
        _titleView.hidden=1;
        _scrollView.hidden=1;
        teamNameView.hidden=1;
    } else {
        noFavourites.hidden=1;
        _titleView.hidden=0;
        _scrollView.hidden=0;
        teamNameView.hidden=0;
        [self buildTheCells];
    }
    
    [teamNameView setFrame:CGRectMake(0, 45, 190, teamNameView.frame.size.height)];

}

-(void)viewDidAppear:(BOOL)animated {
    [teamNameView setFrame:CGRectMake(0, 45, 190, teamNameView.frame.size.height)];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView==_scrollView) {
        _titleView.frame=CGRectMake(-_scrollView.contentOffset.x, _titleView.frame.origin.y, _titleView.frame.size.width, _titleView.frame.size.height);
        teamNameViewSV.contentOffset=CGPointMake(teamNameViewSV.contentOffset.x, _scrollView.contentOffset.y);
    }
    if (scrollView==teamNameViewSV) {
        _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x, teamNameViewSV.contentOffset.y);
    }
    
}

-(void)buildTheCells {
    
    
    /*
    if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        
        [teamNameView setFrame:CGRectMake(0, 45, 190, [[UIScreen mainScreen] bounds].size.height-44)];
        
    } else {
        
        [teamNameView setFrame:CGRectMake(0, 45, 190, 275)];
        
    }
     */
    
    [teamNameView setFrame:CGRectMake(0, 45, 190, teamNameView.frame.size.height)];


    
    for (UIView *views in _scrollView.subviews) {
        [views removeFromSuperview];
    }
    
    for (UIView *views in teamNameViewSV.subviews) {
        [views removeFromSuperview];
    }
    
    int x = 0;
    int y = 0;
    int index = 0;
    
   [_scrollView setContentSize:CGSizeMake(1525-44, ([leagueData count]*45)-4)];
        
    
    
    [teamNameViewSV setContentSize:CGSizeMake(0, ([leagueData count]*45)-4)];
    
    //Because position has gone, the -4 is moving everything over
    
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"team_name" ascending:true];
    NSArray *sa = [leagueData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    leagueData = [sa mutableCopy];
    
    for (NSDictionary *positionDict in leagueData) {
        
        /*
         gamesDrawn = 3;
         gamesLost = 9;
         gamesPlayed = 17;
         gamesWon = 5;
         positionOverall = 13;
         teamName = Chelsea;
         
         */
        
        //Time to build the view
        UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(x, y, 1048, 45)];
        UIView *cellViewForTeam = [[UIView alloc]initWithFrame:CGRectMake(x, y, 190, 45)];
        if (index % 2) {
            [cellView setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1]];
            [cellViewForTeam setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1]];
        } else {
            [cellView setBackgroundColor:[UIColor whiteColor]];
            [cellViewForTeam setBackgroundColor:[UIColor whiteColor]];
        }
        [_scrollView addSubview:cellView];
        [teamNameViewSV addSubview:cellViewForTeam];
        
        
        //Build the slats
        
        UIImageView *slatTwo = [[UIImageView alloc]initWithFrame:CGRectMake(269+14-44, -58, 1, 900)];
        [slatTwo setBackgroundColor:[UIColor lightGrayColor]];
        [cellView addSubview:slatTwo];
        
        UIImageView *slatThree = [[UIImageView alloc]initWithFrame:CGRectMake(336-44, -58, 1, 900)];
        [slatThree setBackgroundColor:[UIColor lightGrayColor]];
        [cellView addSubview:slatThree];
        
        UIImageView *slatFour = [[UIImageView alloc]initWithFrame:CGRectMake(401-11-44, -58, 1, 900)];
        [slatFour setBackgroundColor:[UIColor lightGrayColor]];
        [cellView addSubview:slatFour];
        
        UIImageView *slatFive = [[UIImageView alloc]initWithFrame:CGRectMake(469-28-44, -58, 1, 900)];
        [slatFive setBackgroundColor:[UIColor lightGrayColor]];
        [cellView addSubview:slatFive];
        
        UIImageView *slatSix = [[UIImageView alloc]initWithFrame:CGRectMake(530-38-44, -58, 1, 900)];
        [slatSix setBackgroundColor:[UIColor lightGrayColor]];
        [cellView addSubview:slatSix];
        
        UIImageView *slatSeven = [[UIImageView alloc]initWithFrame:CGRectMake(592-52-44, -58, 1, 900)];
        [slatSeven setBackgroundColor:[UIColor lightGrayColor]];
        [cellView addSubview:slatSeven];
        
        UIImageView *slatEight = [[UIImageView alloc]initWithFrame:CGRectMake(653-63-44, -58, 1, 900)];
        [slatEight setBackgroundColor:[UIColor lightGrayColor]];
        [cellView addSubview:slatEight];
        
        UIImageView *slatNine = [[UIImageView alloc]initWithFrame:CGRectMake(723-79-44, -58, 1, 900)];
        [slatNine setBackgroundColor:[UIColor lightGrayColor]];
        [cellView addSubview:slatNine];
        
        UIImageView *slatTen = [[UIImageView alloc]initWithFrame:CGRectMake(803-44, -58, 1, 900)];
        [slatTen setBackgroundColor:[UIColor lightGrayColor]];
        [cellView addSubview:slatTen];
        
        UIImageView *slatEleven = [[UIImageView alloc]initWithFrame:CGRectMake(1002-44, -58, 1, 900)];
        [slatEleven setBackgroundColor:[UIColor lightGrayColor]];
        [cellView addSubview:slatEleven];
        
        
        //Now build everything else
        
        UILabel *teamName = [[UILabel alloc]initWithFrame:CGRectMake(7, 12, 178, 21)];
        [teamName setText:[NSString stringWithFormat:@"%@", [positionDict objectForKey:@"team_name"]]];
        [teamName setFont:[UIFont italicSystemFontOfSize:17]];
        [teamName setTextColor:[UIColor colorWithRed:23/255.0f green:64/255.0f blue:105/255.0f alpha:1.0]];
        [teamName setAdjustsFontSizeToFitWidth:YES];
        [teamName setMinimumScaleFactor:0.5];

        [cellViewForTeam addSubview:teamName];
        
        UIImageView *imView = [[UIImageView alloc]initWithFrame:CGRectMake(4, 13, 30, 30)];
        NSString *logName = [positionDict objectForKey:@"logoID"];
        logName = [logName stringByReplacingOccurrencesOfString:@"NULL" withString:@"default"];
        [imView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", logName]]];
        [cellViewForTeam addSubview:imView];
        
        teamName.minimumScaleFactor = 0.3;
        teamName.adjustsFontSizeToFitWidth = YES;
        
        UILabel *gamesPlayed = [[UILabel alloc]initWithFrame:CGRectMake(242-44, 12, 29, 21)];
        [gamesPlayed setText:[NSString stringWithFormat:@"%@", [positionDict objectForKey:@"total_played_amount"]]];
        [gamesPlayed setTextAlignment:NSTextAlignmentCenter];
        [cellView addSubview:gamesPlayed];
        gamesPlayed.minimumScaleFactor = 0.3;
        gamesPlayed.adjustsFontSizeToFitWidth = YES;
        
        
        UILabel *gamesWon = [[UILabel alloc]initWithFrame:CGRectMake(293-44, 12, 33, 21)];
        [gamesWon setText:[NSString stringWithFormat:@"%@", [positionDict objectForKey:@"total_win"]]];
        [gamesWon setTextAlignment:NSTextAlignmentCenter];
        [cellView addSubview:gamesWon];
        gamesWon.minimumScaleFactor = 0.3;
        gamesWon.adjustsFontSizeToFitWidth = YES;
        
        UILabel *gamesDrawn = [[UILabel alloc]initWithFrame:CGRectMake(348-44, 12, 29, 21)];
        [gamesDrawn setText:[NSString stringWithFormat:@"%@", [positionDict objectForKey:@"total_draw"]]];
        [gamesDrawn setTextAlignment:NSTextAlignmentCenter];
        [cellView addSubview:gamesDrawn];
        gamesDrawn.minimumScaleFactor = 0.3;
        gamesDrawn.adjustsFontSizeToFitWidth = YES;
        
        UILabel *gamesLost = [[UILabel alloc]initWithFrame:CGRectMake(400-44, 12, 29, 21)];
        [gamesLost setText:[NSString stringWithFormat:@"%@", [positionDict objectForKey:@"total_lose"]]];
        [gamesLost setTextAlignment:NSTextAlignmentCenter];
        [cellView addSubview:gamesLost];
        gamesLost.minimumScaleFactor = 0.3;
        gamesLost.adjustsFontSizeToFitWidth = YES;
        
        UILabel *leagueName = [[UILabel alloc]initWithFrame:CGRectMake(811-44, 12, 188, 21)];
        [leagueName setText:[NSString stringWithFormat:@"%@", [positionDict objectForKey:@"league_name"]]];
        [leagueName setTextAlignment:NSTextAlignmentLeft];
        [cellView addSubview:leagueName];
        leagueName.minimumScaleFactor = 0.3;
        leagueName.adjustsFontSizeToFitWidth = YES;
        
        
        UIButton *setAsFavouriteButton = [[UIButton alloc]initWithFrame:CGRectMake(1006-40, 11, 23, 23)];
        [setAsFavouriteButton setBackgroundColor:[UIColor clearColor]];
        [setAsFavouriteButton setBackgroundImage:[UIImage imageNamed:@"iconStarFilled.png"] forState:UIControlStateNormal];
        [setAsFavouriteButton addTarget:self action:@selector(removeFromFavourites:) forControlEvents:UIControlEventTouchUpInside];
        [setAsFavouriteButton setTag:index];
        [cellView addSubview:setAsFavouriteButton];
        
        
        //Now sort out Goals For (F) and Goals Against (A)
        //int goalsFor = [[FootballFormDB sharedInstance]amountOfGoalsFor:theTeamID];
        
        UILabel *goalsForLabel = [[UILabel alloc]initWithFrame:CGRectMake(458-44, 12, 29, 21)];
        [goalsForLabel setText:[NSString stringWithFormat:@"%@", [positionDict objectForKey:@"total_goals_for"]]];
        [goalsForLabel setTextAlignment:NSTextAlignmentLeft];
        [cellView addSubview:goalsForLabel];
        goalsForLabel.minimumScaleFactor = 0.3;
        goalsForLabel.adjustsFontSizeToFitWidth = YES;
        
        //int goalsAgainst = [[FootballFormDB sharedInstance]goalsAgainst:theTeamID];
        
        UILabel *goalsAgainstLabel = [[UILabel alloc]initWithFrame:CGRectMake(508-44, 12, 29, 21)];
        [goalsAgainstLabel setText:[NSString stringWithFormat:@"%@", [positionDict objectForKey:@"total_goals_against"]]];
        [goalsAgainstLabel setTextAlignment:NSTextAlignmentLeft];
        [cellView addSubview:goalsAgainstLabel];
        goalsAgainstLabel.minimumScaleFactor = 0.3;
        goalsAgainstLabel.adjustsFontSizeToFitWidth = YES;
        
        
        //int goalsDiff = goalsFor - goalsAgainst;
        
        UILabel *goalDiff = [[UILabel alloc]initWithFrame:CGRectMake(554-44, 12, 32, 21)];
        [goalDiff setText:[NSString stringWithFormat:@"%@", [positionDict objectForKey:@"goal_difference"]]];
        [goalDiff setTextAlignment:NSTextAlignmentLeft];
        [cellView addSubview:goalDiff];
        goalDiff.minimumScaleFactor = 0.3;
        goalDiff.adjustsFontSizeToFitWidth = YES;
        
        //int pointAmount = [[FootballFormDB sharedInstance]getPointsForTeam:theTeamID];
        
        UILabel *points = [[UILabel alloc]initWithFrame:CGRectMake(607-44, 12, 40, 21)];
        [points setText:[NSString stringWithFormat:@"%@", [positionDict objectForKey:@"total_points"]]];
        [points setTextAlignment:NSTextAlignmentLeft];
        [cellView addSubview:points];
        points.minimumScaleFactor = 0.3;
        points.adjustsFontSizeToFitWidth = YES;
        
        //Build the five boxes
        [self buildFiveBoxes:cellView teamID:[positionDict objectForKey:@"team_id"] index:index leagueID:[positionDict objectForKey:@"league_id"]];
        
        index = index +1;
        y = y +45;
    }
    
    
    UIImageView *slatOne = [[UIImageView alloc]initWithFrame:CGRectMake(189, 0, 1, 900)];
    [slatOne setBackgroundColor:[UIColor lightGrayColor]];
    [teamNameView addSubview:slatOne];
    

}


-(void)removeFromFavourites:(UIButton *)sender {

    theTeamID = [[leagueData objectAtIndex:sender.tag]objectForKey:@"team_id"];
    theLeagueID = [[leagueData objectAtIndex:sender.tag]objectForKey:@"league_id"];
    
    UIAlertView *alertV = [[UIAlertView alloc]
                           initWithTitle:@"Remove Team" message:[NSString stringWithFormat:@"Are you sure you would like to remove %@ from your favourite teams?",[[leagueData objectAtIndex:sender.tag]objectForKey:@"team_name"]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"No, Cancel", @"Yes, Remove", nil];
    [alertV setTag:101];
    [alertV show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 101) {
        
    if (buttonIndex == 1) {
        
        [_scrollView setContentOffset:CGPointMake(0, 0)];
        
        //[[FootballFormDB sharedInstance]updateFavourites:@"N" teamName:theTeamID];
        //leagueData =  [[FootballFormDB sharedInstance] getFavouritesInLeagueTable];
        
        [[FootballFormDB sharedInstance]updateFavouritesWithLeague:@"N" teamName:theTeamID lid:theLeagueID];
        
        leagueData =  [[FootballFormDB sharedInstance] getFavouritesInLeagueTable];

        
        if ([leagueData count]==0) {
            noFavourites.hidden=0;
            _titleView.hidden=1;
            _scrollView.hidden=1;
            teamNameView.hidden=1;
        } else {
            noFavourites.hidden=1;
            _titleView.hidden=0;
            _scrollView.hidden=0;
            teamNameView.hidden=0;
            [self buildTheCells];
        }
        
    }
        
}
    
}

-(void)buildFiveBoxes:(UIView *)view teamID:(NSString *)teamID index:(int)index leagueID:(NSString *)leagueID {
    
    NSMutableArray *winLooseDrawArray = [[FootballFormDB sharedInstance]getLast5GameWinsLoosesDraw:teamID leagueID:leagueID];
    
    //Lets do a check to see how many data points we have and show the correct data reliant on that
    if ([winLooseDrawArray count]==5) {
        //Button One
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(654-44, 11, 23, 23)];
        but.layer.cornerRadius = but.frame.size.width/2;
        
        
        if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but setTag:[[[winLooseDrawArray objectAtIndex:0]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but];
        
        //Button 2
        UIButton *but2 = [[UIButton alloc]initWithFrame:CGRectMake(683-44, 11, 23, 23)];
        but2.layer.cornerRadius = but2.frame.size.width/2;
        
        if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but2 addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but2 setTag:[[[winLooseDrawArray objectAtIndex:1]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but2];
        
        //Button 3
        UIButton *but3 = [[UIButton alloc]initWithFrame:CGRectMake(712-44, 11, 23, 23)];
        but3.layer.cornerRadius = but3.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:2]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but3 setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:2]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but3 setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:2]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but3 setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but3 addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but3 setTag:[[[winLooseDrawArray objectAtIndex:2]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but3];
        
        //Button 4
        UIButton *but4 = [[UIButton alloc]initWithFrame:CGRectMake(741-44, 11, 23, 23)];
        but4.layer.cornerRadius = but4.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:3]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but4 setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:3]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but4 setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:3]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but4 setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        [but4 addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but4 setTag:[[[winLooseDrawArray objectAtIndex:3]objectForKey:@"matchID"] intValue]];
        [view addSubview:but4];
        
        UIButton *but5 = [[UIButton alloc]initWithFrame:CGRectMake(770-44, 11, 23, 23)];
        but5.layer.cornerRadius = but5.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:4]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but5 setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:4]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but5 setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:4]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but5 setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        [but5 addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but5 setTag:[[[winLooseDrawArray objectAtIndex:4]objectForKey:@"matchID"] intValue]];
        [view addSubview:but5];
        
        
    } else if ([winLooseDrawArray count]==4) {
        //Button One
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(654-44, 14, 23, 23)];
        but.layer.cornerRadius = but.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"] isEqualToString:@"DRAW"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but setTag:[[[winLooseDrawArray objectAtIndex:0]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but];
        
        //Button 2
        UIButton *but2 = [[UIButton alloc]initWithFrame:CGRectMake(683-44, 14, 23, 23)];
        but2.layer.cornerRadius = but2.frame.size.width/2;
        
        if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but2 addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but2 setTag:[[[winLooseDrawArray objectAtIndex:1]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but2];
        
        //Button 3
        UIButton *but3 = [[UIButton alloc]initWithFrame:CGRectMake(712-44, 14, 23, 23)];
        but3.layer.cornerRadius = but3.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:2]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but3 setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:2]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but3 setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:2]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but3 setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but3 addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but3 setTag:[[[winLooseDrawArray objectAtIndex:2]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but3];
        
        //Button 4
        UIButton *but4 = [[UIButton alloc]initWithFrame:CGRectMake(741-44, 14, 23, 23)];
        but4.layer.cornerRadius = but4.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:3]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but4 setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:3]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but4 setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:3]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but4 setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        [but4 addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but4 setTag:[[[winLooseDrawArray objectAtIndex:3]objectForKey:@"matchID"] intValue]];
        [view addSubview:but4];
        
        
    } else if ([winLooseDrawArray count]==3) {
        //Button One
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(654-44, 14, 23, 23)];
        but.layer.cornerRadius = but.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        
        [but addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but setTag:[[[winLooseDrawArray objectAtIndex:0]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but];
        
        //Button 2
        UIButton *but2 = [[UIButton alloc]initWithFrame:CGRectMake(683-44, 14, 23, 23)];
        but2.layer.cornerRadius = but2.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but2 addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but2 setTag:[[[winLooseDrawArray objectAtIndex:1]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but2];
        
        //Button 3
        UIButton *but3 = [[UIButton alloc]initWithFrame:CGRectMake(712-44, 14, 23, 23)];
        but3.layer.cornerRadius = but3.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:2]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but3 setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:2]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but3 setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:2]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but3 setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but3 addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but3 setTag:[[[winLooseDrawArray objectAtIndex:2]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but3];
        
    } else if ([winLooseDrawArray count]==2) {
        //Button One
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(654-44, 14, 23, 23)];
        but.layer.cornerRadius = but.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but setTag:[[[winLooseDrawArray objectAtIndex:0]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but];
        
        //Button 2
        UIButton *but2 = [[UIButton alloc]initWithFrame:CGRectMake(683-44, 14, 23, 23)];
        but2.layer.cornerRadius = but2.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but2 addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but2 setTag:[[[winLooseDrawArray objectAtIndex:1]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but2];
        
    } else if ([winLooseDrawArray count]==1) {
        //Button One
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(654-44, 14, 23, 23)];
        but.layer.cornerRadius = but.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        
        [but addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but setTag:[[[winLooseDrawArray objectAtIndex:0]objectForKey:@"matchID"] intValue]];
        [view addSubview:but];
        
    } else if ([winLooseDrawArray count]==0) {
        //We have no data!
    }    
}


-(void)showGameResultsModal:(UIButton *)sender {
    
    NSMutableArray *mutArray =[[FootballFormDB sharedInstance]getFixtureDataFromFixtureID:[NSString stringWithFormat:@"%ld", (long)sender.tag]];
    
    NSString *thn = [[[mutArray objectAtIndex:0] objectForKey:@"teamHomeName"] capitalizedString];
    NSString *tan = [[[mutArray objectAtIndex:0] objectForKey:@"teamAwayName"] capitalizedString];
    
    thn = [thn stringByReplacingOccurrencesOfString:@" Fc" withString:@" FC"];
    tan = [tan stringByReplacingOccurrencesOfString:@" Fc" withString:@" FC"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ v %@",thn, tan] message:[NSString stringWithFormat:@"%@ - %@",[[mutArray objectAtIndex:0] objectForKey:@"teamHomeScore"], [[mutArray objectAtIndex:0] objectForKey:@"teamAwayScore"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
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
    
    
    [_tabBar setSelectedItem:favourites];
    
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
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoToFormPlayers"
         object:self];
        
    } else if (item.tag==5) {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoToLiveScores"
         object:self];
        
    } else if (item.tag==6) {
        /*
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoFavourites"
         object:self];
        */
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

- (IBAction)showPeek:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    [revealController showViewController:revealController.leftViewController];

    
}
@end
