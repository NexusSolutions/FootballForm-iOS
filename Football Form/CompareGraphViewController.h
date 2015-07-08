//
//  CompareGraphViewController.h
//  Football Form
//
//  Created by Aaron Wilkinson on 09/12/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiCharts/ShinobiChart.h>
#import <ShinobiCharts/SChartCanvas.h>
#import <QuartzCore/QuartzCore.h>
@interface CompareGraphViewController : UIViewController <SChartDatasource, SChartDelegate> {

    NSMutableArray *teamOneData;
    NSMutableArray *teamTwoData;
    NSString *teamOneID;
    NSString *teamTwoID;
    __weak IBOutlet UISegmentedControl *segControlOne;
    __weak IBOutlet UISegmentedControl *segControlTwo;

    NSMutableArray *teamOneGameData;
    NSMutableArray *teamTwoGameData;
    
    NSString *amountOfGames;

    //Build the pickerview
    __weak IBOutlet UIView *entirePickerView;
    __weak IBOutlet UIPickerView *picker;

    NSArray *amountOfGamesArray;

    NSString *allHomeOrAwayTeamOne;
    NSString *allHomeOrAwayTeamTwo;
    
    NSString *totalPoints1;
    NSString *totalPoints2;
    
    
    SChartLineSeries *l;
    
    __weak IBOutlet UIView *chartView;
    
    int totalTeamOne;
    int totalTeamTwo;
    
    int theDayTeamOne;
    int theDayTeamTwo;
    
    NSMutableArray *teamOneDataPoints;
    NSMutableArray *teamTwoDataPoints;
    
    
    __weak IBOutlet UIView *vi;
    
    
    __weak IBOutlet UILabel *TeamOnePointsType;
    __weak IBOutlet UILabel *numberOfGames;
    __weak IBOutlet UILabel *TeamTwoPointsType;
    
    
    __weak IBOutlet UILabel *titlab;
    
    __weak IBOutlet UIImageView *circleOne;
    
    __weak IBOutlet UIImageView *circleTwo;

}
- (IBAction)back:(id)sender;
    - (IBAction)hidePickerView:(id)sender;
    - (IBAction)showPicker:(id)sender;
    - (IBAction)teamOneSegChanged:(id)sender;
    - (IBAction)teamTwoSegChanged:(id)sender;

    @property (weak, nonatomic) IBOutlet UITabBar *tabBar;
    @property (weak, nonatomic) IBOutlet UILabel *teamOne;
    @property (weak, nonatomic) IBOutlet UILabel *teamTwo;
    @property (strong, readwrite) ShinobiChart* chart;

@end
