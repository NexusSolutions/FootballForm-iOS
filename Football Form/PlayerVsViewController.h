//
//  PlayerVsViewController.h
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
@interface PlayerVsViewController : UIViewController <UITabBarDelegate, UITabBarControllerDelegate, UISearchBarDelegate> {
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
    
    __weak IBOutlet UILabel *playerVsLabel;
    __weak IBOutlet UILabel *leagueTitle;
    __weak IBOutlet UIView *navvy;
    __weak IBOutlet UILabel *selPlLab;
    __weak IBOutlet ADBannerView *bannerView;
    BOOL hasGotAd;
}
- (IBAction)next:(id)sender;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@property (weak, nonatomic) IBOutlet UITableView *playerOneTableView;
@property (weak, nonatomic) IBOutlet UITableView *playerTwoTableView;

//League filter
- (IBAction)selectLeague:(id)sender;
- (IBAction)closePickerView:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *entirePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
- (IBAction)back:(id)sender;
@end
