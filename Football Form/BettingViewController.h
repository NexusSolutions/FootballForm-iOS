//
//  BettingViewController.h
//  Football Form
//
//  Created by Aaron Wilkinson on 03/10/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BettingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)showPeek:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end
