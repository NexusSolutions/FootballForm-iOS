//
//  LiveScoresDetailViewController.m
//  Football Form
//
//  Created by Aaron Wilkinson on 06/05/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import "LiveScoresDetailViewController.h"
#import "API.h"
#import <iAd/iAd.h>
#import <QuartzCore/QuartzCore.h>
@interface LiveScoresDetailViewController ()

@end

@implementation LiveScoresDetailViewController

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
    
    //Listen for NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(back:)
                                                 name:@"FootballForm:PKWillRefresh"
                                               object:nil];
    
    //self.canDisplayBannerAds = YES;

    
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"FootballForm:PKWillRefresh" object:nil];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    // Then your code...
    
    [self sortOutScores];
    [self sortOutScorers];
    [self sortOutCards];
    
}


-(void)viewWillAppear:(BOOL)animated {
    
    _refreshOut.hidden=1;

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    
    [revealController setRecognizesPanningOnFrontView:NO];
    
    [_homeTeamName setText:@""];
    [_awayTeamName setText:@""];
    [_scorersView setFrame:CGRectMake(_scorersView.frame.origin.x, _scorersView.frame.origin.y, _scorersView.frame.size.width, 0)];
    [_cardsView setFrame:CGRectMake(_cardsView.frame.origin.x, _cardsView.frame.origin.y, _cardsView.frame.size.width, 0)];
    
    [self loadData];

}

-(void)loadData {
    
    [[API sharedAPI]setCurrentViewController:self];
    [API getLiveScoresData:@"GET_GAME_DATA" matchID:_matchID complete:^(NSDictionary *userData) {
        
        matchData = [[[userData objectForKey:@"data"]objectForKey:@"match_data"] objectAtIndex:0];
        
        if ([[matchData objectForKey:@"status_type"]isEqualToString:@"live"]) {
            _refreshOut.hidden=0;
        } else {
            _refreshOut.hidden=1;
        }
        
        cards = [[userData objectForKey:@"data"]objectForKey:@"cards"];
        scorers = [[userData objectForKey:@"data"]objectForKey:@"scorers"];
        scores = [[userData objectForKey:@"data"]objectForKey:@"scores"];
        
        [self sortMatchData];
        [self sortOutScores];
        [self sortOutScorers];
        [self sortOutCards];
        
        [_scrollView setContentSize:CGSizeMake(0, _cardsView.frame.size.height+_cardsView.frame.origin.y)];
        
    } failed:nil];

    
}
-(void)sortMatchData {
    
    [_homeTeamName setText:[matchData objectForKey:@"team_home_name"]];
    [_awayTeamName setText:[matchData objectForKey:@"team_away_name"]];
    
}

-(void)sortOutScores {
    
    NSString *scoreCurrent = @"0-0";
    NSString *scoreHalfTime = @"0-0";
    
    for (NSDictionary *dict in scores) {
        if ([[dict objectForKey:@"score"]isEqualToString:@"CURRENT"]) {
            scoreCurrent = [dict objectForKey:@"type"];
        }
        if ([[dict objectForKey:@"score"]isEqualToString:@"HT"]) {
            scoreHalfTime = [dict objectForKey:@"type"];
        }
    }
    
    [_score setText:scoreCurrent];
    [_htScore setText:scoreHalfTime];
    
}

-(void)sortOutScorers {
    
    for (UILabel *lab in _awayScorers.subviews) {
        if ([lab isKindOfClass:[UILabel class]]) {
            [lab removeFromSuperview];
        }
    }
    
    for (UILabel *lab in _homeScorers.subviews) {
        if ([lab isKindOfClass:[UILabel class]]) {
            [lab removeFromSuperview];
        }
    }
    
    for (UILabel *lab in _scorersView.subviews) {
        if ([lab isKindOfClass:[UILabel class]]) {
            [lab removeFromSuperview];
        }
    }
    
    for (UIImageView *imv in _scorersView.subviews) {
        if ([imv isKindOfClass:[UIImageView class]]) {
            [imv removeFromSuperview];
        }
    }
    
    for (UIImageView *imv in _awayScorers.subviews) {
        if ([imv isKindOfClass:[UIImageView class]]) {
            [imv removeFromSuperview];
        }
    }

    for (UIImageView *imv in _homeScorers.subviews) {
        if ([imv isKindOfClass:[UIImageView class]]) {
            [imv removeFromSuperview];
        }
    }

    
    if ([scorers count]==0) {
        
        [_scorersView setFrame:CGRectMake(_scorersView.frame.origin.x, _scorersView.frame.origin.y, _scorersView.frame.size.width, 0)];

        return;
    }
    
    UILabel *scorersTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, _cardsView.frame.size.width, 21)];
    [scorersTitle setTextAlignment:NSTextAlignmentCenter];
    [scorersTitle setText:@"Scorers"];
    [_scorersView addSubview:scorersTitle];
    
    int yHome = 5;
    int yAway = 5;
    
    
    if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        [_homeScorers setFrame:CGRectMake(0, _homeScorers.frame.origin.y, _homeScorers.frame.size.width, _homeScorers.frame.size.height)];
        [_awayScorers setFrame:CGRectMake(_homeScorers.frame.size.width+_homeScorers.frame.origin.x, _awayScorers.frame.origin.y, _awayScorers.frame.size.width, _awayScorers.frame.size.height)];
    } else {
        [_homeScorers setFrame:CGRectMake(35, _homeScorers.frame.origin.y, _homeScorers.frame.size.width, _homeScorers.frame.size.height)];
        [_awayScorers setFrame:CGRectMake(_homeScorers.frame.size.width+_homeScorers.frame.origin.x, _awayScorers.frame.origin.y, _awayScorers.frame.size.width, _awayScorers.frame.size.height)];

    }
    
    //[_homeScorers setFrame:CGRectMake(0, _homeScorers.frame.origin.y, _homeScorers.frame.size.width, _homeScorers.frame.size.height)];
    //[_awayScorers setFrame:CGRectMake(_homeScorers.frame.size.width+_homeScorers.frame.origin.x, _awayScorers.frame.origin.y, _awayScorers.frame.size.width, _awayScorers.frame.size.height)];
    
    for (NSDictionary *dict in scorers) {
        
        if ([[dict objectForKey:@"home_or_away"]isEqualToString:@"HOME"]) {
            
            UIImageView *goalView = [[UIImageView alloc]initWithFrame:CGRectMake(2, yHome+8, 14, 14)];
            [goalView setImage:[UIImage imageNamed:@"footballIcon.png"]];
            [_homeScorers addSubview:goalView];
            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(22, yHome, _homeScorers.frame.size.width-23, 30)];
            [lab setText:[NSString stringWithFormat:@"%@ (%@)", [dict objectForKey:@"name"], [dict objectForKey:@"time"]]];
            [lab setTextAlignment:NSTextAlignmentLeft];
            [lab setAdjustsFontSizeToFitWidth:YES];
            [lab setMinimumScaleFactor:0.5];

            [_homeScorers addSubview:lab];
            
            yHome = yHome +35;
            
        } else {
            
            UIImageView *goalView = [[UIImageView alloc]initWithFrame:CGRectMake(4, yAway+8, 14, 14)];
            [goalView setImage:[UIImage imageNamed:@"footballIcon.png"]];
            [_awayScorers addSubview:goalView];

            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(24, yAway, _awayScorers.frame.size.width-25, 30)];
            [lab setText:[NSString stringWithFormat:@"%@ (%@)", [dict objectForKey:@"name"], [dict objectForKey:@"time"]]];
            [lab setTextAlignment:NSTextAlignmentLeft];
            [lab setAdjustsFontSizeToFitWidth:YES];
            [lab setMinimumScaleFactor:0.5];

            [_awayScorers addSubview:lab];
            
            yAway = yAway +35;
        }
    }
    
    yAway = yAway+35;
    yHome = yHome+35;
    [_homeScorers setFrame:CGRectMake(_homeScorers.frame.origin.x, _homeScorers.frame.origin.y, _homeScorers.frame.size.width, yHome)];
    [_awayScorers setFrame:CGRectMake(_awayScorers.frame.origin.x, _awayScorers.frame.origin.y, _awayScorers.frame.size.width, yAway)];
    
    if (yAway>yHome) {
        [_scorersView setFrame:CGRectMake(_scorersView.frame.origin.x, _scorersView.frame.origin.y, _scorersView.frame.size.width, yAway)];
    } else {
        [_scorersView setFrame:CGRectMake(_scorersView.frame.origin.x, _scorersView.frame.origin.y, _scorersView.frame.size.width, yHome)];
    }

}

-(void)sortOutCards {
    
    for (UILabel *lab in _homeCards.subviews) {
        if ([lab isKindOfClass:[UILabel class]]) {
            [lab removeFromSuperview];
        }
    }
    
    for (UILabel *lab in _awayCards.subviews) {
        if ([lab isKindOfClass:[UILabel class]]) {
            [lab removeFromSuperview];
        }
    }
    
    for (UILabel *lab in _cardsView.subviews) {
        if ([lab isKindOfClass:[UILabel class]]) {
            [lab removeFromSuperview];
        }
    }

    if ([cards count]==0) {
        
        [_cardsView setFrame:CGRectMake(_cardsView.frame.origin.x, _cardsView.frame.origin.y, _cardsView.frame.size.width, 0)];
        
        return;
    }
    
    UILabel *scorersTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, _cardsView.frame.size.width, 21)];
    [scorersTitle setTextAlignment:NSTextAlignmentCenter];
    [scorersTitle setText:@"Cards"];
    [_cardsView addSubview:scorersTitle];
        
    [_cardsView setFrame:CGRectMake(_cardsView.frame.origin.x, _scorersView.frame.size.height+_scorersView.frame.origin.y, _cardsView.frame.size.width, _cardsView.frame.size.height)];
    
    int yHome = 5;
    int yAway = 5;
    
    
    if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        [_homeCards setFrame:CGRectMake(0, _homeCards.frame.origin.y, _homeCards.frame.size.width, _homeCards.frame.size.height)];
        [_awayCards setFrame:CGRectMake(_homeCards.frame.size.width+_homeCards.frame.origin.x, _awayCards.frame.origin.y, _awayCards.frame.size.width, _awayCards.frame.size.height)];
    } else {
        [_homeCards setFrame:CGRectMake(35, _homeCards.frame.origin.y, _homeCards.frame.size.width, _homeCards.frame.size.height)];
        [_awayCards setFrame:CGRectMake(_homeCards.frame.size.width+_homeCards.frame.origin.x, _awayCards.frame.origin.y, _awayCards.frame.size.width, _awayScorers.frame.size.height)];
        
    }
    
    
    /*
    [_homeCards setFrame:CGRectMake(0, _homeCards.frame.origin.y, _homeCards.frame.size.width, _homeCards.frame.size.height)];
    [_awayCards setFrame:CGRectMake(_homeCards.frame.size.width+_homeCards.frame.origin.x, _awayCards.frame.origin.y, _awayCards.frame.size.width, _awayCards.frame.size.height)];
    */
    
    for (NSDictionary *dict in cards) {
        
        if ([[dict objectForKey:@"home_or_away"]isEqualToString:@"HOME"]) {
            
            UIImageView *goalView = [[UIImageView alloc]initWithFrame:CGRectMake(2, yHome+8, 11, 14)];
            [goalView.layer setCornerRadius:3];

            if ([[[dict objectForKey:@"card_type"] lowercaseString]isEqualToString:@"yellow"]) {
                
                [goalView setBackgroundColor:[UIColor yellowColor]];
                
            } else {
                [goalView setBackgroundColor:[UIColor redColor]];
            }
            
            [goalView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
            [goalView.layer setBorderWidth:1.0];
            
            [_homeCards addSubview:goalView];
            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(22, yHome, _homeCards.frame.size.width-23, 30)];
            [lab setText:[NSString stringWithFormat:@"%@ (%@)", [dict objectForKey:@"player_name"], [dict objectForKey:@"time_player_got_card"]]];
            [lab setTextAlignment:NSTextAlignmentLeft];
            [lab setAdjustsFontSizeToFitWidth:YES];
            [lab setMinimumScaleFactor:0.5];
            
            [_homeCards addSubview:lab];
            
            yHome = yHome +35;
            
        } else {
            
            UIImageView *goalView = [[UIImageView alloc]initWithFrame:CGRectMake(4, yAway+8, 11, 14)];
            [goalView.layer setCornerRadius:3];
            
            if ([[[dict objectForKey:@"card_type"] lowercaseString]isEqualToString:@"yellow"]) {
                
                [goalView setBackgroundColor:[UIColor yellowColor]];
                
            } else {
                [goalView setBackgroundColor:[UIColor redColor]];
            }
            
            [goalView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
            [goalView.layer setBorderWidth:1.0];
            
            [_awayCards addSubview:goalView];
            
            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(24, yAway, _awayCards.frame.size.width-25, 30)];
            [lab setText:[NSString stringWithFormat:@"%@ (%@)", [dict objectForKey:@"player_name"], [dict objectForKey:@"time_player_got_card"]]];
            [lab setTextAlignment:NSTextAlignmentLeft];
            [lab setAdjustsFontSizeToFitWidth:YES];
            [lab setMinimumScaleFactor:0.5];

            [_awayCards addSubview:lab];
            
            yAway = yAway +35;
        }
    }
    yAway = yAway+35;
    yHome = yHome+35;
    [_homeCards setFrame:CGRectMake(_homeCards.frame.origin.x, _homeCards.frame.origin.y, _homeCards.frame.size.width, yHome)];
    [_awayCards setFrame:CGRectMake(_awayCards.frame.origin.x, _awayCards.frame.origin.y, _awayCards.frame.size.width, yAway)];
    
    if (yAway>yHome) {
        [_cardsView setFrame:CGRectMake(_cardsView.frame.origin.x, _cardsView.frame.origin.y, _cardsView.frame.size.width, yAway)];
    } else {
        [_cardsView setFrame:CGRectMake(_cardsView.frame.origin.x, _cardsView.frame.origin.y, _cardsView.frame.size.width, yHome)];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)refresh:(id)sender {
    [self loadData];
}
@end
