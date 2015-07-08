//
//  GameDetailsViewController.m
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import "GameDetailsViewController.h"
#import "FootballFormDB.h"
@interface GameDetailsViewController ()

@end

@implementation GameDetailsViewController

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
    
    /*
    if (!IS_IPHONE5) {
        
        [homeTeamName setFrame:CGRectMake(5, homeTeamName.frame.origin.y, homeTeamName.frame.size.width, homeTeamName.frame.size.height)];
        [currentPositionHomeTeam setFrame:CGRectMake(9, currentPositionHomeTeam.frame.origin.y, currentPositionHomeTeam.frame.size.width, currentPositionHomeTeam.frame.size.height)];
        [homeTeamColourBlock setFrame:CGRectMake(85, homeTeamColourBlock.frame.origin.y, homeTeamColourBlock.frame.size.width, homeTeamColourBlock.frame.size.height)];
        [score setFrame:CGRectMake(200, score.frame.origin.y, score.frame.size.width, score.frame.size.height)];
        [scoreBg setFrame:CGRectMake(201, scoreBg.frame.origin.y, scoreBg.frame.size.width, scoreBg.frame.size.height)];
        [currentLeague setFrame:CGRectMake(145, currentLeague.frame.origin.y, currentLeague.frame.size.width, currentLeague.frame.size.height)];
        
        
        [awayTeamName setFrame:CGRectMake(300, awayTeamName.frame.origin.y, awayTeamName.frame.size.width, awayTeamName.frame.size.height)];
        [currentPositionAwayTeam setFrame:CGRectMake(306, currentPositionAwayTeam.frame.origin.y, currentPositionAwayTeam.frame.size.width, currentPositionAwayTeam.frame.size.height)];
        [awayTeamColourBlock setFrame:CGRectMake(385, awayTeamColourBlock.frame.origin.y, awayTeamColourBlock.frame.size.width, awayTeamColourBlock.frame.size.height)];


        [goalsView setFrame:CGRectMake(-10, goalsView.frame.origin.y, goalsView.frame.size.width, goalsView.frame.size.height)];
        [matchNotes setFrame:CGRectMake(10, matchNotes.frame.origin.y, matchNotes.frame.size.width, matchNotes.frame.size.height)];
        
        
        [goalsTitle setFrame:CGRectMake(200,goalsTitle.frame.origin.y, goalsTitle.frame.size.width, goalsTitle.frame.size.height)];
        [yellowCardsView setFrame:CGRectMake(-40, yellowCardsView.frame.origin.y, yellowCardsView.frame.size.width, yellowCardsView.frame.size.height)];
        [lineUpsView setFrame:CGRectMake(-40, lineUpsView.frame.origin.y, lineUpsView.frame.size.width, lineUpsView.frame.size.height)];

    }
     */
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}


-(void)viewWillAppear:(BOOL)animated {
    
    [self setUpTabBar];
    
    gameData = [[FootballFormDB sharedInstance]getFixtureDataFromFixtureID:[[NSUserDefaults standardUserDefaults]objectForKey:@"fixtureIDCarried"]];
    
    if (gameData.count==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Data" message:@"Sorry, there is no game data available for this match." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert setTag:1902];
        [alert show];
        return;
    }
    homeTeamData = [[FootballFormDB sharedInstance]getTeamDataFromID:[[gameData objectAtIndex:0] objectForKey:@"teamHomeID"]];
    awayTeamData = [[FootballFormDB sharedInstance]getTeamDataFromID:[[gameData objectAtIndex:0] objectForKey:@"teamAwayID"]];
    
    homeTeamName.text = [[homeTeamData objectAtIndex:0]objectForKey:@"teamName"];
    awayTeamName.text = [[awayTeamData objectAtIndex:0]objectForKey:@"teamName"];
    score.text = [NSString stringWithFormat:@"%@-%@", [[gameData objectAtIndex:0]objectForKey:@"teamHomeScore"], [[gameData objectAtIndex:0]objectForKey:@"teamAwayScore"]];
    
    currentLeague.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"leagueName"];
    goalScorers = [[FootballFormDB sharedInstance]getGoalScorersPerMatchID:[[gameData objectAtIndex:0] objectForKey:@"fixtureID"]];
    
    NSMutableArray *homeTeamScorers = [NSMutableArray new];
    NSMutableArray *awayTeamScorers = [NSMutableArray new];
    
    for (NSDictionary *goalScorersDict in goalScorers) {
        if ([[goalScorersDict objectForKey:@"teamSide"]isEqualToString:@"Away"]) {
            [awayTeamScorers addObject:goalScorersDict];
        } else {
            [homeTeamScorers addObject:goalScorersDict];
        }
    }
    
    [matchNotes setText:[[gameData objectAtIndex:0] objectForKey:@"matchNotes"]];
    if (matchNotes.text.length==0) {
        matchNotesView.hidden=1;
        [goalsView setFrame:CGRectMake(goalsView.frame.origin.x, 0, goalsView.frame.size.width, goalsView.frame.size.height)];
    }
    
    [currentPositionHomeTeam setText:[NSString stringWithFormat:@"Current Position: %@",[[FootballFormDB sharedInstance]getTeamPositionInLeagueTable:[[gameData objectAtIndex:0] objectForKey:@"teamHomeID"]]]];
    [currentPositionAwayTeam setText:[NSString stringWithFormat:@"Current Position: %@", [[FootballFormDB sharedInstance]getTeamPositionInLeagueTable:[[gameData objectAtIndex:0] objectForKey:@"teamAwayID"]]]];

    [self buildGoals:homeTeamScorers awayScorersArray:awayTeamScorers];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag ==1902) {
        
        [self back:nil];
        
    }
    
}

-(void)buildGoals:(NSMutableArray *)homeScorersArray awayScorersArray:(NSMutableArray *)awayScorersArray {
    
    for (UIView *lab in lineUpsView.subviews) {
        if (lab.tag!=1) {
            [lab removeFromSuperview];
        }
    }

    
    NSString *largeSize;
    
    if ([homeScorersArray count]<[awayScorersArray count]) {
        
       largeSize = [NSString stringWithFormat:@"%lu",(unsigned long)[awayScorersArray count]];
        
    } else {
        
        largeSize = [NSString stringWithFormat:@"%lu",(unsigned long)[homeScorersArray count]];
        
    }
    
    if (![largeSize isEqualToString:@"0"]) {
        
        int ye = 40;
        
        UILabel *homeTeamLab = [[UILabel alloc]initWithFrame:CGRectMake(0, ye, 40, 25)];
        UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake((homeTeamLab.frame.size.width+homeTeamLab.frame.origin.x)+3, ye, self.view.frame.size.width-(homeTeamLab.frame.size.width+homeTeamLab.frame.origin.x)*2, 25)];
        UILabel *awayTeamLab = [[UILabel alloc]initWithFrame:CGRectMake((background.frame.size.width+background.frame.origin.x), ye, 40, 25)];
        
        [background setBackgroundColor:[UIColor colorWithRed:0.160784 green:0.615686 blue:0.839216 alpha:1]];
        [awayTeamColourBlock setBackgroundColor:background.backgroundColor];
        [awayTeamColourBlock.layer setCornerRadius:awayTeamColourBlock.frame.size.width/2];
        [goalsView addSubview:background];
        
        NSString *homeScore = [[gameData objectAtIndex:0]objectForKey:@"teamHomeScore"];
        NSString *awayScore = [[gameData objectAtIndex:0]objectForKey:@"teamAwayScore"];
        
        float total = [homeScore intValue]+[awayScore intValue];
        float totalPerSlot = background.frame.size.width / total;
        
        UIImageView *overlay = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,0,0)];
        overlay.frame = CGRectMake(background.frame.origin.x, background.frame.origin.y, totalPerSlot*[homeScore intValue], background.frame.size.height);
        
        [overlay setBackgroundColor:[UIColor blueColor]];
        [homeTeamColourBlock setBackgroundColor:overlay.backgroundColor];
        [homeTeamColourBlock.layer setCornerRadius:homeTeamColourBlock.frame.size.width/2];
        [goalsView addSubview:overlay];
        
        
        [homeTeamLab setText:homeScore];
        [homeTeamLab setTextAlignment:NSTextAlignmentCenter];
        [goalsView addSubview:homeTeamLab];
        
        
        [awayTeamLab setText:awayScore];
        [awayTeamLab setTextAlignment:NSTextAlignmentCenter];
        [goalsView addSubview:awayTeamLab];
        
    }
    
    int x = 0;
    int y = 75;
    int w = (self.view.frame.size.width/2)-1;
    int h = 21;
    
    for (NSDictionary *home in homeScorersArray) {
        
        UILabel *homeGoalLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
        if (![[home objectForKey:@"playerID"]isEqualToString:@"0"]) {
            
            //[homeGoalLabel setText:[NSString stringWithFormat:@"%@(%@)",[[FootballFormDB sharedInstance] getPlayerNameFromID:[home objectForKey:@"playerID"]], [home objectForKey:@"timeScoredIn"]]];
            
            NSString *na = [home objectForKey:@"playerName"];
            na = [na stringByReplacingOccurrencesOfString:@"." withString:@" "];
            
            [homeGoalLabel setText:[NSString stringWithFormat:@"%@(%@)",na, [home objectForKey:@"timeScoredIn"]]];

        } else {
            
            NSString *ts = [[home objectForKey:@"playerName"] substringFromIndex:[[home objectForKey:@"playerName"] length]-1];
            NSString *name;
            
            if ([ts isEqualToString:@"."]) {
                name = [[home objectForKey:@"playerName"] substringToIndex:[[home objectForKey:@"playerName"] length]-1];
            } else {
                name = [home objectForKey:@"playerName"];
            }
            
            [homeGoalLabel setText:[NSString stringWithFormat:@"%@ (%@)",[name capitalizedString],[home objectForKey:@"timeScoredIn"]]];
        }
        
        [homeGoalLabel setTextAlignment:NSTextAlignmentCenter];
        [homeGoalLabel setTextColor:[UIColor colorWithRed:33/255.0f green:106/255.0f blue:196/255.0f alpha:1]];
        [homeGoalLabel setFont:[UIFont systemFontOfSize:15]];
        [homeGoalLabel setMinimumScaleFactor:0.5];
        [homeGoalLabel setAdjustsFontSizeToFitWidth:YES];
        
        [goalsView addSubview:homeGoalLabel];
        
        y = y +h+5;
        
    }
    
    x = (self.view.frame.size.width/2)+1;
    
    y=75;
    
    for (NSDictionary *away in awayScorersArray) {
        
        UILabel *awayGoalLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
                
        if (![[away objectForKey:@"playerID"]isEqualToString:@"0"]) {
            
            NSString *na = [away objectForKey:@"playerName"];
            na = [na stringByReplacingOccurrencesOfString:@"." withString:@" "];
            
            [awayGoalLabel setText:[NSString stringWithFormat:@"%@(%@)",na, [away objectForKey:@"timeScoredIn"]]];
            
        } else {
            
            NSString *ts = [[away objectForKey:@"playerName"] substringFromIndex:[[away objectForKey:@"playerName"] length]-1];
            NSString *name;
            
            if ([ts isEqualToString:@"."]) {
                name = [[away objectForKey:@"playerName"] substringToIndex:[[away objectForKey:@"playerName"] length]-1];
            } else {
                name = [away objectForKey:@"playerName"];
            }

            
            [awayGoalLabel setText:[NSString stringWithFormat:@"%@ (%@)",[name capitalizedString], [away objectForKey:@"timeScoredIn"]]];
        }
        
        [awayGoalLabel setTextAlignment:NSTextAlignmentCenter];
        [awayGoalLabel setTextColor:[UIColor colorWithRed:33/255.0f green:106/255.0f blue:196/255.0f alpha:1]];
        [awayGoalLabel setFont:[UIFont systemFontOfSize:15]];
        [goalsView addSubview:awayGoalLabel];        
        
        y = y +h+5;

    }
    
    if ([largeSize isEqualToString:@"0"]) {
        
        [goalsView setFrame:CGRectMake(goalsView.frame.origin.x, goalsView.frame.origin.y, goalsView.frame.size.width, 0)];

    } else {
        
        [goalsView setFrame:CGRectMake(goalsView.frame.origin.x, goalsView.frame.origin.y, goalsView.frame.size.width, [largeSize intValue]*(21+5)+78)];
        
    }
    
    [goalsView setBackgroundColor:[UIColor whiteColor]];
    [self buildYellowCardsView];

}

-(void)buildYellowCardsView {
    
    for (UIView *lab in lineUpsView.subviews) {
        if (lab.tag!=1) {
            [lab removeFromSuperview];
        }
    }

    
    [yellowCardsView setFrame:CGRectMake(yellowCardsView.frame.origin.x, goalsView.frame.origin.y+goalsView.frame.size.height, goalsView.frame.size.width, 200)];
    
    NSMutableArray *yellCardsArray=[NSMutableArray new];
    NSMutableArray *homeYellowCards = [NSMutableArray new];
    NSMutableArray *awayYellowCards = [NSMutableArray new];
    
    yellCardsArray =[[FootballFormDB sharedInstance]getYellowCardsFromMatchID:[[gameData objectAtIndex:0] objectForKey:@"fixtureID"]];
    
    for (NSDictionary *yelCards in yellCardsArray) {
        if ([[yelCards objectForKey:@"recieved_at"]isEqualToString:@"Away"]) {
            [awayYellowCards addObject:yelCards];
        } else {
            [homeYellowCards addObject:yelCards];
        }
    }
    
    NSString *largeSize;
    
    
    if ([homeYellowCards count]<[awayYellowCards count]) {
        
        largeSize = [NSString stringWithFormat:@"%lu",(unsigned long)[awayYellowCards count]];
        
    } else {
        
        largeSize = [NSString stringWithFormat:@"%lu",(unsigned long)[homeYellowCards count]];
        
    }
    
    
    int x = 0;
    int y =30;
    int w = (self.view.frame.size.width/2)-1;
    int h = 21;

    
    for (NSDictionary *dict in homeYellowCards) {
        
        UILabel *awayGoalLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
        if (![[dict objectForKey:@"playerID"]isEqualToString:@"0"]) {
            
            NSString *na = [dict objectForKey:@"playerName"];
            na = [na stringByReplacingOccurrencesOfString:@"." withString:@" "];
            
            [awayGoalLabel setText:[NSString stringWithFormat:@"%@(%@)",na, [dict objectForKey:@"timePlayerGotCard"]]];
            
            
        } else {
            
            NSString *ts = [[dict objectForKey:@"playerName"] substringFromIndex:[[dict objectForKey:@"playerName"] length]-1];
            NSString *name;
            
            if ([ts isEqualToString:@"."]) {
                name = [[dict objectForKey:@"playerName"] substringToIndex:[[dict objectForKey:@"playerName"] length]-1];
            } else {
                name = [dict objectForKey:@"playerName"];
            }
            
            [awayGoalLabel setText:[NSString stringWithFormat:@"%@ (%@)",[name capitalizedString], [dict objectForKey:@"timePlayerGotCard"]]];
            
        }
        
        [awayGoalLabel setTextAlignment:NSTextAlignmentCenter];
        [awayGoalLabel setTextColor:[UIColor colorWithRed:33/255.0f green:106/255.0f blue:196/255.0f alpha:1]];
        [awayGoalLabel setFont:[UIFont systemFontOfSize:15]];
        [yellowCardsView addSubview:awayGoalLabel];

         y = y +h+5;
    }
    
    x = (self.view.frame.size.width/2)+1;
    y =30;
    
    for (NSDictionary *dict in awayYellowCards) {
        
        UILabel *awayGoalLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
        if (![[dict objectForKey:@"playerID"]isEqualToString:@"0"]) {
            
            NSString *na = [dict objectForKey:@"playerName"];
            na = [na stringByReplacingOccurrencesOfString:@"." withString:@" "];
            
            [awayGoalLabel setText:[NSString stringWithFormat:@"%@(%@)",na, [dict objectForKey:@"timePlayerGotCard"]]];
            
        } else {
            
            NSString *ts = [[dict objectForKey:@"playerName"] substringFromIndex:[[dict objectForKey:@"playerName"] length]-1];
            NSString *name;
            
            if ([ts isEqualToString:@"."]) {
                name = [[dict objectForKey:@"playerName"] substringToIndex:[[dict objectForKey:@"playerName"] length]-1];
            } else {
                name = [dict objectForKey:@"playerName"];
            }
            
            [awayGoalLabel setText:[NSString stringWithFormat:@"%@ (%@)",[name capitalizedString], [dict objectForKey:@"timePlayerGotCard"]]];
            
        }
        
        [awayGoalLabel setTextAlignment:NSTextAlignmentCenter];
        [awayGoalLabel setTextColor:[UIColor colorWithRed:33/255.0f green:106/255.0f blue:196/255.0f alpha:1]];
        [awayGoalLabel setFont:[UIFont systemFontOfSize:15]];
        [yellowCardsView addSubview:awayGoalLabel];
        
        y = y +h+5;
    }
    
    if ([largeSize isEqualToString:@"0"]) {
        
        [yellowCardsView setFrame:CGRectMake(yellowCardsView.frame.origin.x, yellowCardsView.frame.origin.y, yellowCardsView.frame.size.width, 0)];
        
    } else {
        
        [yellowCardsView setFrame:CGRectMake(yellowCardsView.frame.origin.x, yellowCardsView.frame.origin.y, yellowCardsView.frame.size.width, [largeSize intValue]*(21+5)+32)];
        
    }
    
    [self redCardView];
}


-(void)redCardView {
    
    for (UIView *lab in lineUpsView.subviews) {
        if (lab.tag!=1) {
            [lab removeFromSuperview];
        }
    }
    
    [redCardsView setFrame:CGRectMake(redCardsView.frame.origin.x, yellowCardsView.frame.origin.y+yellowCardsView.frame.size.height, redCardsView.frame.size.width, 200)];

    NSMutableArray *redCardsArray=[NSMutableArray new];
    NSMutableArray *homeRedCards = [NSMutableArray new];
    NSMutableArray *awayRedCards = [NSMutableArray new];
    
    redCardsArray =[[FootballFormDB sharedInstance]getRedCardsFromMatchID:[[gameData objectAtIndex:0] objectForKey:@"fixtureID"]];
    
    
    for (NSDictionary *yelCards in redCardsArray) {
        
        if ([[yelCards objectForKey:@"recieved_at"]isEqualToString:@"Away"]) {
            
            [awayRedCards addObject:yelCards];
            
        } else {
            
            [homeRedCards addObject:yelCards];
            
        }
    }
    
    NSString *largeSize;
    
    if ([homeRedCards count]<[awayRedCards count]) {
        
        largeSize = [NSString stringWithFormat:@"%lu",(unsigned long)[awayRedCards count]];
        
    } else {
        
        largeSize = [NSString stringWithFormat:@"%lu",(unsigned long)[homeRedCards count]];
        
    }
    
    int x = 0;
    int y =30;
    int w = (self.view.frame.size.width/2)-1;
    int h = 21;
    
    for (NSDictionary *dict in homeRedCards) {
        
        UILabel *awayGoalLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
        if (![[dict objectForKey:@"playerID"]isEqualToString:@"0"]) {
            
            NSString *na = [dict objectForKey:@"playerName"];
            na = [na stringByReplacingOccurrencesOfString:@"." withString:@" "];
            
            [awayGoalLabel setText:[NSString stringWithFormat:@"%@(%@)",na, [dict objectForKey:@"timePlayerGotCard"]]];

            
        } else {
            
            NSString *ts = [[dict objectForKey:@"playerName"] substringFromIndex:[[dict objectForKey:@"playerName"] length]-1];
            NSString *name;
            
            if ([ts isEqualToString:@"."]) {
                name = [[dict objectForKey:@"playerName"] substringToIndex:[[dict objectForKey:@"playerName"] length]-1];
            } else {
                name = [dict objectForKey:@"playerName"];
            }
            
            
            [awayGoalLabel setText:[NSString stringWithFormat:@"%@ (%@)",[name capitalizedString], [dict objectForKey:@"timePlayerGotCard"]]];
            
        }
        
        [awayGoalLabel setTextAlignment:NSTextAlignmentCenter];
        [awayGoalLabel setTextColor:[UIColor colorWithRed:33/255.0f green:106/255.0f blue:196/255.0f alpha:1]];
        [awayGoalLabel setFont:[UIFont systemFontOfSize:15]];
        [redCardsView addSubview:awayGoalLabel];
        
        y = y +h+5;
    }
    
    x = (self.view.frame.size.width/2)+1;
    y =30;
    
    for (NSDictionary *dict in awayRedCards) {
        
        UILabel *awayGoalLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
        if (![[dict objectForKey:@"playerID"]isEqualToString:@"0"]) {
            
            NSString *na = [dict objectForKey:@"playerName"];
            na = [na stringByReplacingOccurrencesOfString:@"." withString:@" "];
            
            [awayGoalLabel setText:[NSString stringWithFormat:@"%@(%@)",na, [dict objectForKey:@"timePlayerGotCard"]]];
            
        } else {
            
            NSString *ts = [[dict objectForKey:@"playerName"] substringFromIndex:[[dict objectForKey:@"playerName"] length]-1];
            NSString *name;
            
            if ([ts isEqualToString:@"."]) {
                name = [[dict objectForKey:@"playerName"] substringToIndex:[[dict objectForKey:@"playerName"] length]-1];
            } else {
                name = [dict objectForKey:@"playerName"];
            }
            
            
            [awayGoalLabel setText:[NSString stringWithFormat:@"%@ (%@)",[name capitalizedString], [dict objectForKey:@"timePlayerGotCard"]]];
            
        }
        
        [awayGoalLabel setTextAlignment:NSTextAlignmentCenter];
        [awayGoalLabel setTextColor:[UIColor colorWithRed:33/255.0f green:106/255.0f blue:196/255.0f alpha:1]];
        [awayGoalLabel setFont:[UIFont systemFontOfSize:15]];
        [redCardsView addSubview:awayGoalLabel];
        
        y = y +h+5;
    }
    
    if ([largeSize isEqualToString:@"0"]) {
        
        [redCardsView setFrame:CGRectMake(redCardsView.frame.origin.x, redCardsView.frame.origin.y, redCardsView.frame.size.width, 0)];
        
    } else {
        
        [redCardsView setFrame:CGRectMake(redCardsView.frame.origin.x, redCardsView.frame.origin.y, redCardsView.frame.size.width, [largeSize intValue]*(21+5)+32)];
        
    }
    
    [self buildLineUps];

}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    // Then your code...
    
    [self viewWillAppear:YES];
    
}

-(void)buildLineUps {
    
    for (UIView *lab in lineUpsView.subviews) {
        if (lab.tag!=1) {
            [lab removeFromSuperview];
        }
    }
    
    [lineUpsView setFrame:CGRectMake(lineUpsView.frame.origin.x, redCardsView.frame.origin.y+redCardsView.frame.size.height, redCardsView.frame.size.width, 200)];

    lineups = [[FootballFormDB sharedInstance]getLineUpsPerMatchID:[[gameData objectAtIndex:0] objectForKey:@"fixtureID"]];
    
    NSMutableArray *home = [NSMutableArray new];
    NSMutableArray *away = [NSMutableArray new];

    for (NSDictionary *dict in lineups) {
        
        if ([[dict objectForKey:@"teamID"]isEqualToString:[[homeTeamData objectAtIndex:0] objectForKey:@"id"]]) {
            //they are at home
            [home addObject:dict];
        } else {
            [away addObject:dict];
        }
    }
    
    int y =32;
    
    for (NSDictionary *homeDict in home) {
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, y, (self.view.frame.size.width/2)-1, 25)];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setTextAlignment:NSTextAlignmentCenter];
        [lab setMinimumScaleFactor:0.5];
        [lab setAdjustsFontSizeToFitWidth:YES];
        [lab setText:[homeDict objectForKey:@"playerName"]];
        [lineUpsView addSubview:lab];
        y=y+29;
        
    }
    
    y =32;
    
    for (NSDictionary *awayDict in away) {
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)+1, y, (self.view.frame.size.width/2)-1, 25)];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setTextAlignment:NSTextAlignmentCenter];
        [lab setMinimumScaleFactor:0.5];
        [lab setAdjustsFontSizeToFitWidth:YES];
        [lab setText:[awayDict objectForKey:@"playerName"]];
        [lineUpsView addSubview:lab];
        y=y+29;
        
    }

    
    if ([home count]==0) {
        
        [lineUpsView setFrame:CGRectMake(lineUpsView.frame.origin.x, lineUpsView.frame.origin.y, lineUpsView.frame.size.width, 0)];
        
    } else if ([away count]==0) {
        
        [lineUpsView setFrame:CGRectMake(lineUpsView.frame.origin.x, lineUpsView.frame.origin.y, lineUpsView.frame.size.width, 0)];
        
    } else {
        
        [lineUpsView setFrame:CGRectMake(lineUpsView.frame.origin.x, lineUpsView.frame.origin.y, lineUpsView.frame.size.width, y+27)];
        
    }
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, lineUpsView.frame.origin.y+lineUpsView.frame.size.height)];

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

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    //[self performSegueWithIdentifier:@"backToFixtures" sender:self];
    
}
@end
