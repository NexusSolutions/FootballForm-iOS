//
//  WidgetExplanationViewController.m
//  Football Form
//
//  Created by Aaron Wilkinson on 28/10/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import "WidgetExplanationViewController.h"

@interface WidgetExplanationViewController ()

@end

@implementation WidgetExplanationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [_scrollView setContentSize:_contentView.frame.size];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)showPeek:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    [revealController showViewController:revealController.leftViewController];

}
@end
