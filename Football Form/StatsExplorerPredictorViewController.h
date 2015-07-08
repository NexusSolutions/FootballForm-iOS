//
//  StatsExplorerPredictorViewController.h
//  Football Form
//
//  Created by Aaron Wilkinson on 06/12/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "MBProgressHUD.h"
@interface StatsExplorerPredictorViewController : UIViewController <SKPaymentTransactionObserver, SKStoreProductViewControllerDelegate, SKRequestDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate, MBProgressHUDDelegate>{
    
    NSMutableArray *teamOneData;
    NSMutableArray *teamTwoData;
    
    NSString *teamOneID;
    NSString *teamTwoID;
    __weak IBOutlet UITableView *tableView1;
    __weak IBOutlet UITableView *tableView2;
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
    
    NSMutableArray *teamOneHomeGames;
    NSMutableArray *teamTwoHomeGames;
    
    int totalTeamOne;
    int totalTeamTwo;
    
    MBProgressHUD *HUD;
    
    __weak IBOutlet UIImageView *homeStar;
    __weak IBOutlet UIImageView *awayStar;
    
    NSMutableArray *teamOnePointsforGraph;
    NSMutableArray *teamTwoPointsforGraph;
    
    __weak IBOutlet UIButton *compGrOut;
    __weak IBOutlet UIView *tpv1;
    __weak IBOutlet UIView *tpv2;
    __weak IBOutlet UILabel *GRrrr;
    __weak IBOutlet UIView *noGameLab;
    __weak IBOutlet UIButton *closeButty;
    __weak IBOutlet UILabel *titLabel;
    
    NSString *leagueI;
}

- (IBAction)btnPlaceBet:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *awayTeamPositionInLeagueTable;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamPositionInLeagueTable;

@property (strong, nonatomic) NSString *statsLeagueID;

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
- (IBAction)back:(id)sender;
- (IBAction)compareGraph:(id)sender;

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

- (IBAction)hidePickerView:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *teamOne;
@property (weak, nonatomic) IBOutlet UILabel *teamTwo;

- (IBAction)showPicker:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *totalPoints1;
@property (weak, nonatomic) IBOutlet UILabel *totalPoints2;


- (IBAction)teamOneSegChanged:(id)sender;
- (IBAction)teamTwoSegChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *teamOneLogo;
@property (weak, nonatomic) IBOutlet UIImageView *teamTwoLogo;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalGoalsAway;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalGoalsHome;
@property (weak, nonatomic) IBOutlet UIImageView *imgTotalGoalsHomeStar;
@property (weak, nonatomic) IBOutlet UIImageView *imgTotalGoalsAwayStar;





@end
