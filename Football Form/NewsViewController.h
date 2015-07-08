//
//  NewsViewController.h
//  Football Form
//
//  Created by Aaron Wilkinson on 23/01/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <iAd/iAd.h>
@interface NewsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
    MBProgressHUD *HUD;
    NSArray *items;
    
    __weak IBOutlet UILabel *titleLeague;
    NSString *leagueName;
    NSString *leagueId;
    NSString *leagueURL;
    
    NSMutableArray *sportDataURL;

    __weak IBOutlet UIButton *closebutty;
    __weak IBOutlet UIView *choseFed;
    __weak IBOutlet ADBannerView *bannerView;
    BOOL hasGotAd;
    
    UIRefreshControl *refreshControl;
    
    NSString *selectedLe;
}
@property (weak, nonatomic) IBOutlet UICollectionView *newsCategoryCollectionView;
- (IBAction)chooseFeed:(id)sender;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *items;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *entirePickerView;
- (IBAction)closePicker:(id)sender;
- (IBAction)showPeek:(id)sender;
@end
