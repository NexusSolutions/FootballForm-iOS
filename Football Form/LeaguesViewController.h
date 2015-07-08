//
//  LeaguesViewController.h
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SSZipArchive.h"
#import "API.h"
#import "FixturesViewController.h"
#import <StoreKit/StoreKit.h>

@interface LeaguesViewController : UIViewController <UITabBarDelegate, UITabBarControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SKPaymentTransactionObserver, SKStoreProductViewControllerDelegate, SKRequestDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate> {
    NSTimer *timer;
    
    NSMutableArray *leagueData;
    NSMutableArray *leagueDivisionData;
    NSString *selectedLeagueID;
    
    __weak IBOutlet UILabel *leagueTitle;
    __weak IBOutlet UIView *entirePickerview;
    __weak IBOutlet UIPickerView *pickerView;
    
    BOOL isFilteredPlayed;
    BOOL isFilteredWins;
    BOOL isFilteredDraws;
    BOOL isFilteredLooses;
    BOOL isFilteredGoalsFor;
    BOOL isFilteredGoalsAgainst;
    BOOL isFilteredGoalDifference;
    
    
    BOOL isFilteredByHomePlayed;
    BOOL isFilteredByAwayPlayed;
    
    BOOL isFilteredByHomeWins;
    BOOL isFilteredByAwayWins;
    
    BOOL isFilteredByHomeDraws;
    BOOL isFilteredByAwayDraws;
    
    BOOL isFilteredByHomeLooses;
    BOOL isFilteredByAwayLooses;
    
    BOOL isFilteredByHomeGoalsFor;
    BOOL isFilteredByAwayGoalsFor;
    
    BOOL isFilteredByHomeGoalsAgainst;
    BOOL isFilteredByAwayGoalsAgainst;
    
    BOOL isFilteredByHomeGoalsDifference;
    BOOL isFilteredByAwayGoalsDifference;
    
    NSString *selectedLeague;

    
    NSMutableArray *favouriteArray;
    
    __weak IBOutlet UISegmentedControl *segControl;
    
    NSString *type;
    
    MBProgressHUD *HUD;

    __weak IBOutlet UIView *selLegV;

    
    __weak IBOutlet UIButton *closeButOut;
    
    __weak IBOutlet UIView *teamNameView;
    __weak IBOutlet UIScrollView *teamNameViewSV;
    
    UIImageView *overlayy;
    
    NSMutableArray *leaguesArray;
    
    NSString *selectedCountry;
    
    __weak IBOutlet UICollectionView *leaguesCollectionView;
    __weak IBOutlet UIView *noDataView;
    
    float previousScrollViewYOffset;
    
    BOOL hasReloaded;
    
    BOOL shouldPromptToPurchaseInApp;
    
    NSMutableArray *groupsArray;
    
    NSString *groupText;
    
    BOOL isFilteringByGroups;
    
    double whereIWasLeagueTable;
    double whereIWasGroup;
    
}

@property (weak, nonatomic) IBOutlet UIView *entireWidgetView;
@property (weak, nonatomic) IBOutlet UIView *widgetView;

- (IBAction)closeWidgetView:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *widgetScroll;
@property (weak, nonatomic) IBOutlet UIView *widgetContentView;



@property (weak, nonatomic) IBOutlet UIButton *groupToggleBtn;
- (IBAction)groupToggleAction:(id)sender;



- (IBAction)invokePeek:(id)sender;
- (IBAction)refresh:(id)sender;

- (IBAction)segChanged:(id)sender;

- (IBAction)hidePickerView:(id)sender;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
- (IBAction)showPicker:(id)sender;



- (IBAction)filterByGamesPlayed:(id)sender;
- (IBAction)filterByWins:(id)sender;
- (IBAction)filterByDraws:(id)sender;
- (IBAction)filterByLosses:(id)sender;
- (IBAction)filterByGoalsFor:(id)sender;
- (IBAction)filterByGoalsAgainst:(id)sender;
- (IBAction)filterByGoalDifference:(id)sender;

- (IBAction)clearFilter:(id)sender;
@end




