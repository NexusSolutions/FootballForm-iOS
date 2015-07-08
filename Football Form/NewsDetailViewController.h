//
//  NewsDetailViewController.h
//  Football Form
//
//  Created by Aaron Wilkinson on 27/01/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "MBProgressHUD.h"
@interface NewsDetailViewController : UIViewController <UIWebViewDelegate> {
    NSDictionary *newsStory;
    __weak IBOutlet UILabel *theNewsTitle;
    MBProgressHUD *HUD;
    __weak IBOutlet UIWebView *webView;
}
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTV;

- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
- (IBAction)share:(id)sender;
- (IBAction)viewFullArticle:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *shareFullArtView;
@end
