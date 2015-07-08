//
//  CompareGraphViewController.m
//  Football Form
//
//  Created by Aaron Wilkinson on 09/12/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import "CompareGraphViewController.h"
#import "FootballFormDB.h"

@interface CompareGraphViewController ()

@end

@implementation CompareGraphViewController

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
    circleOne.layer.cornerRadius = circleOne.frame.size.width/2;
    circleTwo.layer.cornerRadius = circleTwo.frame.size.width/2;
    
    /*
    if (!IS_IPHONE5) {
        [vi setFrame:CGRectMake(-30, vi.frame.origin.y, vi.frame.size.width, vi.frame.size.height)];
        [chartView setFrame:CGRectMake(chartView.frame.origin.x, chartView.frame.origin.y, 470, chartView.frame.size.height)];

    }
     */
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    
    [revealController setRecognizesPanningOnFrontView:NO];

    
    
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}


#pragma mark Shinobi Charts

- (long)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 2;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(long)index {    
    
    l = [SChartLineSeries new];
    l.animationEnabled = YES;
    l.crosshairEnabled = YES;
    l.selectionMode = SChartSelectionPoint;
    
    l.style.lineWidth = [NSNumber numberWithInt:2];
    l.style.pointStyle.radius = [NSNumber numberWithInt:12];
    l.style.pointStyle.innerRadius = [NSNumber numberWithInt:5];
    
    l.style.lineColor = [UIColor colorWithRed:0/255.0f green:147/255.0f blue:182/255.0f alpha:1];
    
    l.style.pointStyle.color = [UIColor colorWithRed:0/255.0f green:147/255.0f blue:182/255.0f alpha:1];
    
    if (index == 0) {
        l.style.lineColor = [UIColor orangeColor];
        l.style.pointStyle.color = [UIColor orangeColor];
    }
    
       l.style.pointStyle.showPoints = YES;
    
    return l;

}

- (long)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(long)seriesIndex {
    return [teamOneGameData count];
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(long)dataIndex forSeriesAtIndex:(long)seriesIndex {
    
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    
    if (seriesIndex == 0) {
        
        datapoint.xValue = [NSNumber numberWithInt:theDayTeamOne];

        theDayTeamOne = theDayTeamOne+1;
        
        if (teamOneGameData.count>dataIndex) {
            
            datapoint.yValue = [NSNumber numberWithInt:[[[teamOneGameData objectAtIndex:dataIndex] objectForKey:@"cumulativeAmount"] intValue]];
            
        } else {
            
            datapoint.yValue = [NSNumber numberWithInt:[[[teamOneGameData objectAtIndex:teamOneGameData.count-1] objectForKey:@"cumulativeAmount"] intValue]];
            
        }

    } else {
        
        datapoint.xValue = [NSNumber numberWithInt:theDayTeamTwo];
        
        theDayTeamTwo = theDayTeamTwo+1;
        
        if (teamTwoGameData.count>dataIndex) {
        
            datapoint.yValue = [NSNumber numberWithInt:[[[teamTwoGameData objectAtIndex:dataIndex] objectForKey:@"cumulativeAmount"] intValue]];
            
        } else {
            
            datapoint.yValue = [NSNumber numberWithInt:[[[teamTwoGameData objectAtIndex:teamTwoGameData.count-1] objectForKey:@"cumulativeAmount"] intValue]];
            
        }
    }
    
    return datapoint;
}

-(void)viewWillAppear:(BOOL)animated {
    
    TeamOnePointsType.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"gameTypeStatsToGraphOne"];
    TeamTwoPointsType.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"gameTypeStatsToGraphTwo"];
    numberOfGames.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"noOfGamesStatsToGraph"];
    
    [entirePickerView setAlpha:0.0];
    [entirePickerView setFrame:CGRectMake(0, 0, 568, 320)];
    
    //Here's the data set up
    teamOneData = [[FootballFormDB sharedInstance]getTeamDataFromID:[[NSUserDefaults standardUserDefaults]objectForKey:@"compareTeamOneID"]];
    teamTwoData = [[FootballFormDB sharedInstance]getTeamDataFromID:[[NSUserDefaults standardUserDefaults]objectForKey:@"compareTeamTwoID"]];
    
    [_teamOne setText: [[teamOneData objectAtIndex:0]objectForKey:@"teamName"]];
    [_teamTwo setText: [[teamTwoData objectAtIndex:0]objectForKey:@"teamName"]];
    
    teamOneID = [[teamOneData objectAtIndex:0]objectForKey:@"id"];
    teamTwoID = [[teamTwoData objectAtIndex:0]objectForKey:@"id"];
    
    allHomeOrAwayTeamOne = @"0";
    allHomeOrAwayTeamTwo = @"0";
    
    teamOneGameData = [[NSUserDefaults standardUserDefaults]mutableArrayValueForKey:@"teamOneGraphPlottingDictionary"];
    teamTwoGameData = [[NSUserDefaults standardUserDefaults]mutableArrayValueForKey:@"teamTwoGraphPlottingDictionary"];
    
    [self setUpTabBar];
    [self setUpGraph];
}


-(void)setUpGraph {
    
    for (ShinobiChart *chart in chartView.subviews) {
        [chart removeFromSuperview];
    }
    
    totalTeamOne = 0;
    theDayTeamOne = 1;
    theDayTeamTwo = 1;
    _chart = [[ShinobiChart alloc] initWithFrame:CGRectMake(0, 0, chartView.frame.size.width, chartView.frame.size.height)];
    _chart.title = @"";
    
    float max = [[[teamOneGameData objectAtIndex:[teamOneGameData count]-1] objectForKey:@"point"] intValue]+1.1;
    
    SChartNumberRange *r2 = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:1] andMaximum:[NSNumber numberWithFloat:max]];
    SChartNumberAxis *xAxis = [[SChartNumberAxis alloc] initWithRange:r2];
    [xAxis setMajorTickFrequency:@1];
    
    _chart.xAxis = xAxis;
    
    //Code here for the maximum value on a graph
    
    NSString *cumulativeData1 = [[teamOneGameData objectAtIndex:[teamOneGameData count]-1] objectForKey:@"cumulativeAmount"];
    NSString *cumulativeData2 = [[teamTwoGameData objectAtIndex:[teamTwoGameData count]-1] objectForKey:@"cumulativeAmount"];
    
    float biggest;
    if ([cumulativeData1 intValue]>[cumulativeData2 intValue]) {
        biggest = [cumulativeData1 intValue];
    } else {
        biggest = [cumulativeData2 intValue];
    }
    
    biggest = biggest + 0.4;
    
    SChartNumberRange *r = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithFloat:biggest]];
    SChartNumberAxis *yAxis = [[SChartNumberAxis alloc] initWithRange:r];
    //yAxis.anchorPoint = @0;
    [yAxis setMajorTickFrequency:@1];
    _chart.yAxis = yAxis;
    

    _chart.datasource = self;
     _chart.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _chart.backgroundColor = [UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1];

    [chartView addSubview:_chart];
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


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backRoot {
    [self.navigationController popViewControllerAnimated:YES];
    //Listen for NSNotification
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(ag) userInfo:nil repeats:NO];
   

}

@end
