//
//  TabBarControllerViewController.m
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import "TabBarControllerViewController.h"

@interface TabBarControllerViewController ()

@end

@implementation TabBarControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setSelectedViewController:(UIViewController *)selectedViewController
{
    [super setSelectedViewController:selectedViewController];
    
    if([self.moreNavigationController.viewControllers count] > 1)
    {
        //Modify the view stack to remove the More view
        self.moreNavigationController.viewControllers = [[NSArray alloc] initWithObjects:self.moreNavigationController.visibleViewController, nil];
    }
}
/*
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if ([navigationController isKindOfClass:NSClassFromString(@"UIMoreNavigationController")])
    {
        // We don't need Edit button in More screen.
        UINavigationBar *morenavbar = navigationController.navigationBar;
        UINavigationItem *morenavitem = morenavbar.topItem;
        morenavitem.rightBarButtonItem = nil;
    }
}
*/

@end
