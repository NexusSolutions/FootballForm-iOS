//
//  CompareViewController.h
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompareViewController : UIViewController <UITabBarDelegate, UITabBarControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate> {
    NSString *selectedLeagueID;
    NSMutableArray *leagues;
    NSString *currentLeague;
    __weak IBOutlet UITableView *tableViewOne;
    __weak IBOutlet UITableView *tableViewTwo;
    
    NSMutableArray *listOfTeams;
    
    NSString *selectedTeamIDOne;
    NSString *selectedTeamIDTwo;
    
    __weak IBOutlet UILabel *leagueNameText;
}

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@property (weak, nonatomic) IBOutlet UIView *entirePickerview;
@property (weak, nonatomic) IBOutlet UILabel *pickerTitle;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
- (IBAction)selectLeague:(id)sender;
- (IBAction)hidePicker:(id)sender;
- (IBAction)nextPage:(id)sender;

@end
