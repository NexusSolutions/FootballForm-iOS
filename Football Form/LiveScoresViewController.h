//
//  LiveScoresViewController.h
//  Football Form
//
//  Created by Aaron Wilkinson on 16/04/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"
#import "LiveScoresDetailViewController.h"
@interface LiveScoresViewController : UIViewController {
    NSMutableArray *gameData;
    NSString *tempMatchID;
    UIRefreshControl *refresh;
    
    NSMutableArray *leagueNames;
    NSMutableArray *sortedData;
    NSArray *alphabet;
}

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
- (IBAction)showPeek:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
