//
//  FixtureDetailsViewController.m
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import "FixtureDetailsViewController.h"

@interface FixtureDetailsViewController ()

@end

@implementation FixtureDetailsViewController

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
    
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    
    /*
    if (!IS_IPHONE5) {
        [noOfGamesView setFrame:CGRectMake(428-88, noOfGamesView.frame.origin.y, noOfGamesView.frame.size.width, noOfGamesView.frame.size.height)];
    }
     */
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}





-(void)viewWillAppear:(BOOL)animated {
    
    [self setUpTabBar];
    
    gamesArray = @[@"3 Games", @"5 Games", @"10 Games"];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"numberOfGamesFixtures"]!=nil) {
        numberOfGames = [[NSUserDefaults standardUserDefaults]objectForKey:@"numberOfGamesFixtures"];
    } else {
    numberOfGames = @"3";
    }
    
    _awayOne.hidden=1;
    _awayTwo.hidden=1;
    _awayThree.hidden=1;
    _awayFour.hidden=1;
    _homeOne.hidden=1;
    _homeTwo.hidden=1;
    _homeThree.hidden=1;
    _homefour.hidden=1;
    _awayFive.hidden=1;
    _awaySix.hidden=1;
    _awaySeven.hidden=1;
    _awayEight.hidden=1;
    _homeFive.hidden=1;
    _homeSix.hidden=1;
    _homeSeven.hidden=1;
    _homeEight.hidden=1;
    
    
    _awayExtraOne.hidden=1;
    _awayExtraTwo.hidden=1;
    _awayExtraThree.hidden=1;
    _awayExtraFour.hidden=1;
    _awayExtraFive.hidden=1;
    _awayExtraSix.hidden=1;
    _homeExtraOne.hidden=1;
    _homeExtraTwo.hidden=1;
    _homeExtraThree.hidden=1;
    _homeExtraFour.hidden=1;
    _homeExtraFive.hidden=1;
    _homeExtraSix.hidden=1;
    _awayExtraEight.hidden=1;
    _awayExtraNine.hidden=1;
    _awayExtraTen.hidden=1;
    _awayExtraEleven.hidden=1;
    _awayExtraTwelve.hidden=1;
    _awayExtraThirteen.hidden=1;
    _homeExtraEight.hidden=1;
    _homeExtraNine.hidden=1;
    _homeExtraTen.hidden=1;
    _homeExtraEleven.hidden=1;
    _homeExtraTwelve.hidden=1;
    _homeExtraThirteen.hidden=1;
    

    [_awayOne.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_awayOne setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_awayOne addTarget:self action:@selector(awayColOneSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [_awayTwo.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_awayTwo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_awayTwo addTarget:self action:@selector(awayColOneSelect:) forControlEvents:UIControlEventTouchUpInside];

    [_awayThree.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_awayThree setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_awayThree addTarget:self action:@selector(awayColOneSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_awayFour.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_awayFour setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_awayFour addTarget:self action:@selector(awayColOneSelect:) forControlEvents:UIControlEventTouchUpInside];

    [_homeOne.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_homeOne setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_homeOne addTarget:self action:@selector(homeColTwoSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_homeTwo.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_homeTwo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_homeTwo addTarget:self action:@selector(homeColTwoSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_homeThree.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_homeThree setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_homeThree addTarget:self action:@selector(homeColTwoSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_homefour.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_homefour setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_homefour addTarget:self action:@selector(homeColTwoSelect:) forControlEvents:UIControlEventTouchUpInside];


    [_awayFive.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_awayFive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_awayFive addTarget:self action:@selector(awayColThreeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_awaySix.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_awaySix setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_awaySix addTarget:self action:@selector(awayColThreeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_awaySeven.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_awaySeven setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_awaySeven addTarget:self action:@selector(awayColThreeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_awayEight.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_awayEight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_awayEight addTarget:self action:@selector(awayColThreeSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [_homeFive.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_homeFive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_homeFive addTarget:self action:@selector(homeColFourForSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_homeSix.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_homeSix setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_homeSix addTarget:self action:@selector(homeColFourForSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_homeSeven.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_homeSeven setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_homeSeven addTarget:self action:@selector(homeColFourForSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_homeEight.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_homeEight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_homeEight addTarget:self action:@selector(homeColFourForSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [_awayExtraOne.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_awayExtraOne setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_awayExtraOne addTarget:self action:@selector(awayColOneSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_awayExtraTwo.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_awayExtraTwo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_awayExtraTwo addTarget:self action:@selector(awayColOneSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_awayExtraThree.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_awayExtraThree setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_awayExtraThree addTarget:self action:@selector(awayColOneSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_awayExtraFour.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_awayExtraFour setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_awayExtraFour addTarget:self action:@selector(awayColOneSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_awayExtraFive.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_awayExtraFive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_awayExtraFive addTarget:self action:@selector(awayColOneSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_awayExtraSix.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_awayExtraSix setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_awayExtraSix addTarget:self action:@selector(awayColOneSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [_homeExtraOne.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_homeExtraOne setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_homeExtraOne addTarget:self action:@selector(homeColTwoSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_homeExtraTwo.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_homeExtraTwo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_homeExtraTwo addTarget:self action:@selector(homeColTwoSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_homeExtraThree.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_homeExtraThree setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_homeExtraThree addTarget:self action:@selector(homeColTwoSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_homeExtraFour.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_homeExtraFour setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_homeExtraFour addTarget:self action:@selector(homeColTwoSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_homeExtraFive.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_homeExtraFive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_homeExtraFive addTarget:self action:@selector(homeColTwoSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_homeExtraSix.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_homeExtraSix setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_homeExtraSix addTarget:self action:@selector(homeColTwoSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [_awayExtraEight.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_awayExtraEight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_awayExtraEight addTarget:self action:@selector(awayColThreeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_awayExtraNine.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_awayExtraNine setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_awayExtraNine addTarget:self action:@selector(awayColThreeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_awayExtraTen.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_awayExtraTen setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_awayExtraTen addTarget:self action:@selector(awayColThreeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_awayExtraEleven.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_awayExtraEleven setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_awayExtraEleven addTarget:self action:@selector(awayColThreeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_awayExtraTwelve.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_awayExtraTwelve setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_awayExtraTwelve addTarget:self action:@selector(awayColThreeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_awayExtraThirteen.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_awayExtraThirteen setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [_homeExtraEight.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_homeExtraEight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_homeExtraEight addTarget:self action:@selector(homeColFourForSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_homeExtraNine.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_homeExtraNine setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_homeExtraNine addTarget:self action:@selector(homeColFourForSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_homeExtraTen.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_homeExtraTen setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_homeExtraTen addTarget:self action:@selector(homeColFourForSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_homeExtraEleven.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_homeExtraEleven setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_homeExtraEleven addTarget:self action:@selector(homeColFourForSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_homeExtraTwelve.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_homeExtraTwelve setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_homeExtraTwelve addTarget:self action:@selector(homeColFourForSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_homeExtraThirteen.titleLabel setFont:[UIFont systemFontOfSize:7]];
    [_homeExtraThirteen setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_homeExtraThirteen addTarget:self action:@selector(homeColFourForSelect:) forControlEvents:UIControlEventTouchUpInside];

    _homeTeam.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"homeTeamCarry"];
    _awayTeam.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"awayTeamCarry"];
    
    homeTeamID = [[NSUserDefaults standardUserDefaults]objectForKey:@"homeTeamIDCarry"];
    awayTeamID = [[NSUserDefaults standardUserDefaults]objectForKey:@"awayTeamIDCarry"];
    

    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [pickerEntireView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, 320)];
    /*
    if (!IS_IPHONE5) {
        [hidePickerBut setFrame:CGRectMake(360, hidePickerBut.frame.origin.y, hidePickerBut.frame.size.width, hidePickerBut.frame.size.height)];
    }
     */
    
    pickerEntireView.alpha=0.0;
    
    [self getPreviousMatchesForAwayTeam];
    [self getPreviousMatchesForHomeTeam];

    
}

-(void)awayColOneSelect:(UIButton *)sender {
    
    if ([[awayColumnOne objectAtIndex:sender.tag]isEqualToString:@"100000000"]) {
        
        
    } else {
        
    [[NSUserDefaults standardUserDefaults]setObject:[awayColumnOne objectAtIndex:sender.tag] forKey:@"fixtureIDCarried"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self goToGameDetails];
        
    }
}

-(void)homeColTwoSelect:(UIButton *)sender {
    
    if ([[awayColumnOne objectAtIndex:sender.tag]isEqualToString:@"100000000"]) {
        
        
    } else {
        
    [[NSUserDefaults standardUserDefaults]setObject:[homeColumnTwo objectAtIndex:sender.tag] forKey:@"fixtureIDCarried"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self goToGameDetails];
        
    }
}

-(void)awayColThreeSelect:(UIButton *)sender {
    if ([[awayColumnOne objectAtIndex:sender.tag]isEqualToString:@"100000000"]) {
        
        
    } else {
        
    [[NSUserDefaults standardUserDefaults]setObject:[awayColumnThree objectAtIndex:sender.tag] forKey:@"fixtureIDCarried"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self goToGameDetails];
        
    }
}

-(void)homeColFourForSelect:(UIButton *)sender {
    if ([[awayColumnOne objectAtIndex:sender.tag]isEqualToString:@"100000000"]) {
        
        
    } else {
        
    [[NSUserDefaults standardUserDefaults]setObject:[homeColumnFour objectAtIndex:sender.tag] forKey:@"fixtureIDCarried"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self goToGameDetails];
        
    }
}

-(void)goToGameDetails {
    [[NSUserDefaults standardUserDefaults]setObject:numberOfGames forKey:@"numberOfGamesFixtures"];
    [self performSegueWithIdentifier:@"ToGameDetails" sender:self];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollViewy {
    /*
    if (!IS_IPHONE5) {
        [teamTitleView setFrame:CGRectMake(-scrollView.contentOffset.x, teamTitleView.frame.origin.y, teamTitleView.frame.size.width, teamTitleView.frame.size.height)];
    }
     */
}

-(void)getPreviousMatchesForAwayTeam {
    
    awayColumnThree = [NSMutableArray new];
    homeColumnFour = [NSMutableArray new];
    
    /*
    if (IS_IPHONE5) {
        [scrollView setContentSize:CGSizeMake(568, 40.25*[numberOfGames intValue])];
    } else {
        [scrollView setContentSize:CGSizeMake(655, 40.25*[numberOfGames intValue])];
    }
     */
    
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *tod  = [outputDateFormatter stringFromDate:[NSDate date]];

    gameData =[[FootballFormDB sharedInstance]getPreviousGamesForTeam:awayTeamID amountOfGames:numberOfGames date:tod];
    
    int index = 0;
    
    for (NSDictionary *gameDetails in gameData) {
        
        [awayColumnThree addObject:[gameDetails objectForKey:@"fixtureID"]];
        [homeColumnFour addObject:[gameDetails objectForKey:@"fixtureID"]];
        
        /*
        //Now we have got the names of the team, we are going to get the fixtureID back so we could use it later on in game details.
        NSString *tempHomeID = [[FootballFormDB sharedInstance]getTheTeamIDFromTeamName:[gameDetails objectForKey:@"homeTeam"]];
        NSString *tempAwayID = [[FootballFormDB sharedInstance]getTheTeamIDFromTeamName:[gameDetails objectForKey:@"awayTeam"]];
        NSString *leagueID = [[FootballFormDB sharedInstance]getTheFixtureID:tempHomeID awayTeamID:tempAwayID fixtureDate:[gameDetails objectForKey:@"fixtureDate"]];
        
        if (leagueID == nil) {
            
            [awayColumnThree addObject:@"100000000"];
            [homeColumnFour addObject:@"100000000"];
            
        } else {
            
            [awayColumnThree addObject:leagueID];
            [homeColumnFour addObject:leagueID];
            
        }
        */

        
        if ([[gameDetails objectForKey:@"teamAwayID"]isEqualToString:awayTeamID]) {
        //Away Team, Third Column
            
        
        NSString *dateString = [gameDetails objectForKey:@"fixtureDate"];
        dateString = [dateString stringByReplacingOccurrencesOfString:@" 00:00:00" withString:@""];
            
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:dateString];
        
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"dd/MM/yy"];
        NSString *strDate = [dateFormatter2 stringFromDate:dateFromString];
            
        UIImage *image;
            
        NSString *result;
        if ([[gameDetails objectForKey:@"teamAwayScore"]intValue] > [[gameDetails objectForKey:@"teamHomeScore"]intValue]) {
            //image = [[UIImage imageNamed:@"pillboxBgGreen@2x.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
            
            image = [UIImage imageNamed:@"bg-green.png"];
            result = @"W";
        } else if ([[gameDetails objectForKey:@"teamAwayScore"]intValue] < [[gameDetails objectForKey:@"teamHomeScore"]intValue]) {
            image = [UIImage imageNamed:@"bg-red.png"];
            result = @"L";
            
        } else if ([[gameDetails objectForKey:@"teamAwayScore"]intValue] == [[gameDetails objectForKey:@"teamHomeScore"]intValue]) {
            image = [UIImage imageNamed:@"bg-orange.png"];
            result = @"D";
        }
        
        NSString *buttonText = [NSString stringWithFormat:@"%@ %@-%@ %@ %@", [gameDetails objectForKey:@"homeTeam"], [gameDetails objectForKey:@"teamHomeScore"], [gameDetails objectForKey:@"teamAwayScore"], result, strDate];
            
            if (index ==0) {
                [_awayFive setBackgroundImage:image forState:UIControlStateNormal];
                _awayFive.hidden=0;
                [_awayFive setTitle:buttonText forState:UIControlStateNormal];
                [_awayFive setTag:index];
            } else if (index ==1) {
                [_awaySix setBackgroundImage:image forState:UIControlStateNormal];
                _awaySix.hidden=0;
                [_awaySix setTitle:buttonText forState:UIControlStateNormal];
                [_awaySix setTag:index];
            } else if (index ==2) {
                [_awaySeven setBackgroundImage:image forState:UIControlStateNormal];
                _awaySeven.hidden=0;
                [_awaySeven setTitle:buttonText forState:UIControlStateNormal];
                [_awaySeven setTag:index];
            } else if (index ==3) {
                [_awayEight setBackgroundImage:image forState:UIControlStateNormal];
                _awayEight.hidden=0;
                [_awayEight setTitle:buttonText forState:UIControlStateNormal];
                [_awayEight setTag:index];
            } else if (index ==4) {
                [_awayExtraEight setBackgroundImage:image forState:UIControlStateNormal];
                _awayExtraEight.hidden=0;
                [_awayExtraEight setTitle:buttonText forState:UIControlStateNormal];
                [_awayExtraEight setTag:index];
            } else if (index ==5) {
                [_awayExtraNine setBackgroundImage:image forState:UIControlStateNormal];
                _awayExtraNine.hidden=0;
                [_awayExtraNine setTitle:buttonText forState:UIControlStateNormal];
                [_awayExtraNine setTag:index];
            } else if (index ==6) {
                [_awayExtraTen setBackgroundImage:image forState:UIControlStateNormal];
                _awayExtraTen.hidden=0;
                [_awayExtraTen setTitle:buttonText forState:UIControlStateNormal];
                [_awayExtraTen setTag:index];
            } else if (index ==7) {
                [_awayExtraEleven setBackgroundImage:image forState:UIControlStateNormal];
                _awayExtraEleven.hidden=0;
                [_awayExtraEleven setTitle:buttonText forState:UIControlStateNormal];
                [_awayExtraEleven setTag:index];
            } else if (index ==8) {
                [_awayExtraTwelve setBackgroundImage:image forState:UIControlStateNormal];
                _awayExtraTwelve.hidden=0;
                [_awayExtraTwelve setTitle:buttonText forState:UIControlStateNormal];
                [_awayExtraTwelve setTag:index];
            } else if (index ==9) {
                [_awayExtraThirteen setBackgroundImage:image forState:UIControlStateNormal];
                _awayExtraThirteen.hidden=0;
                [_awayExtraThirteen setTitle:buttonText forState:UIControlStateNormal];
                [_awayExtraThirteen setTag:index];
            }
            
        } else {
            //Home Team, Fourth Column

            NSString *dateString = [gameDetails objectForKey:@"fixtureDate"];
             dateString = [dateString stringByReplacingOccurrencesOfString:@" 00:00:00" withString:@""];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            // this is imporant - we set our input date format to match our input string
            // if format doesn't match you'll get nil from your string, so be careful
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:dateString];
            
            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
            [dateFormatter2 setDateFormat:@"dd/MM/yy"];
            NSString *strDate = [dateFormatter2 stringFromDate:dateFromString];
            
            UIImage *image;
            
            NSString *result;
            if ([[gameDetails objectForKey:@"teamHomeScore"]intValue] > [[gameDetails objectForKey:@"teamAwayScore"]intValue]) {
                image = [UIImage imageNamed:@"bg-green.png"];
                result = @"W";
            } else if ([[gameDetails objectForKey:@"teamHomeScore"]intValue] < [[gameDetails objectForKey:@"teamAwayScore"]intValue]) {
                image = [UIImage imageNamed:@"bg-red.png"];
                result = @"L";
                
            } else if ([[gameDetails objectForKey:@"teamAwayScore"]intValue] == [[gameDetails objectForKey:@"teamHomeScore"]intValue]) {
                image = [UIImage imageNamed:@"bg-orange.png"];
                result = @"D";
            }
            
            NSString *buttonText = [NSString stringWithFormat:@"%@ %@-%@ %@ %@", [gameDetails objectForKey:@"awayTeam"], [gameDetails objectForKey:@"teamAwayScore"], [gameDetails objectForKey:@"teamHomeScore"], result, strDate];
            
            
            if (index ==0) {
                [_homeFive setBackgroundImage:image forState:UIControlStateNormal];
                _homeFive.hidden=0;
                [_homeFive setTitle:buttonText forState:UIControlStateNormal];
                [_homeFive setTag:index];
            } else if (index ==1) {
                [_homeSix setBackgroundImage:image forState:UIControlStateNormal];
                _homeSix.hidden=0;
                [_homeSix setTitle:buttonText forState:UIControlStateNormal];
                [_homeSix setTag:index];
            } else if (index ==2) {
                [_homeSeven setBackgroundImage:image forState:UIControlStateNormal];
                _homeSeven.hidden=0;
                [_homeSeven setTitle:buttonText forState:UIControlStateNormal];
                [_homeSeven setTag:index];
            } else if (index ==3) {
                [_homeEight setBackgroundImage:image forState:UIControlStateNormal];
                _homeEight.hidden=0;
                [_homeEight setTitle:buttonText forState:UIControlStateNormal];
                [_homeEight setTag:index];
            } else if (index ==4) {
                [_homeExtraEight setBackgroundImage:image forState:UIControlStateNormal];
                _homeExtraEight.hidden=0;
                [_homeExtraEight setTitle:buttonText forState:UIControlStateNormal];
                [_homeExtraEight setTag:index];
            } else if (index ==5) {
                [_homeExtraNine setBackgroundImage:image forState:UIControlStateNormal];
                _homeExtraNine.hidden=0;
                [_homeExtraNine setTitle:buttonText forState:UIControlStateNormal];
                [_homeExtraNine setTag:index];
            } else if (index ==6) {
                [_homeExtraTen setBackgroundImage:image forState:UIControlStateNormal];
                _homeExtraTen.hidden=0;
                [_homeExtraTen setTitle:buttonText forState:UIControlStateNormal];
                [_homeExtraTen setTag:index];
            } else if (index ==7) {
                [_homeExtraEleven setBackgroundImage:image forState:UIControlStateNormal];
                _homeExtraEleven.hidden=0;
                [_homeExtraEleven setTitle:buttonText forState:UIControlStateNormal];
                [_homeExtraEleven setTag:index];
            } else if (index ==8) {
                [_homeExtraTwelve setBackgroundImage:image forState:UIControlStateNormal];
                _homeExtraTwelve.hidden=0;
                [_homeExtraTwelve setTitle:buttonText forState:UIControlStateNormal];
                [_homeExtraTwelve setTag:index];
            } else if (index ==9) {
                [_homeExtraThirteen setBackgroundImage:image forState:UIControlStateNormal];
                _homeExtraThirteen.hidden=0;
                [_homeExtraThirteen setTitle:buttonText forState:UIControlStateNormal];
                [_homeExtraThirteen setTag:index];
            }
            
        }
        
        
        index = index +1;
    }

}






-(void)getPreviousMatchesForHomeTeam {
    
    //We want to add the teams id into the awayColumn and homeColumn data so we can then go onto stats explorer
    
    awayColumnOne = [NSMutableArray new];
    homeColumnTwo = [NSMutableArray new];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *tod  = [outputDateFormatter stringFromDate:[NSDate date]];
    
    gameData =[[FootballFormDB sharedInstance]getPreviousGamesForTeam:homeTeamID amountOfGames:numberOfGames date:tod];
    
    int index = 0;
    for (NSDictionary *gameDetails in gameData) {
        
        /*
        //Now we have got the names of the team, we are going to get the fixtureID back so we could use it later on in game details.
        //NSString *tempHomeID = [[FootballFormDB sharedInstance]getTheTeamIDFromTeamName:[gameDetails objectForKey:@"homeTeam"]];
       // NSString *tempAwayID = [[FootballFormDB sharedInstance]getTheTeamIDFromTeamName:[gameDetails objectForKey:@"awayTeam"]];
        NSString *leagueID = [[FootballFormDB sharedInstance]getTheFixtureID:homeTeamID awayTeamID:awayTeamID fixtureDate:[gameDetails objectForKey:@"fixtureDate"]];
        if (leagueID == nil) {
            [awayColumnOne addObject:@"100000000"];
            [homeColumnTwo addObject:@"100000000"];
        } else {
            [awayColumnOne addObject:leagueID];
            [homeColumnTwo addObject:leagueID];

        }
         */
                
        [awayColumnOne addObject:[gameDetails objectForKey:@"fixtureID"]];
        [homeColumnTwo addObject:[gameDetails objectForKey:@"fixtureID"]];
        
        if (![[gameDetails objectForKey:@"teamHomeID"]isEqualToString:homeTeamID]) {
            
            //Away Team, First Column
            NSString *dateString = [gameDetails objectForKey:@"fixtureDate"];
             dateString = [dateString stringByReplacingOccurrencesOfString:@" 00:00:00" withString:@""];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            // this is imporant - we set our input date format to match our input string
            // if format doesn't match you'll get nil from your string, so be careful
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:dateString];
            
            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
            [dateFormatter2 setDateFormat:@"dd/MM/yy"];
            NSString *strDate = [dateFormatter2 stringFromDate:dateFromString];
            
            UIImage *image;
            
            NSString *result;
            if ([[gameDetails objectForKey:@"teamAwayScore"]intValue] > [[gameDetails objectForKey:@"teamHomeScore"]intValue]) {
                image = [UIImage imageNamed:@"bg-green.png"];
                result = @"W";
            } else if ([[gameDetails objectForKey:@"teamAwayScore"]intValue] < [[gameDetails objectForKey:@"teamHomeScore"]intValue]) {
                image = [UIImage imageNamed:@"bg-red.png"];
                result = @"L";
                
            } else if ([[gameDetails objectForKey:@"teamAwayScore"]intValue] == [[gameDetails objectForKey:@"teamHomeScore"]intValue]) {
                image = [UIImage imageNamed:@"bg-orange.png"];
                result = @"D";
            }
            
            NSString *buttonText = [NSString stringWithFormat:@"%@ %@-%@ %@ %@", [gameDetails objectForKey:@"homeTeam"], [gameDetails objectForKey:@"teamHomeScore"], [gameDetails objectForKey:@"teamAwayScore"], result, strDate];
            
            
            if (index ==0) {
                [_awayOne setBackgroundImage:image forState:UIControlStateNormal];
                _awayOne.hidden=0;
                [_awayOne setTitle:buttonText forState:UIControlStateNormal];
                [_awayOne setTag:index];
            } else if (index ==1) {
                [_awayTwo setBackgroundImage:image forState:UIControlStateNormal];
                _awayTwo.hidden=0;
                [_awayTwo setTitle:buttonText forState:UIControlStateNormal];
                [_awayTwo setTag:index];
            } else if (index ==2) {
                [_awayThree setBackgroundImage:image forState:UIControlStateNormal];
                _awayThree.hidden=0;
                [_awayThree setTitle:buttonText forState:UIControlStateNormal];
                [_awayThree setTag:index];
            } else if (index ==3) {
                [_awayFour setBackgroundImage:image forState:UIControlStateNormal];
                _awayFour.hidden=0;
                [_awayFour setTitle:buttonText forState:UIControlStateNormal];
                [_awayFour setTag:index];
            } else if (index ==4) {
                [_awayExtraOne setBackgroundImage:image forState:UIControlStateNormal];
                _awayExtraOne.hidden=0;
                [_awayExtraOne setTitle:buttonText forState:UIControlStateNormal];
                [_awayExtraOne setTag:index];
            } else if (index ==5) {
                [_awayExtraTwo setBackgroundImage:image forState:UIControlStateNormal];
                _awayExtraTwo.hidden=0;
                [_awayExtraTwo setTitle:buttonText forState:UIControlStateNormal];
                [_awayExtraTwo setTag:index];
            } else if (index ==6) {
                [_awayExtraThree setBackgroundImage:image forState:UIControlStateNormal];
                _awayExtraThree.hidden=0;
                [_awayExtraThree setTitle:buttonText forState:UIControlStateNormal];
                [_awayExtraThree setTag:index];
            } else if (index ==7) {
                [_awayExtraFour setBackgroundImage:image forState:UIControlStateNormal];
                _awayExtraFour.hidden=0;
                [_awayExtraFour setTitle:buttonText forState:UIControlStateNormal];
                [_awayExtraFour setTag:index];
            } else if (index ==8) {
                [_awayExtraFive setBackgroundImage:image forState:UIControlStateNormal];
                _awayExtraFive.hidden=0;
                [_awayExtraFive setTitle:buttonText forState:UIControlStateNormal];
                [_awayExtraFive setTag:index];
            } else if (index ==9) {
                [_awayExtraSix setBackgroundImage:image forState:UIControlStateNormal];
                _awayExtraSix.hidden=0;
                [_awayExtraSix setTitle:buttonText forState:UIControlStateNormal];
                [_awayExtraSix setTag:index];
            }
            
        } else {
            
            //Home Team, Second Column
            
            NSString *dateString = [gameDetails objectForKey:@"fixtureDate"];
             dateString = [dateString stringByReplacingOccurrencesOfString:@" 00:00:00" withString:@""];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            // this is imporant - we set our input date format to match our input string
            // if format doesn't match you'll get nil from your string, so be careful
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:dateString];
            
            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
            [dateFormatter2 setDateFormat:@"dd/MM/yy"];
            NSString *strDate = [dateFormatter2 stringFromDate:dateFromString];
            
            UIImage *image;
            
            NSString *result;
            if ([[gameDetails objectForKey:@"teamAwayScore"]intValue] < [[gameDetails objectForKey:@"teamHomeScore"]intValue]) {
                image = [UIImage imageNamed:@"bg-green.png"];
                result = @"W";
            } else if ([[gameDetails objectForKey:@"teamAwayScore"]intValue] > [[gameDetails objectForKey:@"teamHomeScore"]intValue]) {
                image = [UIImage imageNamed:@"bg-red.png"];
                result = @"L";
                
            } else if ([[gameDetails objectForKey:@"teamAwayScore"]intValue] == [[gameDetails objectForKey:@"teamHomeScore"]intValue]) {
                image = [UIImage imageNamed:@"bg-orange.png"];
                result = @"D";
            }
            
            NSString *buttonText = [NSString stringWithFormat:@"%@ %@-%@ %@ %@", [gameDetails objectForKey:@"awayTeam"], [gameDetails objectForKey:@"teamAwayScore"], [gameDetails objectForKey:@"teamHomeScore"], result, strDate];
            
            
            if (index ==0) {
                [_homeOne setBackgroundImage:image forState:UIControlStateNormal];
                _homeOne.hidden=0;
                [_homeOne setTitle:buttonText forState:UIControlStateNormal];
                [_homeOne setTag:index];
            } else if (index ==1) {
                [_homeTwo setBackgroundImage:image forState:UIControlStateNormal];
                _homeTwo.hidden=0;
                [_homeTwo setTitle:buttonText forState:UIControlStateNormal];
                [_homeTwo setTag:index];
            } else if (index ==2) {
                [_homeThree setBackgroundImage:image forState:UIControlStateNormal];
                _homeThree.hidden=0;
                [_homeThree setTitle:buttonText forState:UIControlStateNormal];
                [_homeThree setTag:index];
            } else if (index ==3) {
                [_homefour setBackgroundImage:image forState:UIControlStateNormal];
                _homefour.hidden=0;
                [_homefour setTitle:buttonText forState:UIControlStateNormal];
                [_homefour setTag:index];
            } else if (index ==4) {
                [_homeExtraOne setBackgroundImage:image forState:UIControlStateNormal];
                _homeExtraOne.hidden=0;
                [_homeExtraOne setTitle:buttonText forState:UIControlStateNormal];
                [_homeExtraOne setTag:index];
            } else if (index ==5) {
                [_homeExtraTwo setBackgroundImage:image forState:UIControlStateNormal];
                _homeExtraTwo.hidden=0;
                [_homeExtraTwo setTitle:buttonText forState:UIControlStateNormal];
                [_homeExtraTwo setTag:index];
            } else if (index ==6) {
                [_homeExtraThree setBackgroundImage:image forState:UIControlStateNormal];
                _homeExtraThree.hidden=0;
                [_homeExtraThree setTitle:buttonText forState:UIControlStateNormal];
                [_homeExtraThree setTag:index];
            } else if (index ==7) {
                [_homeExtraFour setBackgroundImage:image forState:UIControlStateNormal];
                _homeExtraFour.hidden=0;
                [_homeExtraFour setTitle:buttonText forState:UIControlStateNormal];
                [_homeExtraFour setTag:index];
            } else if (index ==8) {
                [_homeExtraFive setBackgroundImage:image forState:UIControlStateNormal];
                _homeExtraFive.hidden=0;
                [_homeExtraFive setTitle:buttonText forState:UIControlStateNormal];
                [_homeExtraFive setTag:index];
            } else if (index ==9) {
                [_homeExtraSix setBackgroundImage:image forState:UIControlStateNormal];
                _homeExtraSix.hidden=0;
                [_homeExtraSix setTitle:buttonText forState:UIControlStateNormal];
                [_homeExtraSix setTag:index];
            }
        }
        
        index = index +1;
    }
    
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

#pragma mark Pickerview

- (IBAction)hidePicker:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        pickerEntireView.alpha=0.0;
    }];
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
            
            [UIView animateWithDuration:0.4 animations:^{
                [pickerEntireView setAlpha:1.0];
            }];
            
        }
        
    } else {
        
        [UIView animateWithDuration:0.4 animations:^{
            [pickerEntireView setAlpha:1.0];
        }];
        
    }
}


-(void)showPickerJustPaid {
    
    [UIView animateWithDuration:0.4 animations:^{
        [pickerEntireView setAlpha:1.0];
    }];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag==9012) {
        
        if (buttonIndex == 1||buttonIndex==2) {
            
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
        numberOfGames = @"3";
    } else if ([[gamesArray objectAtIndex:row]isEqualToString:@"5 Games"]) {
        numberOfGames = @"5";
    } else if ([[gamesArray objectAtIndex:row]isEqualToString:@"10 Games"]) {
        numberOfGames = @"10";
    }
    
    [self getPreviousMatchesForAwayTeam];
    [self getPreviousMatchesForHomeTeam];
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"backToFix"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"shouldUseSavedFixDet"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

@end
