//
//  WidgetExplanationViewController.h
//  Football Form
//
//  Created by Aaron Wilkinson on 28/10/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WidgetExplanationViewController : UIViewController

- (IBAction)showPeek:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
