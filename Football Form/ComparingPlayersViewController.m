//
//  ComparingPlayersViewController.m
//  Football Form
//
//  Created by Aaron Wilkinson on 05/12/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import "ComparingPlayersViewController.h"
#import "FootballFormDB.h"
#import <iAd/iAd.h>

//getplayerdetails
@interface ComparingPlayersViewController ()

@end

@implementation ComparingPlayersViewController

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
    
    self.canDisplayBannerAds = NO;

    [self viewWillAppear:YES];
    [self viewDidAppear:YES];
    
    self.canDisplayBannerAds = YES;
    
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {
    
    teamOneLeagueID = [[NSUserDefaults standardUserDefaults]objectForKey:@"FootballForm:PlayerVsLeagueIDT1"];
    teamTwoLeagueID = [[NSUserDefaults standardUserDefaults]objectForKey:@"FootballForm:PlayerVsLeagueIDT2"];

    
    playerOneData = [[NSUserDefaults standardUserDefaults]mutableArrayValueForKey:@"playerOneDataCarry"];
    
    NSString *theID = [playerOneData objectAtIndex:0];
    
    playerOneData = [[FootballFormDB sharedInstance]getPlayerDetails:theID];
    
    playerTwoData = [[NSUserDefaults standardUserDefaults]mutableArrayValueForKey:@"playerTwoDataCarry"];
    
    NSString *theID2 = [playerTwoData objectAtIndex:0];
    
    playerTwoData = [[FootballFormDB sharedInstance]getPlayerDetails:theID2];
    
    [_playerOne setText:[NSString stringWithFormat:@"%@ (%@)",[[[playerOneData objectAtIndex:0]objectForKey:@"name"] capitalizedString],[[[playerOneData objectAtIndex:0]objectForKey:@"team_name"] capitalizedString]]];
    [_playerTwo setText:[NSString stringWithFormat:@"%@ (%@)",[[[playerTwoData objectAtIndex:0]objectForKey:@"name"] capitalizedString],[[[playerTwoData objectAtIndex:0]objectForKey:@"team_name"] capitalizedString]]];
    
    _playerOne.text = [_playerOne.text stringByReplacingOccurrencesOfString:@" Fc" withString:@" FC"];
    _playerTwo.text = [_playerTwo.text stringByReplacingOccurrencesOfString:@" Fc" withString:@" FC"];

    amountOfGames = @"3";
    
    gamesArray = @[@"3 Games", @"5 Games", @"10 Games"];
    
    [_entirePickerView setAlpha:0.0];
    
    _playerOne.minimumScaleFactor = 0.3;
    _playerOne.adjustsFontSizeToFitWidth = YES;
    _playerTwo.minimumScaleFactor = 0.3;
    _playerTwo.adjustsFontSizeToFitWidth = YES;
    
    [averageScoreTimePlayerOne setText:[NSString stringWithFormat:@"%@ mins",[[FootballFormDB sharedInstance]getAverageScoreTimeWithPlayerID:[[playerOneData objectAtIndex:0] objectForKey:@"player_id"]]]];
    [averageScoreTimePlayerTwo setText:[NSString stringWithFormat:@"%@ mins",[[FootballFormDB sharedInstance]getAverageScoreTimeWithPlayerID:[[playerTwoData objectAtIndex:0] objectForKey:@"player_id"]]]];

    averageScoreTimePlayerOne.text = [averageScoreTimePlayerOne.text stringByReplacingOccurrencesOfString:@"N/A mins" withString:@"N/A"];
    averageScoreTimePlayerTwo.text = [averageScoreTimePlayerTwo.text stringByReplacingOccurrencesOfString:@"N/A mins" withString:@"N/A"];
    //getPlayersTotalCards
    
    NSString *yellCardsOne = [[FootballFormDB sharedInstance]getPlayersTotalCards:[[playerOneData objectAtIndex:0] objectForKey:@"player_id"] colour:@"Yellow" leagueID:teamOneLeagueID];
    NSString *yellCardsTwo = [[FootballFormDB sharedInstance]getPlayersTotalCards:[[playerTwoData objectAtIndex:0] objectForKey:@"player_id"] colour:@"Yellow" leagueID:teamTwoLeagueID];
    
    
    [self buildYellowCardSliderEntireSeason:yellCardsOne two:yellCardsTwo];
    
    NSString *redCardsOne = [[FootballFormDB sharedInstance]getPlayersTotalCards:[[playerOneData objectAtIndex:0] objectForKey:@"player_id"] colour:@"Red" leagueID:teamOneLeagueID];
    NSString *redCardsTwo = [[FootballFormDB sharedInstance]getPlayersTotalCards:[[playerTwoData objectAtIndex:0] objectForKey:@"player_id"] colour:@"Red" leagueID:teamTwoLeagueID];
    
    [self buildRedCardSliderEntireSeason:redCardsOne two:redCardsTwo];
    
    [averageCardTimePlayerOne setText:[NSString stringWithFormat:@"%@ mins",[[FootballFormDB sharedInstance]getAverageCardTimeWithPlayerID:[[playerOneData objectAtIndex:0] objectForKey:@"player_id"]]]];
    [averageCardTimePlayerTwo setText:[NSString stringWithFormat:@"%@ mins",[[FootballFormDB sharedInstance]getAverageCardTimeWithPlayerID:[[playerTwoData objectAtIndex:0] objectForKey:@"player_id"]]]];
    
    if ([averageCardTimePlayerOne.text isEqualToString:@"0 mins"]) {
        averageCardTimePlayerOne.text = @"N/A";
    }
    
    if ([averageCardTimePlayerTwo.text isEqualToString:@"0 mins"]) {
        averageCardTimePlayerTwo.text = @"N/A";
    }

    //getAverageCardTimeWithPlayerID
    [self setUpTabBar];
    
    [scrollView setContentSize:CGSizeMake(320, 650+153)];
    [_picker setFrame:CGRectMake(_picker.frame.origin.x, _picker.frame.origin.y, [[UIScreen mainScreen] bounds].size.height, _picker.frame.size.height)];
    
    /*
    if (!IS_IPHONE5) {
        
        [_playerOne setFrame:CGRectMake(2, 8, 227, 26)];
        [vsIcon setFrame:CGRectMake(227, 8, 25, 25)];
        [_playerTwo setFrame:CGRectMake(251, 8, 227, 26)];
        [lastXGamesView setFrame:CGRectMake(-37, lastXGamesView.frame.origin.y, lastXGamesView.frame.size.width, lastXGamesView.frame.size.height)];
        
        [cardsView setFrame:CGRectMake(-37, cardsView.frame.origin.y, cardsView.frame.size.width, cardsView.frame.size.height)];
        [entireSeasonScoreView setFrame:CGRectMake(-37, entireSeasonScoreView.frame.origin.y, entireSeasonScoreView.frame.size.width, entireSeasonScoreView.frame.size.height)];
        [entireSeasonCards setFrame:CGRectMake(-37, entireSeasonCards.frame.origin.y, entireSeasonCards.frame.size.width, entireSeasonCards.frame.size.height)];
        
        [noGamesView setFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.height-noGamesView.frame.size.width)-15, noGamesView.frame.origin.y, noGamesView.frame.size.width, noGamesView.frame.size.height)];
        [closebutty setFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.height-closebutty.frame.size.width)-15, closebutty.frame.origin.y, closebutty.frame.size.width, closebutty.frame.size.height)];
        
    }
     */
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"FootballForm:PKWillRefresh" object:nil];
    
    //Listen for NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backRoot)
                                                 name:@"FootballForm:PKWillRefresh"
                                               object:nil];
    
}

-(void)backRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"FootballForm:PKWillRefresh" object:nil];
    
}





-(void)buildTotalScoreSlider:(NSString *)one two:(NSString *)two {
    
    for (UIView *imView in entireSeasonScoreView.subviews) {
        
        if (imView.tag == 101 || imView.tag == 102 || imView.tag == 103 || imView.tag == 104) {
            [imView removeFromSuperview];
        }
    }
    
    /*
    if (!IS_IPHONE5) {
        background = [[UIImageView alloc]initWithFrame:CGRectMake(64, 47, 425, 25)];
    } else {
        background = [[UIImageView alloc]initWithFrame:CGRectMake(40, 47, 488, 25)];
    }
    */
    
    int y = 47;
    
    UILabel *homeTeamLab = [[UILabel alloc]initWithFrame:CGRectMake(0, y, 40, 25)];
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake((homeTeamLab.frame.size.width+homeTeamLab.frame.origin.x)+3, y, self.view.frame.size.width-(homeTeamLab.frame.size.width+homeTeamLab.frame.origin.x)*2, 25)];
    UILabel *awayTeamLab = [[UILabel alloc]initWithFrame:CGRectMake((background.frame.size.width+background.frame.origin.x), y, 40, 25)];
    
    [background setBackgroundColor:[UIColor colorWithRed:0.160784 green:0.615686 blue:0.839216 alpha:1]];
    [background setTag:101];
    [entireSeasonScoreView addSubview:background];
    
    NSString *homeScore = [NSString stringWithFormat:@"%d", [one intValue]];
    NSString *awayScore = [NSString stringWithFormat:@"%d", [two intValue]];
    
    float total = [homeScore intValue]+[awayScore intValue];
    
    if (total ==0) {
        total = 1;
    }
    
    float totalPerSlot = background.frame.size.width / total;
    
    UIImageView *overlay = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,0,0)];
    overlay.frame = CGRectMake(background.frame.origin.x, background.frame.origin.y, totalPerSlot*[homeScore intValue], background.frame.size.height);
    [overlay setTag:102];
    [overlay setBackgroundColor:[UIColor blueColor]];
    
    [entireSeasonScoreView addSubview:overlay];
    
    [homeTeamLab setText:homeScore];
    [homeTeamLab setTag:103];
    [homeTeamLab setTextAlignment:NSTextAlignmentCenter];
    [entireSeasonScoreView addSubview:homeTeamLab];
    
    [awayTeamLab setText:awayScore];
    [awayTeamLab setTag:104];
    [awayTeamLab setTextAlignment:NSTextAlignmentCenter];
    [entireSeasonScoreView addSubview:awayTeamLab];
    
}


-(void)buildHomeScoreSlider:(NSString *)one two:(NSString *)two {
    
    for (UIView *imView in homeAwayGoals.subviews) {
        
        if (imView.tag == 101 || imView.tag == 102 || imView.tag == 103 || imView.tag == 104) {
            [imView removeFromSuperview];
        }
    }
    
    int y = 47;
    
    UILabel *homeTeamLab = [[UILabel alloc]initWithFrame:CGRectMake(0, y, 40, 25)];
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake((homeTeamLab.frame.size.width+homeTeamLab.frame.origin.x)+3, y, self.view.frame.size.width-(homeTeamLab.frame.size.width+homeTeamLab.frame.origin.x)*2, 25)];
    UILabel *awayTeamLab = [[UILabel alloc]initWithFrame:CGRectMake((background.frame.size.width+background.frame.origin.x), y, 40, 25)];
    
    [background setBackgroundColor:[UIColor colorWithRed:0.160784 green:0.615686 blue:0.839216 alpha:1]];
    [background setTag:101];
    [homeAwayGoals addSubview:background];
    
    NSString *homeScore = [NSString stringWithFormat:@"%d", [one intValue]];
    NSString *awayScore = [NSString stringWithFormat:@"%d", [two intValue]];
    
    float total = [homeScore intValue]+[awayScore intValue];
    
    if (total ==0) {
        total = 1;
    }
    
    float totalPerSlot = background.frame.size.width / total;
    
    UIImageView *overlay = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,0,0)];
    overlay.frame = CGRectMake(background.frame.origin.x, background.frame.origin.y, totalPerSlot*[homeScore intValue], background.frame.size.height);
    [overlay setTag:102];
    [overlay setBackgroundColor:[UIColor blueColor]];
    
    [homeAwayGoals addSubview:overlay];
    
    [homeTeamLab setText:homeScore];
    [homeTeamLab setTag:103];
    [homeTeamLab setTextAlignment:NSTextAlignmentCenter];
    [homeAwayGoals addSubview:homeTeamLab];
    
    [awayTeamLab setText:awayScore];
    [awayTeamLab setTag:104];
    [awayTeamLab setTextAlignment:NSTextAlignmentCenter];
    [homeAwayGoals addSubview:awayTeamLab];
    
}


-(void)buildAwayScoreSlider:(NSString *)one two:(NSString *)two {
    
    for (UIView *imView in homeAwayGoals.subviews) {
        
        if (imView.tag == 1011 || imView.tag == 1021 || imView.tag == 1031 || imView.tag == 1041) {
            [imView removeFromSuperview];
        }
    }
    
    int y = 105;
    
    UILabel *homeTeamLab = [[UILabel alloc]initWithFrame:CGRectMake(0, y, 40, 25)];
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake((homeTeamLab.frame.size.width+homeTeamLab.frame.origin.x)+3, y, self.view.frame.size.width-(homeTeamLab.frame.size.width+homeTeamLab.frame.origin.x)*2, 25)];
    UILabel *awayTeamLab = [[UILabel alloc]initWithFrame:CGRectMake((background.frame.size.width+background.frame.origin.x), y, 40, 25)];
    
    [background setBackgroundColor:[UIColor colorWithRed:0.160784 green:0.615686 blue:0.839216 alpha:1]];
    [background setTag:1011];
    [homeAwayGoals addSubview:background];
    
    NSString *homeScore = [NSString stringWithFormat:@"%d", [one intValue]];
    NSString *awayScore = [NSString stringWithFormat:@"%d", [two intValue]];
    
    float total = [homeScore intValue]+[awayScore intValue];
    
    if (total ==0) {
        total = 1;
    }
    
    float totalPerSlot = background.frame.size.width / total;
    
    UIImageView *overlay = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,0,0)];
    overlay.frame = CGRectMake(background.frame.origin.x, background.frame.origin.y, totalPerSlot*[homeScore intValue], background.frame.size.height);
    [overlay setTag:1021];
    [overlay setBackgroundColor:[UIColor blueColor]];
    
    [homeAwayGoals addSubview:overlay];
    
    [homeTeamLab setText:homeScore];
    [homeTeamLab setTag:1031];
    [homeTeamLab setTextAlignment:NSTextAlignmentCenter];
    [homeAwayGoals addSubview:homeTeamLab];
    
    [awayTeamLab setText:awayScore];
    [awayTeamLab setTag:1041];
    [awayTeamLab setTextAlignment:NSTextAlignmentCenter];
    [homeAwayGoals addSubview:awayTeamLab];
    
}


-(void)buildYellowCardSlider:(NSString *)one two:(NSString *)two {
    
    for (UIView *imView in cardsView.subviews) {
        
        if (imView.tag == 111 || imView.tag == 112 || imView.tag == 113 || imView.tag == 114) {
            [imView removeFromSuperview];
        }
    }
    
    int y = 43;
    
    UILabel *homeTeamLab = [[UILabel alloc]initWithFrame:CGRectMake(0, y, 40, 25)];
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake((homeTeamLab.frame.size.width+homeTeamLab.frame.origin.x)+3, y, self.view.frame.size.width-(homeTeamLab.frame.size.width+homeTeamLab.frame.origin.x)*2, 25)];
    UILabel *awayTeamLab = [[UILabel alloc]initWithFrame:CGRectMake((background.frame.size.width+background.frame.origin.x), y, 40, 25)];
    
    
    [background setBackgroundColor:[UIColor colorWithRed:0.160784 green:0.615686 blue:0.839216 alpha:1]];
    [background setTag:111];
    [cardsView addSubview:background];
    
    NSString *homeScore = [NSString stringWithFormat:@"%d", [one intValue]];
    NSString *awayScore = [NSString stringWithFormat:@"%d", [two intValue]];
    
    float total = [homeScore intValue]+[awayScore intValue];
    
    if (total ==0) {
        total = 1;
    }
    
    float totalPerSlot = background.frame.size.width / total;
    
    UIImageView *overlay = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,0,0)];
    overlay.frame = CGRectMake(background.frame.origin.x, background.frame.origin.y, totalPerSlot*[homeScore intValue], background.frame.size.height);
    [overlay setTag:112];
    [overlay setBackgroundColor:[UIColor blueColor]];
    
    [cardsView addSubview:overlay];
    
    [homeTeamLab setText:homeScore];
    [homeTeamLab setTag:113];
    [homeTeamLab setTextAlignment:NSTextAlignmentCenter];
    [cardsView addSubview:homeTeamLab];
    
    [awayTeamLab setText:awayScore];
    [awayTeamLab setTag:114];
    [awayTeamLab setTextAlignment:NSTextAlignmentCenter];
    [cardsView addSubview:awayTeamLab];

}


-(void)buildRedCardSlider:(NSString *)one two:(NSString *)two {
    
    for (UIView *imView in cardsView.subviews) {
        
        if (imView.tag == 101 || imView.tag == 102 || imView.tag == 103 || imView.tag == 104) {
            [imView removeFromSuperview];
        }
    }
    
    int y = 106;
    
    UILabel *homeTeamLab = [[UILabel alloc]initWithFrame:CGRectMake(0, y, 40, 25)];
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake((homeTeamLab.frame.size.width+homeTeamLab.frame.origin.x)+3, y, self.view.frame.size.width-(homeTeamLab.frame.size.width+homeTeamLab.frame.origin.x)*2, 25)];
    UILabel *awayTeamLab = [[UILabel alloc]initWithFrame:CGRectMake((background.frame.size.width+background.frame.origin.x), y, 40, 25)];
    
    [background setBackgroundColor:[UIColor colorWithRed:0.160784 green:0.615686 blue:0.839216 alpha:1]];
    [background setTag:101];
    [cardsView addSubview:background];
    
    NSString *homeScore = [NSString stringWithFormat:@"%d", [one intValue]];
    NSString *awayScore = [NSString stringWithFormat:@"%d", [two intValue]];
    
    float total = [homeScore intValue]+[awayScore intValue];
    
    if (total ==0) {
        total = 1;
    }
    
    float totalPerSlot = background.frame.size.width / total;
    
    UIImageView *overlay = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,0,0)];
    overlay.frame = CGRectMake(background.frame.origin.x, background.frame.origin.y, totalPerSlot*[homeScore intValue], background.frame.size.height);
    [overlay setTag:102];
    [overlay setBackgroundColor:[UIColor blueColor]];
    
    [cardsView addSubview:overlay];
    
    [homeTeamLab setText:homeScore];
    [homeTeamLab setTag:103];
    [homeTeamLab setTextAlignment:NSTextAlignmentCenter];
    [cardsView addSubview:homeTeamLab];
    
    [awayTeamLab setText:awayScore];
    [awayTeamLab setTag:104];
    [awayTeamLab setTextAlignment:NSTextAlignmentCenter];
    [cardsView addSubview:awayTeamLab];
    
}





-(void)buildYellowCardSliderEntireSeason:(NSString *)one two:(NSString *)two {
    
    for (UIView *imView in entireSeasonCards.subviews) {
        
        if (imView.tag == 111 || imView.tag == 112 || imView.tag == 113 || imView.tag == 114) {
            [imView removeFromSuperview];
        }
    }
    
    
    
    int y = 42;
    
    UILabel *homeTeamLab = [[UILabel alloc]initWithFrame:CGRectMake(0, y, 40, 25)];
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake((homeTeamLab.frame.size.width+homeTeamLab.frame.origin.x)+3, y, self.view.frame.size.width-(homeTeamLab.frame.size.width+homeTeamLab.frame.origin.x)*2, 25)];
    UILabel *awayTeamLab = [[UILabel alloc]initWithFrame:CGRectMake((background.frame.size.width+background.frame.origin.x), y, 40, 25)];
    
    
    [background setBackgroundColor:[UIColor colorWithRed:0.160784 green:0.615686 blue:0.839216 alpha:1]];
    [background setTag:111];
    [entireSeasonCards addSubview:background];
    
    NSString *homeScore = [NSString stringWithFormat:@"%d", [one intValue]];
    NSString *awayScore = [NSString stringWithFormat:@"%d", [two intValue]];
    
    float total = [homeScore intValue]+[awayScore intValue];
    
    if (total ==0) {
        total = 1;
    }
    
    float totalPerSlot = background.frame.size.width / total;
    
    UIImageView *overlay = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,0,0)];
    overlay.frame = CGRectMake(background.frame.origin.x, background.frame.origin.y, totalPerSlot*[homeScore intValue], background.frame.size.height);
    [overlay setTag:112];
    [overlay setBackgroundColor:[UIColor blueColor]];
    
    [entireSeasonCards addSubview:overlay];
    
    [homeTeamLab setText:homeScore];
    [homeTeamLab setTag:113];
    [homeTeamLab setTextAlignment:NSTextAlignmentCenter];
    [entireSeasonCards addSubview:homeTeamLab];
    
    [awayTeamLab setText:awayScore];
    [awayTeamLab setTag:114];
    [awayTeamLab setTextAlignment:NSTextAlignmentCenter];
    [entireSeasonCards addSubview:awayTeamLab];
    
}


-(void)buildRedCardSliderEntireSeason:(NSString *)one two:(NSString *)two {
    
    for (UIView *imView in entireSeasonCards.subviews) {
        
        if (imView.tag == 101 || imView.tag == 102 || imView.tag == 103 || imView.tag == 104) {
            [imView removeFromSuperview];
        }
    }
    
    int y = 106;
    
    UILabel *homeTeamLab = [[UILabel alloc]initWithFrame:CGRectMake(0, y, 40, 25)];
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake((homeTeamLab.frame.size.width+homeTeamLab.frame.origin.x)+3, y, self.view.frame.size.width-(homeTeamLab.frame.size.width+homeTeamLab.frame.origin.x)*2, 25)];
    UILabel *awayTeamLab = [[UILabel alloc]initWithFrame:CGRectMake((background.frame.size.width+background.frame.origin.x), y, 40, 25)];

    
    [background setBackgroundColor:[UIColor colorWithRed:0.160784 green:0.615686 blue:0.839216 alpha:1]];
    [background setTag:101];
    [entireSeasonCards addSubview:background];
    
    NSString *homeScore = [NSString stringWithFormat:@"%d", [one intValue]];
    NSString *awayScore = [NSString stringWithFormat:@"%d", [two intValue]];
    
    float total = [homeScore intValue]+[awayScore intValue];
    
    if (total ==0) {
        total = 1;
    }
    
    float totalPerSlot = background.frame.size.width / total;
    
    UIImageView *overlay = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,0,0)];
    overlay.frame = CGRectMake(background.frame.origin.x, background.frame.origin.y, totalPerSlot*[homeScore intValue], background.frame.size.height);
    [overlay setTag:102];
    [overlay setBackgroundColor:[UIColor blueColor]];
    
    [entireSeasonCards addSubview:overlay];
    
    [homeTeamLab setText:homeScore];
    [homeTeamLab setTag:103];
    [homeTeamLab setTextAlignment:NSTextAlignmentCenter];
    [entireSeasonCards addSubview:homeTeamLab];
    
    [awayTeamLab setText:awayScore];
    [awayTeamLab setTag:104];
    [awayTeamLab setTextAlignment:NSTextAlignmentCenter];
    [entireSeasonCards addSubview:awayTeamLab];
    
}



-(void)viewDidAppear:(BOOL)animated {
    [self updateLastXGames];

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
    
    [tabBar setItems:@[Leagues, fixtures, playerVs, formPlayers, statsExplorer, favourites, compare]animated:NO];
    
    
    [tabBar setSelectedItem:playerVs];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hidePicker:(id)sender {
    
    self.canDisplayBannerAds = YES;
    

    [UIView animateWithDuration:0.7 animations:^{
        [_entirePickerView setAlpha:0.0];
    }];
    
    [self updateLastXGames];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
            
            [_entirePickerView setFrame:CGRectMake(0, 0, _entirePickerView.frame.size.width, _entirePickerView.frame.size.height)];
            [_picker reloadAllComponents];
            
            [UIView animateWithDuration:0.4 animations:^{
                [_entirePickerView setAlpha:1.0];
            }];
            
        }
        
    } else {
        
        self.canDisplayBannerAds = NO;
        
        [_entirePickerView setFrame:CGRectMake(0, 0, _entirePickerView.frame.size.width, _entirePickerView.frame.size.height)];
        [_picker reloadAllComponents];
        
        [UIView animateWithDuration:0.4 animations:^{
            [_entirePickerView setAlpha:1.0];
        }];
        
    }
}


-(void)showPickerJustPaid {
    
    self.canDisplayBannerAds = NO;
    
    [_entirePickerView setFrame:CGRectMake(0, 0, _entirePickerView.frame.size.width, _entirePickerView.frame.size.height)];
    [_picker reloadAllComponents];

    [UIView animateWithDuration:0.4 animations:^{
        [_entirePickerView setAlpha:1.0];
    }];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag==9012) {
        
        if (buttonIndex == 1 ||buttonIndex == 2) {
            
            if ([SKPaymentQueue canMakePayments]) {
                
                HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [HUD setMode:MBProgressHUDModeIndeterminate];
                [HUD setDetailsLabelText:@"Loading..."];
                [HUD show:YES];
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

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response

{
    
    
    
    // remove wait view here
    
    
    
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



- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([[gamesArray objectAtIndex:row]isEqualToString:@"3 Games"]) {
        amountOfGames = @"3";
    } else if ([[gamesArray objectAtIndex:row]isEqualToString:@"5 Games"]) {
        amountOfGames = @"5";
    } else if ([[gamesArray objectAtIndex:row]isEqualToString:@"10 Games"]) {
        amountOfGames = @"10";
    }
    
    [_gameAmountText setText:[gamesArray objectAtIndex:row]];
    [lastXGames setText:[NSString stringWithFormat:@"Last %@",[gamesArray objectAtIndex:row]]];
    
    

}

-(void)updateLastXGames {
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setMode:MBProgressHUDModeIndeterminate];
    [HUD setLabelText:@"Loading"];
    [HUD setDetailsLabelText:@"Please wait..."];
    [HUD show:YES];

    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(actuallyUpdate) userInfo:nil repeats:NO];
    
}




-(void)actuallyUpdate {
    
    for (UIView *imView in lastXGamesView.subviews) {
        
        if (imView.tag == 101 || imView.tag == 102 || imView.tag == 103 || imView.tag == 104) {
            [imView removeFromSuperview];
        }
    }
    
    NSString *totScoredP1 = [[FootballFormDB sharedInstance]getTotalGoalsPerXGamesWithGameAmount:amountOfGames andPlayerID:[[playerOneData objectAtIndex:0] objectForKey:@"player_id"] leagueID:teamOneLeagueID];
    NSString *totScoredP2 = [[FootballFormDB sharedInstance]getTotalGoalsPerXGamesWithGameAmount:amountOfGames andPlayerID:[[playerTwoData objectAtIndex:0] objectForKey:@"player_id"] leagueID:teamTwoLeagueID];
    
    NSString *totScoredP1Home = [[FootballFormDB sharedInstance]getTotalGoalsPerXGamesWithGameAmountHome:amountOfGames andPlayerID:[[playerOneData objectAtIndex:0] objectForKey:@"player_id"] leagueID:teamOneLeagueID];
    NSString *totScoredP2Home = [[FootballFormDB sharedInstance]getTotalGoalsPerXGamesWithGameAmountHome:amountOfGames andPlayerID:[[playerTwoData objectAtIndex:0] objectForKey:@"player_id"] leagueID:teamTwoLeagueID];
    
    NSString *totScoredP1Away = [[FootballFormDB sharedInstance]getTotalGoalsPerXGamesWithGameAmountAway:amountOfGames andPlayerID:[[playerOneData objectAtIndex:0] objectForKey:@"player_id"] leagueID:teamOneLeagueID];
    NSString *totScoredP2Away = [[FootballFormDB sharedInstance]getTotalGoalsPerXGamesWithGameAmountAway:amountOfGames andPlayerID:[[playerTwoData objectAtIndex:0] objectForKey:@"player_id"] leagueID:teamTwoLeagueID];

    
    [lastXGamesTotScoredPlayerOne setText:[NSString stringWithFormat:@"Total Scored: %@",totScoredP1]];
    [lastXGamesTotScoredPlayerTwo setText:[NSString stringWithFormat:@"Total Scored: %@",totScoredP2]];
    
    [self buildYellowCardSlider:[[FootballFormDB sharedInstance]getTotalCardsPerXGamesWithGameAmount:amountOfGames andPlayerID:[[playerOneData objectAtIndex:0]objectForKey:@"player_id"] cardColour:@"Yellow" leagueID:teamOneLeagueID] two:[[FootballFormDB sharedInstance]getTotalCardsPerXGamesWithGameAmount:amountOfGames andPlayerID:[[playerTwoData objectAtIndex:0]objectForKey:@"player_id"] cardColour:@"Yellow" leagueID:teamTwoLeagueID]];
    
    [self buildRedCardSlider:[[FootballFormDB sharedInstance]getTotalCardsPerXGamesWithGameAmount:amountOfGames andPlayerID:[[playerOneData objectAtIndex:0]objectForKey:@"player_id"] cardColour:@"Red" leagueID:teamOneLeagueID] two:[[FootballFormDB sharedInstance]getTotalCardsPerXGamesWithGameAmount:amountOfGames andPlayerID:[[playerTwoData objectAtIndex:0]objectForKey:@"player_id"] cardColour:@"Red" leagueID:teamTwoLeagueID]];
    
    /*[self buildRedCardSlider:[[FootballFormDB sharedInstance]getPlayersTotalCards:[[playerOneData objectAtIndex:0] objectForKey:@"player_id"] colour:@"Red"] two:[[FootballFormDB sharedInstance]getPlayersTotalCards:[[playerTwoData objectAtIndex:0] objectForKey:@"player_id"] colour:@"Red"]];*/
    
    [lastXGamesAvgScoreTimePlayerOne setText:[NSString stringWithFormat:@"%1.f mins", [[[FootballFormDB sharedInstance]getAverageGoalScoreTimePerGame:amountOfGames andPlayerID:[[playerOneData objectAtIndex:0]objectForKey:@"player_id"]] floatValue]]];
    [lastXGamesAvgScoreTimePlayerTwo setText:[NSString stringWithFormat:@"%1.f mins", [[[FootballFormDB sharedInstance]getAverageGoalScoreTimePerGame:amountOfGames andPlayerID:[[playerTwoData objectAtIndex:0]objectForKey:@"player_id"]] floatValue]]];
    
    if ([lastXGamesAvgScoreTimePlayerOne.text isEqualToString:@"0 mins"]) {
        lastXGamesAvgScoreTimePlayerOne.text = @"N/A";
    }
    
    if ([lastXGamesAvgScoreTimePlayerTwo.text isEqualToString:@"0 mins"]) {
        lastXGamesAvgScoreTimePlayerTwo.text = @"N/A";
    }
    
    [lastXGamesAvgCardTimePlayer1 setText:[NSString stringWithFormat:@"%1.f mins", [[[FootballFormDB sharedInstance]getAverageTimeCardRecievedPerGame:amountOfGames andPlayerID:[[playerOneData objectAtIndex:0]objectForKey:@"player_id"]] floatValue]]];
    [lastXGamesAvgCardTimePlayer2 setText:[NSString stringWithFormat:@"%1.f mins", [[[FootballFormDB sharedInstance]getAverageTimeCardRecievedPerGame:amountOfGames andPlayerID:[[playerTwoData objectAtIndex:0]objectForKey:@"player_id"]] floatValue]]];
    
    if ([lastXGamesAvgCardTimePlayer1.text isEqualToString:@"0 mins"]) {
        lastXGamesAvgCardTimePlayer1.text = @"N/A";
    }
    
    if ([lastXGamesAvgCardTimePlayer2.text isEqualToString:@"0 mins"]) {
        lastXGamesAvgCardTimePlayer2.text = @"N/A";
    }
    
    int y = 55;
    
    UILabel *homeTeamLab = [[UILabel alloc]initWithFrame:CGRectMake(0, y, 40, 25)];
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake((homeTeamLab.frame.size.width+homeTeamLab.frame.origin.x)+3, y, self.view.frame.size.width-(homeTeamLab.frame.size.width+homeTeamLab.frame.origin.x)*2, 25)];
    UILabel *awayTeamLab = [[UILabel alloc]initWithFrame:CGRectMake((background.frame.size.width+background.frame.origin.x), y, 40, 25)];
    
    
    
    
    
    [background setBackgroundColor:[UIColor colorWithRed:0.160784 green:0.615686 blue:0.839216 alpha:1]];
    [background setTag:101];
    //[awayTeamColourBlock setBackgroundColor:background.backgroundColor];
    //[awayTeamColourBlock.layer setCornerRadius:awayTeamColourBlock.frame.size.width/2];
    [lastXGamesView addSubview:background];
    
    NSString *homeScore = [NSString stringWithFormat:@"%d", [totScoredP1 intValue]];
    NSString *awayScore = [NSString stringWithFormat:@"%d", [totScoredP2 intValue]];
    
    float total = [homeScore intValue]+[awayScore intValue];
    
    if (total ==0) {
        total = 1;
    }
    
    float totalPerSlot = background.frame.size.width / total;
        
    UIImageView *overlay = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,0,0)];
    overlay.frame = CGRectMake(background.frame.origin.x, background.frame.origin.y, totalPerSlot*[homeScore intValue], background.frame.size.height);
    [overlay setTag:102];
    [overlay setBackgroundColor:[UIColor blueColor]];
    //[homeTeamColourBlock setBackgroundColor:overlay.backgroundColor];
    //[homeTeamColourBlock.layer setCornerRadius:homeTeamColourBlock.frame.size.width/2];
    [lastXGamesView addSubview:overlay];
    
    
    
    [homeTeamLab setText:homeScore];
    [homeTeamLab setTag:103];
    [homeTeamLab setTextAlignment:NSTextAlignmentCenter];
    [lastXGamesView addSubview:homeTeamLab];
    
    
   
    
    [awayTeamLab setText:awayScore];
    [awayTeamLab setTag:104];
    [awayTeamLab setTextAlignment:NSTextAlignmentCenter];
    [lastXGamesView addSubview:awayTeamLab];
    
    
    
    /*
    NSString *totScoredHomeP1 = [[FootballFormDB sharedInstance]getPlayersTotalGoalsHomeAway:[[playerOneData objectAtIndex:0] objectForKey:@"player_id"] homeAway:@"Home"];
    NSString *totScoredHomeP2 = [[FootballFormDB sharedInstance]getPlayersTotalGoalsHomeAway:[[playerTwoData objectAtIndex:0] objectForKey:@"player_id"] homeAway:@"Home"];
    
    NSString *totScoredAwayP1 = [[FootballFormDB sharedInstance]getPlayersTotalGoalsHomeAway:[[playerOneData objectAtIndex:0] objectForKey:@"player_id"] homeAway:@"Away"];
    NSString *totScoredAwayP2 = [[FootballFormDB sharedInstance]getPlayersTotalGoalsHomeAway:[[playerTwoData objectAtIndex:0] objectForKey:@"player_id"] homeAway:@"Away"];
     */
    
    [self buildHomeScoreSlider:totScoredP1Home two:totScoredP2Home];
    [self buildAwayScoreSlider:totScoredP1Away two:totScoredP2Away];
    
    NSString *totScoredP11 = [[FootballFormDB sharedInstance]getPlayersTotalGoals:[[playerOneData objectAtIndex:0] objectForKey:@"player_id"] leagueID:teamOneLeagueID];
    NSString *totScoredP22 = [[FootballFormDB sharedInstance]getPlayersTotalGoals:[[playerTwoData objectAtIndex:0] objectForKey:@"player_id"] leagueID:teamTwoLeagueID];
    [self buildTotalScoreSlider:totScoredP11 two:totScoredP22];



    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hideHud) userInfo:nil repeats:NO];
 
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [gamesArray count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [gamesArray objectAtIndex:row];
}

@end
