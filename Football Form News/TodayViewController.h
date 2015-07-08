//
//  TodayViewController.h
//  Football Form News
//
//  Created by Aaron Wilkinson on 16/10/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *txtLabel;

- (IBAction)viewMoreArticles:(id)sender;

@end
