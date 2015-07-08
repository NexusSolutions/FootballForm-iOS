//
//  FixturesViewController.h
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <iAd/iAd.h>

#define kSetCellSize 195

@interface FixturesViewController : UIViewController <UITabBarDelegate, UITabBarControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate ,MBProgressHUDDelegate, ADBannerViewDelegate> {
    NSMutableArray *fixtureData;
    NSMutableArray *leagueData;
    NSArray *dayArray;
    NSArray *laegueArray;
    __weak IBOutlet UIView *entirePickerView;
    
    NSString *whatPickerViewShouldShow;
    NSString *leagues;
    
    NSString *selectedDay;
    NSString *selectedLeague;
    NSString *selectedLeagueID;
    
    MBProgressHUD *HUD;
    
    //iPhone 4 optimisations
    __weak IBOutlet UIView *navBarButtonView;
    __weak IBOutlet UIImageView *footballIcon;
    
    NSMutableArray *daysArray;
    
    __weak IBOutlet ADBannerView *bannerView;
    BOOL hasGotAd;
    
    NSMutableArray *subLData;
    NSString *initialLID;
    
    BOOL isCupGame;
    
    NSMutableArray *leaguesArray;
    
    NSString *selectedCountry;
    
    __weak IBOutlet UICollectionView *leaguesCollectionView;
    
    __weak IBOutlet UIView *noDataView;
    __weak IBOutlet UIView *selectTheDayView;
    
    BOOL hasReloaded;
    
    float previousScrollViewYOffset;
}
- (IBAction)invokePeek:(id)sender;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerWheel;
- (IBAction)selectDay:(id)sender;
- (IBAction)selectLeague:(id)sender;
- (IBAction)hidePickerView:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *pickerviewTitle;
@property (weak, nonatomic) IBOutlet UIButton *selectDayButton;
@property (weak, nonatomic) IBOutlet UIButton *selectLeagueButton;
@property (weak, nonatomic) IBOutlet UILabel *whatIsChosen;
@property (weak, nonatomic) IBOutlet UILabel *noMatches;
@end
