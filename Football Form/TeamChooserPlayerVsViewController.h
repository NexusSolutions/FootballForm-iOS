//
//  TeamChooserPlayerVsViewController.h
//  Football Form
//
//  Created by Aaron Wilkinson on 24/01/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
@interface TeamChooserPlayerVsViewController : UIViewController <UITabBarDelegate, UITabBarControllerDelegate, UISearchBarDelegate, UIScrollViewDelegate> {
    NSMutableArray *searchDataPlayerOne;
    NSMutableArray *searchDataPlayerTwo;
    
    NSMutableArray *playerDataTableOne;
    NSMutableArray *playerDataTableTwo;
    NSMutableArray *listOfTeams;
    NSMutableArray *playerTeamRelationship;
    
    
    __weak IBOutlet UISearchBar *searchBarTableOne;
    __weak IBOutlet UISearchBar *searchBarTableTwo;
    
    NSArray *searchedDataFirst;
    NSArray *searchedDataSecond;
    BOOL isFirstTableFiltered;
    BOOL isSecondTableFiltered;
    
    NSMutableArray *leagueDivisionData;
    NSString *selectedLeagueID;
    
    __weak IBOutlet UIView *navView;
    __weak IBOutlet UIButton *closeButty;
    __weak IBOutlet UILabel *leagueTitle;
    __weak IBOutlet ADBannerView *bannerView;
    
    NSArray *leaguesArray;
    
    BOOL hasGotAd;
}
@property (weak, nonatomic) IBOutlet UIButton *nextOutOne;
@property (weak, nonatomic) IBOutlet UIButton *nextOutTwo;

@property (weak, nonatomic) IBOutlet UIView *noDataView;

- (IBAction)next:(id)sender;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@property (weak, nonatomic) IBOutlet UITableView *playerOneTableView;
@property (weak, nonatomic) IBOutlet UITableView *playerTwoTableView;

//League filter
- (IBAction)selectLeague:(id)sender;
- (IBAction)closePickerView:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *entirePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

- (IBAction)invokePeek:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *leaguesCollectionView;

@end
