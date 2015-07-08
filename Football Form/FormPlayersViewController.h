//
//  FormPlayersViewController.h
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface FormPlayersViewController : UIViewController <UITabBarDelegate, UITabBarControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, MBProgressHUDDelegate, UIScrollViewDelegate> {
    
    NSString *whichPicker;
    NSString *selectedLeagueID;
    NSArray *gamesArray;
    NSArray *gamesValue;
    NSMutableArray *leagues;
    
    NSString *currentGameAmount;
    NSString *currentLeague;
    
    NSMutableArray *firstHalfGoals;
    NSMutableArray *secondHalfGoals;
    
    __weak IBOutlet UIScrollView *scrollView;
    
    BOOL isFilteredByFirstHalfGoals;
    BOOL isFilteredBySecondHalfGoals;
    BOOL isFilteredByPlayed;
    BOOL isFilteredByTotalGoals;

    NSMutableArray *cacheGoalsFirstHalf;
    NSMutableArray *cacheGoalsSecondHalf;
    NSMutableArray *cacheNormal;
    NSMutableArray *cacheTotalPlayed;
    NSMutableArray *cacheTotalGoals;
    
    __weak IBOutlet UIView *selLeg;
    
    MBProgressHUD *HUD;

    __weak IBOutlet UIView *topDataView;
    __weak IBOutlet UILabel *formPl;
    
    
    
    __weak IBOutlet UIButton *closeButty;
    
    __weak IBOutlet UISegmentedControl *seg;
    
    NSArray *leaguesArray;
    __weak IBOutlet UIActivityIndicatorView *spinnerrr;
}
@property (weak, nonatomic) IBOutlet UIView *noDataView;
- (IBAction)allHomeAway:(id)sender;

- (IBAction)filterBy1stHalfGoals:(id)sender;

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

- (IBAction)selectLeague:(id)sender;
- (IBAction)selectNumberOfGames:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *entirePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *pickerTitle;

- (IBAction)hidePicker:(id)sender;

- (IBAction)filterGoalsBySecondHalf:(id)sender;

- (IBAction)filterByPlayed:(id)sender;

- (IBAction)filterByTotal:(id)sender;

- (IBAction)showPeek:(id)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *leaguesCollectionView;

@end
